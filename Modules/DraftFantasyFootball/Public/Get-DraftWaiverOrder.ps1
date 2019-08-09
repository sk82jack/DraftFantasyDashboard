function Get-DraftWaiverOrder {
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
        waiverQueue
    }
}
"@
    $Result = Invoke-ApiQuery -Query $Query
    ConvertTo-DraftObject -InputObject $Result.data.league.waiverQueue -Type 'WaiverOrder' -League $League
}
