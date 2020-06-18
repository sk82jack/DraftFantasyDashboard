function Get-DraftLeaguePoints {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Prem', 'Freak', 'Vermin')]
        [string]
        $League,

        [Parameter()]
        [int[]]
        $Gameweek = $Script:BootstrapStatic.events.Where{$_.is_current}.id
    )
    if ($Gameweek -gt 38) {
        $Gameweek += -9
    }

    $LeagueId = $Script:ConfigData[$League]['LeagueId']
    $Query = @"
{
    leagueTeams(_id: "$leagueId") {
        _id
        name

"@
    foreach ($Week in $Gameweek) {
        $Query += @"
        gameweek$($Week)Points: liveGameweekPoints(gameweek: $Week)
        gameweek$($Week)History: gameweekHistory(gameweek: $Week) {
            lineup
            subs
            autoSubs {
                in
                out
            }
        }

"@
    }
    $Query += @"
    }
}
"@
    $Result = Invoke-ApiQuery -Query $Query
    ConvertTo-DraftObject -InputObject $Result.data.leagueTeams -Type 'Points' -League $League -Gameweek $Gameweek
}
