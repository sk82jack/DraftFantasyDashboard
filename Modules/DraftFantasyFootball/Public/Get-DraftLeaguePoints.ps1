function Get-DraftLeaguePoints {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Prem', 'Freak', 'Vermin')]
        [string]
        $League,

        [Parameter()]
        [int]
        $Gameweek = $Script:BootstrapStatic.events.Where{$_.is_current}.id
    )
    $LeagueId = $Script:ConfigData[$League]['LeagueId']
    $Query = @"
{
    leagueTeams(_id: "$leagueId") {
        _id
        name
        gameweekPoints: liveGameweekPoints(gameweek: $gameweek)
        gameweekHistory(gameweek: $gameweek) {
            lineup
            subs
        }
    }
}
"@
    $Result = Invoke-ApiQuery -Query $Query
    ConvertTo-DraftObject -InputObject $Result.data.leagueTeams -Type 'Points' -League $League
}
