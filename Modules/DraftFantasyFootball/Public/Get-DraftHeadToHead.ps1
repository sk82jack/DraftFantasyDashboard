function Get-DraftHeadToHead {
    [CmdletBinding(DefaultParameterSetName = 'Gameweek')]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Prem', 'Freak', 'Vermin', 'Plankton', 'AlgaeN', 'AlgaeS')]
        [string]
        $League,

        [Parameter()]
        [int64[]]
        $Gameweek = 1..38,

        [Parameter()]
        [int]
        $Year = (Get-DraftYear)
    )

    $LeagueId = $Script:ConfigData[$Year][$League]['LeagueId']

    $Query = @"
{
"@
    foreach ($Week in $Gameweek) {
        $Query += @"
    Gameweek${Week}: headToHeadMatches(leagueId: "$LeagueId", gameweek: $Week) {
        gameweek
        _id
        team1Id
        team2Id
        team1Score
        team2Score
    }

"@
    }

    $Query += @"
}
"@

    $Result = Invoke-ApiQuery -Query $Query -Year $Year
    foreach ($Week in $Gameweek) {
        ConvertTo-DraftObject -InputObject $Result.data."Gameweek$Week" -Type 'HeadToHead' -League $League -Year $Year
    }
}
