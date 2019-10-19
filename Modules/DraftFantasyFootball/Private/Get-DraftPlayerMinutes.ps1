function Get-DraftPlayerMinutes {
    [CmdletBinding()]
    param ()

    $Query = @"
{
    players {
        _id
        fixtures_data {
            gw
            mp
        }
    }
}
"@
    $Result = Invoke-ApiQuery -Query $Query
    $Output = @{}
    foreach ($Player in $Result.data.players) {
        $Output[$Player._id] = @{}
        foreach ($Gameweek in $Player.fixtures_data) {
            $Output[$Player._id][$Gameweek.gw] = $Gameweek.mp
        }
    }
    $Output
}