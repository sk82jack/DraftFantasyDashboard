function Get-DraftLeagueTable {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Prem', 'Freak', 'Vermin')]
        [string]
        $League
    )
    $LeagueId = $Script:ConfigData[$League]['LeagueId']
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
    }
}
"@
    $Result = Invoke-ApiQuery -Query $Query
    ConvertTo-DraftObject -InputObject $Result.data.leagueTeams -Type 'LeagueTable' -League $League
}
