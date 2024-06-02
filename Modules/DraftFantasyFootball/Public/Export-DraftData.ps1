function Export-DraftData {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            ParameterSetName = 'LeagueAndCup'
        )]
        [int]
        $PremRelegationSpots,

        [Parameter(
            Mandatory,
            ParameterSetName = 'LeagueAndCup'
        )]
        [int]
        $FreakRelegationSpots,

        [Parameter(
            Mandatory,
            ParameterSetName = 'LeagueAndCup'
        )]
        [int]
        $VerminRelegationSpots,

        [Parameter(
            Mandatory,
            ParameterSetName = 'LeagueAndCup'
        )]
        [int]
        $PlanktonRelegationSpots,

        [Parameter(
            Mandatory,
            ParameterSetName = 'LeagueAndCup'
        )]
        [int]
        $AlgaeRelegationSpots,

        [Parameter(
            Mandatory,
            ParameterSetName = 'Cup'
        )]
        [switch]
        $CupOnly,

        [Parameter()]
        [int]
        $Year = (Get-DraftYear)
    )

    $ExportFolder = Join-Path -Path $PSScriptRoot -ChildPath "..\Data\$Year"
    New-Item -Path $ExportFolder -ItemType Directory -Force | Out-Null

    $CupFileName = Join-Path -Path $ExportFolder -ChildPath "LeagueCup.xml"
    if (-not (Test-Path $CupFileName)) {
        $CupData = Get-DraftCupInfo -Year $Year
        $CupData | Export-CliXml -Path $CupFileName -Depth 99
    }
    if ($CupOnly) {
        return
    }

    :LeagueLoop foreach ($LeagueName in $Script:ConfigData[$Year].Keys) {
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
                $RelegationSpots = $VerminRelegationSpots
                $PromotionSpots = $FreakRelegationSpots
            }
            'Plankton' {
                $RelegationSpots = $PlanktonRelegationSpots
                $PromotionSpots = $VerminRelegationSpots
            }
            'Algae' {
                $RelegationSpots = $AlgaeRelegationSpots
                $PromotionSpots = $PlanktonRelegationSpots
            }
            'Ecoli' {
                $RelegationSpots = 0
                $PromotionSpots = $AlgaeRelegationSpots
            }
            'Cup' {
                continue LeagueLoop
            }
        }

        $StandingsFileName = Join-Path -Path $ExportFolder -ChildPath "LeagueStandings$LeagueName.xml"
        if (-not (Test-Path $StandingsFileName)) {
            $Standings = Get-DraftLeagueTable -League $LeagueName -Year $Year | Foreach-Object -Begin { $Count = 0 } {
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
            $HeadToHead = Get-DraftHeadToHead -League $LeagueName -Year $Year | Group-Object -Property { [int]$_.Gameweek } -AsHashTable
            $HeadToHead | Export-CliXml -Path $H2HFileName -Depth 99
        }
    }
}
