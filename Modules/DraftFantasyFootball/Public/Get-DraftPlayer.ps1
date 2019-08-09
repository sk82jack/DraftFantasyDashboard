function Get-DraftPlayer {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet('Prem', 'Freak', 'Vermin')]
        [string]
        $League
    )

    $Query = @"
{
    players {
        _id
        web_name
        team_name_short
        weekly_points
        total_points
        waiverStatus
        rating
    }
}
"@
    $Result = Invoke-ApiQuery -Query $Query
    $ConvertToDraftObjectSplat = @{
        InputObject = $Result.data.players
        Type        = 'Player'
    }
    if ($League) {
        $ConvertToDraftObjectSplat['League'] = $League
    }

    ConvertTo-DraftObject @ConvertToDraftObjectSplat
}
