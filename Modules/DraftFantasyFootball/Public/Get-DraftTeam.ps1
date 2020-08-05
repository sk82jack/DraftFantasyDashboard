Function Get-DraftTeam {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateSet('Prem', 'Freak', 'Vermin')]
        [string]
        $League,

        [Parameter()]
        [int]
        $Year = (Get-DraftYear)
    )
    $LeagueId = $Script:ConfigData[$Year][$League]['LeagueId']
    $Query = @"
{
    leagueTeams(_id: "$LeagueId") {
        _id
        lineupPlayers {
            _id
            web_name
            element_type_id
            team_name_short
            club {
                fixtures {
                    homeTeamShort
                    awayTeamShort
                    gameweek
                }
            }
        }
        subPlayers {
            _id
            web_name
            element_type_id
            team_name_short
            club {
                fixtures {
                    homeTeamShort
                    awayTeamShort
                    gameweek
                }
            }
        }
    }
}
"@

    $Response = Invoke-ApiQuery -Query $Query -Year $Year
    ConvertTo-DraftObject -InputObject $Response.data.leagueTeams -Type 'Team' -League $League -Year $Year
}
