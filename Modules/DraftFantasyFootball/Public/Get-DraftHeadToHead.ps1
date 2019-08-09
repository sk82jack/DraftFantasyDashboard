function Get-DraftHeadToHead {
    [CmdletBinding(DefaultParameterSetName = 'Gameweek')]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Prem', 'Freak', 'Vermin')]
        [string]
        $League,

        [Parameter(
            Mandatory,
            ParameterSetName = 'Gameweek'
        )]
        [int]
        $Gameweek,

        [Parameter(ParameterSetName = 'Current')]
        [switch]
        $Current
    )

    $LeagueId = $Script:ConfigData[$League]['LeagueId']

    if ($Current) {
        $Gameweek = $Script:BootstrapStatic.events | Where-Object -Property is_current
        if ($Gameweek -eq 0) {
            $Gameweek = 1
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

    $Result = Invoke-ApiQuery -Query $Query

    ConvertTo-DraftObject -InputObject $Result.data.headToHeadMatches -Type 'HeadToHead' -League $League
}
