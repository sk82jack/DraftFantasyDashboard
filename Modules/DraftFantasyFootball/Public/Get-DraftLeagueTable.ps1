function Get-DraftLeagueTable {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Prem', 'Freak', 'Vermin')]
        [string]
        $League,

        [Parameter()]
        [int]
        $Year = (Get-DraftYear)
    )
    $LeagueId = $Script:ConfigData[$Year][$League]['LeagueId']
    [int]$Gameweek = $Script:BootstrapStatic.events.Where{$_.is_current}.id
    if ($Gameweek -gt 38) {
        $Gameweek += -9
    }
    $Query = @"
{
    leagueTeams(_id:"$LeagueId") {
        _id
        name
        userId
        totalScore
        weeklyScore
        headToHeadData {
            played
            won
            drawn
            lost
            headToHeadLeaguePoints
        }
        gameweekPoints: liveGameweekPoints(gameweek: $Gameweek)
        gameweekHistory(gameweek: $Gameweek) {
            lineup
            subs
        }
    }
}
"@
    $Result = Invoke-ApiQuery -Query $Query -Year $Year
    $Output = ConvertTo-DraftObject -InputObject $Result.data.leagueTeams -Type 'LeagueTable' -League $League -Year $Year
    $Output | Sort-Object -Property Points, TotalScore -Descending | Foreach-Object -Begin {$i = 1} {
        $_.Position = $i++
        $_
    }
}
