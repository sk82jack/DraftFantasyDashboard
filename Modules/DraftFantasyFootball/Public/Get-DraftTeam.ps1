Function Get-DraftTeam {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateSet('Prem', 'Freak', 'Vermin')]
        [string]
        $League
    )
    $LeagueId = $Script:ConfigData[$League]['LeagueId']
    $Query = @"
{
    leagueTeams(_id: "$LeagueId") {
        _id
        lineupPlayers {
            _id
            web_name
            element_type_id
        }
        subPlayers {
            _id
            web_name
            element_type_id
        }
    }
}
"@

    $Response = Invoke-ApiQuery -Query $Query
    ConvertTo-DraftObject -InputObject $Response.data.leagueTeams -Type 'Team' -League $League
}
