function Get-DraftHeadToHead {
    [CmdletBinding(DefaultParameterSetName = 'Gameweek')]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Prem', 'Freak', 'Vermin')]
        [string]
        $League,

        [Parameter()]
        [int64]
        $Gameweek
    )

    $LeagueId = $Script:ConfigData[$League]['LeagueId']

    if (-not $Gameweek) {
        $Gameweek = $Script:BootstrapStatic.events.Where{$_.is_current}[0].id
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

    ConvertTo-DraftObject -InputObject $Result.data.headToHeadMatches -Type 'HeadToHead' -League $League -Gameweek $Gameweek
}
