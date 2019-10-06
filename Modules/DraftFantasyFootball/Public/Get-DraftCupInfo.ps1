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
    $CupHash = @{}
    $Scores = foreach ($League in $Leagues) {
        Get-DraftLeaguePoints -League $League -Gameweek $StartGameweek
    }
    $CupHash[$StartGameweek] = $Scores | Sort-Object -Property Gameweekpoints -Descending

    $EliminatedManagers = [System.Collections.Generic.List[string]]::new()
    foreach ($Gameweek in ($StartGameweek + 1)..$CurrentGW) {
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
        $CupHash[$Gameweek] = $Scores | Sort-Object -Property Gameweekpoints -Descending
    }
    $CupHash
}