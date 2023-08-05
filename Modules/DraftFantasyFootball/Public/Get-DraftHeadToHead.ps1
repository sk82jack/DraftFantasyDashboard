function Get-DraftHeadToHead {
    [CmdletBinding(DefaultParameterSetName = 'Gameweek')]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Prem', 'Freak', 'Vermin', 'Plankton', 'AlgaeN', 'AlgaeS')]
        [string]
        $League,

        [Parameter()]
        [int64]
        $Gameweek,

        [Parameter()]
        [int]
        $Year = (Get-DraftYear)
    )

    $LeagueId = $Script:ConfigData[$Year][$League]['LeagueId']

    if (-not $Gameweek) {
        $Gameweek = $Script:BootstrapStatic.events.Where{$_.is_current}[0].id
        if ($Gameweek -eq 0) {
            $Gameweek = 1
        }
        elseif ($Gameweek -gt 38) {
            $Gameweek += -9
        }
    }

    $Query = @"
{
    headToHeadMatches(leagueId: "$LeagueId", gameweek: $Gameweek) {
        gameweek
        _id
        team1Id
        team2Id
        team1Score
        team2Score
    }
}
"@

    $Result = Invoke-ApiQuery -Query $Query -Year $Year

    ConvertTo-DraftObject -InputObject $Result.data.headToHeadMatches -Type 'HeadToHead' -League $League -Gameweek $Gameweek -Year $Year
}
