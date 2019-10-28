function Get-DraftCupInfo {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]
        $StartGameweek = 6,

        [Parameter()]
        [ValidateSet('Prem', 'Freak', 'Vermin')]
        [string[]]
        $Leagues = @(
            'Prem',
            'Freak'
        )
    )

    $Script:CupCacheFile = $Script:CupCacheFile ??= New-TemporaryFile
    $PreviousGameweeks = Get-Content -Path $Script:CupCacheFile.FullName | ConvertFrom-Json

    $CupHash = @{}
    if ($PreviousGameweeks.$StartGameweek) {
        $CupHash[$StartGameweek] = $PreviousGameweeks.$StartGameweek
    }
    else {
        $Scores = foreach ($League in $Leagues) {
            Get-DraftLeaguePoints -League $League -Gameweek $StartGameweek
        }
        $Output = $Scores | Sort-Object -Property Gameweekpoints -Descending
        $CupHash[$StartGameweek] = $Output
        $PreviousGameweeks = [PSCustomObject]@{
            $StartGameweek = $Output
        }
    }
    $EliminatedManagers = [System.Collections.Generic.List[string]]::new()
    $CurrentGW = $Script:BootstrapStatic.events.Where{$_.is_current}.id

    foreach ($Gameweek in ($StartGameweek + 1)..$CurrentGW) {
        if (($Gameweek -ne $CurrentGW) -and $PreviousGameweeks.$Gameweek) {
            $CupHash[$Gameweek] = $PreviousGameweeks.$Gameweek
        }
        else {
            $EliminationNumber += 1
            $LastGameweekRanking = $CupHash[($Gameweek - 1)]
            $LastCutOffScore = $LastGameweekRanking[-$EliminationNumber].Gameweekpoints
            $LastCutoffManager = $LastGameweekRanking.Where({$_.Gameweekpoints -eq $LastCutoffScore}, 'SkipUntil')
            if ($LastCutoffManager.Count -eq $EliminationNumber) {
                $EliminatedManagers.AddRange([string[]]$LastCutoffManager.Manager)
                $EliminationNumber = 0
            }
            else {
                $UniqueScores = $LastCutoffManager.Gameweekpoints | Sort-Object -Unique
                if ($UniqueScores.count -eq 1) {
                    $EliminationNumber += 1
                }
                else {
                    $LastCutoffManager = foreach ($Score in $UniqueScores) {
                        $ScoreManager = $LastCutoffManager.Where{$_.Gameweekpoints -eq $Score}
                        if ($ScoreManager.Count -lt $EliminationNumber) {
                            $ScoreManager
                            $EliminationNumber = $EliminationNumber - $ScoreManager.Count
                        }
                    }
                    $EliminatedManagers.AddRange([string[]]$LastCutoffManager.Manager)
                }
            }

            $Scores = foreach ($League in $Leagues) {
                Get-DraftLeaguePoints -League $League -Gameweek $Gameweek | Where-Object {
                    $_.Manager -notin $EliminatedManagers
                }
            }
            $Output = $Scores | Sort-Object -Property Gameweekpoints -Descending
            $CupHash[$Gameweek] = $Output
            if ($Gameweek -lt $CurrentGW) {
                $PreviousGameweeks | Add-Member -Name $Gameweek -MemberType NoteProperty -Value $Output
            }
        }
    }
    $PreviousGameweeks | ConvertTo-Json -Depth 5 | Set-Content -Path $Script:CupCacheFile.FullName
    $CupHash
}