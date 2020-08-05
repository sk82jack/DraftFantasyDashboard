function Get-DraftLeaguePoints {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Prem', 'Freak', 'Vermin')]
        [string]
        $League,

        [Parameter()]
        [int[]]
        $Gameweek = $Script:BootstrapStatic.events.Where{$_.is_current}.id,

        [Parameter()]
        [int]
        $Year = (Get-DraftYear)
    )
    $Gameweek = $Gameweek | Foreach-Object {
        if ($_ -gt 38) {
            $_ - 9
        }
        else {
            $_
        }
    }

    $LeagueId = $Script:ConfigData[$Year][$League]['LeagueId']
    $Query = @"
{
    leagueTeams(_id: "$leagueId") {
        _id
        name

"@
    foreach ($Week in $Gameweek) {
        $Query += @"
        gameweek$($Week)Points: liveGameweekPoints(gameweek: $Week)
        gameweek$($Week)History: gameweekHistory(gameweek: $Week) {
            lineup
            subs
            autoSubs {
                in
                out
            }
        }

"@
    }
    $Query += @"
    }
}
"@
    $Result = Invoke-ApiQuery -Query $Query -Year $Year
    ConvertTo-DraftObject -InputObject $Result.data.leagueTeams -Type 'Points' -League $League -Gameweek $Gameweek -Year $Year
}
