function Get-DraftPicks {
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
    league(_id: "$LeagueId"){
        draftHistory {
            playerId
            teamId
        }
        draftOrder
    }
}
"@
    $Result = Invoke-ApiQuery -Query $Query
    ConvertTo-DraftObject -InputObject $Result.data.league.draftHistory -Type 'Picks' -League $League
}