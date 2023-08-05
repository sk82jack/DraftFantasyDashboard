function Get-DraftPicks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Prem', 'Freak', 'Vermin', 'Plankton', 'AlgaeN', 'AlgaeS')]
        [string]
        $League,

        [Parameter()]
        [int]
        $Year = (Get-DraftYear)
    )

    $LeagueId = $Script:ConfigData[$Year][$League]['LeagueId']

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
    $Result = Invoke-ApiQuery -Query $Query -Year $Year
    ConvertTo-DraftObject -InputObject $Result.data.league.draftHistory -Type 'Picks' -League $League -Year $Year
}