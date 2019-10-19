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
    $AutoSubOff = $LineupIds.Where{
        $Id = $_
        -not $PlayerMinutes[$Id][$Gameweek] -and
        $Date -gt $Script:DraftPlayers.Where{
            $_.Id -eq $Id
        }.Club.fixtures.Where{
            $_.gameweek -eq $Gameweek
        }.date.AddMinutes(90)
    }
    $AutoSubOn = $SubIds.Where{
        $PlayerMinutes[$_][$Gameweek]
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
    $GameweekLineup
}