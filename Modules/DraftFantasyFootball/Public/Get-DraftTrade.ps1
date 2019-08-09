Function Get-DraftTrade {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateSet('Prem', 'Freak', 'Vermin')]
        [string]
        $League
    )
    $LeagueId = $Script:ConfigData[$League]['LeagueId']
    $Query = @"
{
    trades(leagueId:"$LeagueId") {
        _id
        createdAt
        updatedAt
        respondedAt
        outTeamId
        inTeamId
        status
        type
        playersInIds
        playersOutIds
    }
}
"@

    $Response = Invoke-ApiQuery -Query $Query
    ConvertTo-DraftObject -InputObject $Response.data.trades -Type 'Trade' -League $League
}
