function Invoke-AutoSubs {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $LineupIds,

        [Parameter(Mandatory)]
        $SubIds,

        [Parameter()]
        $PlayerMinutes
    )
    if (-not $PlayerMinutes) {
        $PlayerMinutes = Get-DraftPlayerMinutes
    }
    $Date = Get-Date
    $Gameweek = $Script:BootstrapStatic.events.Where{$_.is_current}.id
    $GameweekLineup = Assert-FplLineup -Lineup $LineupIds
    $SubsStillToPlay = $SubIds.Where{
        -not $PlayerMinutes[$_][$Gameweek]['Minutes'] -and
        -not $PlayerMinutes[$_][$Gameweek]['GameFinished']
    }
    if (-not $SubsStillToPlay) {
        $AutoSubOff = $LineupIds.Where{
            -not $PlayerMinutes[$_][$Gameweek]['Minutes'] -and
            $PlayerMinutes[$_][$Gameweek]['GameFinished']
        }
        $AutoSubOn = $SubIds.Where{
            $PlayerMinutes[$_][$Gameweek]['Minutes']
        }
        foreach ($Player in $AutoSubOff) {
            foreach ($Sub in $AutoSubOn) {
                $NewLineup = ($LineupIds -notmatch $Player) + $Sub
                $ValidLineup = Assert-FplLineup -Lineup $NewLineup
                if ($ValidLineup) {
                    $LineupIds = $NewLineup
                    $GameweekLineup = $ValidLineup
                    $AutoSubOn = $AutoSubOn -notmatch $Sub
                    break
                }
            }
        }
    }

    $GameweekLineup
}