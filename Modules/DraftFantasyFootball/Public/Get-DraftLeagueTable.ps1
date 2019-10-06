function Get-DraftLeagueTable {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Prem', 'Freak', 'Vermin')]
        [string]
        $League
    )
    $LeagueId = $Script:ConfigData[$League]['LeagueId']
    $Gameweek = $Script:BootstrapStatic.events.Where{$_.is_current}.id
    $Query = @"
{
    leagueTeams(_id:"$LeagueId") {
        _id
        name
        userId
        totalScore
        weeklyScore
        headToHeadData {
            played
            won
            drawn
            lost
            headToHeadLeaguePoints
        }
        gameweekPoints: liveGameweekPoints(gameweek: $gameweek)
    }
}
"@
    $Result = Invoke-ApiQuery -Query $Query
    $Output = ConvertTo-DraftObject -InputObject $Result.data.leagueTeams -Type 'LeagueTable' -League $League
    $Output | Sort-Object -Property Points, TotalScore -Descending
}
