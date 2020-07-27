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

    $CurrentGW = $Script:BootstrapStatic.events.Where{$_.is_current}.id
    if ($CurrentGW -gt 38) {
        $CurrentGW += -9
    }

    $Scores = foreach ($League in $Leagues) {
        Get-DraftLeaguePoints -League $League -Gameweek ($StartGameweek..$CurrentGW)
    }

    $CupHash = @{}
    $CupHash[$StartGameweek] = $Scores | Sort-Object -Property "Gameweek$($StartGameweek)points" -Descending | Select-Object -ExcludeProperty 'Gameweekpoints' -Property *, @{
        Name       = 'Gameweekpoints'
        Expression = {$_."Gameweek$($StartGameweek)points"}
    }
    $EliminatedManagers = [System.Collections.Generic.List[string]]::new()

    foreach ($Gameweek in ($StartGameweek + 1)..$CurrentGW) {
        $EliminationNumber += 1
        if ($EliminationNumber -eq $Scores.Count) {
            $EliminationNumber -= 1
        }

        $LastGameweek = $Gameweek - 1
        $LastGameweekRanking = $CupHash[$LastGameweek]
        $LastCutOffScore = $LastGameweekRanking[ - $EliminationNumber]."Gameweekpoints"
        $LastCutoffManager = $LastGameweekRanking.Where( {$_."Gameweekpoints" -eq $LastCutoffScore}, 'SkipUntil')

        if ($LastCutoffManager.Count -eq $EliminationNumber) {
            $LastCutoffManager | Add-Member -MemberType NoteProperty -Name Eliminated -Value $true
            $EliminatedManagers.AddRange([string[]]$LastCutoffManager.Manager)
            $EliminationNumber = 0
        }
        else {
            $UniqueScores = $LastCutoffManager."Gameweekpoints" | Sort-Object -Unique

            if ($UniqueScores.count -ne 1) {
                $LastCutoffManager = foreach ($Score in $UniqueScores) {
                    $ScoreManager = $LastCutoffManager.Where{$_."Gameweekpoints" -eq $Score}

                    if ($ScoreManager.Count -lt $EliminationNumber) {
                        $ScoreManager
                        $EliminationNumber = $EliminationNumber - $ScoreManager.Count
                    }
                }
                $LastCutoffManager | Add-Member -MemberType NoteProperty -Name Eliminated -Value $true
                $EliminatedManagers.AddRange([string[]]$LastCutoffManager.Manager)
            }
        }

        $Scores = $Scores.Where{
            $_.Manager -notin $EliminatedManagers
        }

        $Properties = [System.Collections.Generic.List[psobject]]@(
            '*'
            @{
                Name       = 'Gameweekpoints'
                Expression = {$_."Gameweek$($Gameweek)points"}
            }
            @{
                Name       = 'Winner'
                Expression = {$false}
            }
        )

        if (@($Scores).Count -eq 1) {
            $Properties[2]['Expression'] = {$true}
        }

        $CupHash[$Gameweek] = $Scores | Sort-Object -Property "Gameweek$($Gameweek)points" -Descending | Select-Object -ExcludeProperty 'Gameweekpoints' -Property $Properties

        if (@($Scores).Count -eq 1) {
            break
        }
    }
    $CupHash
}
