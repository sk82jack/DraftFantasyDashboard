function Export-DraftData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int]
        $PremRelegationSpots,

        [Parameter(Mandatory)]
        [int]
        $FreakRelegationSpots,

        [Parameter()]
        [int]
        $Year = (Get-DraftYear)
    )

    $ExportFolder = Join-Path -Path $PSScriptRoot -ChildPath "..\Data\$Year"
    New-Item -Path $ExportFolder -ItemType Directory -Force | Out-Null

    foreach ($LeagueName in $Script:ConfigData[$Year].Keys) {
        switch ($LeagueName) {
            'Prem' {
                $RelegationSpots = $PremRelegationSpots
                $PromotionSpots = 0
            }
            'Freak' {
                $RelegationSpots = $FreakRelegationSpots
                $PromotionSpots = $PremRelegationSpots
            }
            'Vermin' {
                $RelegationSpots = 0
                $PromotionSpots = $FreakRelegationSpots
            }
        }

        $StandingsFileName = Join-Path -Path $ExportFolder -ChildPath "LeagueStandings$LeagueName.xml"
        if (-not (Test-Path $StandingsFileName)) {
            $Standings = Get-DraftLeagueTable -League $LeagueName -Year $Year | Foreach-Object -Begin {$Count = 0} {
                $Count++

                if ($Count -le $PromotionSpots) {
                    $Promoted = $true
                }
                else {
                    $Promoted = $false
                }

                if ($Count -gt ($Script:ConfigData[$Year][$LeagueName].Teams.Count - $RelegationSpots)) {
                    $Relegated = $true
                }
                else {
                    $Relegated = $false
                }

                $_ | Add-Member -MemberType NoteProperty -Name Promoted -Value $Promoted
                $_ | Add-Member -MemberType NoteProperty -Name Relegated -Value $Relegated -PassThru
            }
            $Standings | Export-CliXml -Path $StandingsFileName -Depth 99
        }

        $PicksFileName = Join-Path -Path $ExportFolder -ChildPath "LeaguePicks$LeagueName.xml"
        if (-not (Test-Path $PicksFileName)) {
            $Picks = Get-DraftPicks -League $LeagueName -Year $Year
            $Picks | Export-CliXml -Path $PicksFileName -Depth 99
        }

        $H2HFileName = Join-Path -Path $ExportFolder -ChildPath "LeagueH2H$LeagueName.xml"
        if (-not (Test-Path $H2HFileName)) {
        $HeadToHead = @{}
            foreach ($Gameweek in 1..38) {
                $HeadToHead[$Gameweek] = Get-DraftHeadToHead -League $LeagueName -Gameweek $Gameweek -Year $Year
            }
            $HeadToHead | Export-CliXml -Path $H2HFileName -Depth 99
        }
    }
}
