function Assert-FplLineup {
    [CmdletBinding()]
    param (
        [PSObject[]]
        $Lineup
    )

    $Lineup = $Script:DraftPlayers.Where{$_.Id -in $Lineup}
    $LineupPlayers = @{
        GoalKeepers = $Lineup.Where{$_.TypeName -eq 'GoalKeeper'}
        Defenders   = $Lineup.Where{$_.TypeName -eq 'Defender'}
        Midfielders = $Lineup.Where{$_.TypeName -eq 'Midfielder'}
        Forwards    = $Lineup.Where{$_.TypeName -eq 'Forward'}
    }

    $ValidKeeper = $LineupPlayers['GoalKeepers'].count -eq 1
    $ValidDefenders = $LineupPlayers['Defenders'].count -in 3..5
    $ValidMidfielders = $LineupPlayers['Midfielders'].count -in 2..5
    $ValidForwards = $LineupPlayers['Forwards'].count -in 1..3

    if ($ValidKeeper -and $ValidDefenders -and $ValidMidfielders -and $ValidForwards) {
        $Lineup
    }
}
