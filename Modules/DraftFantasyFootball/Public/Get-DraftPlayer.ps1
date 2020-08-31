function Get-DraftPlayer {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet('Prem', 'Freak', 'Vermin')]
        [string]
        $League,

        [Parameter()]
        [int]
        $Year = (Get-DraftYear)
    )

    $Gameweek = $Script:BootstrapStatic.events.Where{$_.is_current}.id
    if ($Gameweek -eq 0) {
        $Gameweek = 1
    }
    elseif ($Gameweek -gt 38) {
        $Gameweek += -9
    }
    $LeagueId = $Script:ConfigData[$Year]['Prem']['LeagueId']
    $Query = @"
{
    players {
        _id
        web_name
        team_name_short
        gameweekPoints: customGameweekPoints(gameweek: $Gameweek, leagueId: "$LeagueId")
        total_points
        waiverStatus
        rating
        type_name
        club {
            fixtures {
                date
                gameweek
            }
        }
    }
}
"@
    $Result = Invoke-ApiQuery -Query $Query -Year $Year
    $ConvertToDraftObjectSplat = @{
        InputObject = $Result.data.players
        Type        = 'Player'
        Year        = $Year
    }
    if ($League) {
        $ConvertToDraftObjectSplat['League'] = $League
    }

    ConvertTo-DraftObject @ConvertToDraftObjectSplat
}
