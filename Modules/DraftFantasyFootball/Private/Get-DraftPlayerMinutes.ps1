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
        club {
            fixtures {
                date
            }
        }
    }
}
"@
    $Result = Invoke-ApiQuery -Query $Query
    $Output = @{}
    foreach ($Player in $Result.data.players) {
        $Output[$Player._id] = @{}
        foreach ($Gameweek in $Player.fixtures_data) {
            $MatchStart = ConvertFrom-PosixTime -PosixTime $Player.club.fixtures.date[($Gameweek.gw - 1)]
            $Output[$Player._id][$Gameweek.gw] = @{
                Minutes = $Gameweek.mp
                GameFinished = $MatchStart.AddHours(2) -lt $Date
            }
        }
    }
    $Output
}