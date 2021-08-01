function Get-DraftWaiverOrder {
    [CmdletBinding()]
    param (
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
    league(_id: "$LeagueId"){
        waiverQueue
    }
}
"@
    $Result = Invoke-ApiQuery -Query $Query -Year $Year
    ConvertTo-DraftObject -InputObject $Result.data.league.waiverQueue -Type 'WaiverOrder' -League $League -Year $Year
}
