Function Get-DraftTrade {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateSet('Prem', 'Freak', 'Vermin', 'Plankton')]
        [string]
        $League,

        [Parameter()]
        [int]
        $Year = (Get-DraftYear)
    )
    $LeagueId = $Script:ConfigData[$Year][$League]['LeagueId']
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

    $Response = Invoke-ApiQuery -Query $Query -Year $Year
    ConvertTo-DraftObject -InputObject $Response.data.trades -Type 'Trade' -League $League -Year $Year
}
