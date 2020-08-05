function Export-DraftData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int]
        $PremRelegationSpots,

        [Parameter(Mandatory)]
        [int]
        $FreakRelegationSpots
    )

    $Date = Get-Date
    $ExportFolder = Join-Path -Path $PSScriptRoot -ChildPath "..\Data\$($Date.Year)"

    New-Item -Path $ExportFolder -ItemType Directory -Force | Out-Null

    foreach ($LeagueName in $Script:ConfigData.Keys) {
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

        $Standings = Get-DraftLeagueTable -League $LeagueName | Foreach-Object -Begin {$Count = 0} {
            $Count++

            if ($Count -le $PromotionSpots) {
                $Promoted = $true
            }
            else {
                $Promoted = $false
            }

            if ($Count -gt ($Script:ConfigData[$LeagueName].Teams.Count - $RelegationSpots)) {
                $Relegated = $true
            }
            else {
                $Relegated = $false
            }

            $_ | Add-Member -MemberType NoteProperty -Name Promoted -Value $Promoted
            $_ | Add-Member -MemberType NoteProperty -Name Relegated -Value $Relegated -PassThru
        }
        $StandingsFileName = Join-Path -Path $ExportFolder -ChildPath "LeagueStandings$LeagueName.xml"
        $Standings | Export-CliXml -Path $StandingsFileName -Depth 99 -NoClobber

        $Picks = Get-DraftPicks -League $LeagueName
        $PicksFileName = Join-Path -Path $ExportFolder -ChildPath "LeaguePicks$LeagueName.xml"
        $Picks | Export-CliXml -Path $PicksFileName -Depth 99 -NoClobber

        $H2HFileName = Join-Path -Path $ExportFolder -ChildPath "LeagueH2H$LeagueName.xml"
        $HeadToHead = @{}
        foreach ($Gameweek in 1..38) {
            $HeadToHead[$Gameweek] = Get-DraftHeadToHead -League $LeagueName -Gameweek $Gameweek
        }
        $HeadToHead | Export-CliXml -Path $H2HFileName -Depth 99 -NoClobber
    }
}
