function Get-DraftPlayer {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet('Prem', 'Freak', 'Vermin')]
        [string]
        $League
    )

    $Gameweek = $Script:BootstrapStatic.events.Where{$_.is_current}.id
    $LeagueId = $Script:ConfigData['Prem']['LeagueId']
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
