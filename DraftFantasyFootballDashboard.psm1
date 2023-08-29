function Start-Dashboard {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]
        $Port = 8585
    )
    $Pages = @()
    $Pages += . (Join-Path $PSScriptRoot "Pages/fixtures.ps1")

    Get-ChildItem (Join-Path $PSScriptRoot "Pages") -Exclude "fixtures.ps1" | ForEach-Object {
        $Pages += . $_.FullName
    }

    $ProfilePics = Publish-UDFolder -Path "$PSScriptRoot/Images/profile_pics" -RequestPath "/profile_pics"

    $BHEndpoints = New-UDEndpointInitialization -Module 'Modules/DraftFantasyFootball/DraftFantasyFootball.psd1'
    $ThemeDefinition = Import-PowerShellDataFile -Path (Join-Path $PSScriptRoot '/Themes/DraftFantasy.ps1')
    $Theme = New-UDTheme -Name $ThemeDefinition['Name'] -Definition $ThemeDefinition['Definition']

    $Navigation = New-UDSideNav -Content {
        New-UDSideNavItem -Text 'Fixtures' -PageName 'Fixtures' -Icon calendar_alt
        New-UDSideNavItem -Text 'League Standings' -PageName 'Tables' -Icon futbol
        New-UDSideNavItem -Text 'Cup' -PageName 'Cup' -Icon trophy
        New-UDSideNavItem -Text 'Stats' -PageName 'Stats' -Icon chart_bar
        New-UDSideNavItem -Text 'Managers' -PageName 'Managers' -Icon users
        New-UDSideNavItem -Text 'Player List' -PageName 'Players' -Icon user
        New-UDSideNavItem -Text 'Trades' -PageName 'Trades' -Icon exchange_alt
        New-UDSideNavItem -Text 'Draft Order' -PageName 'Picks' -Icon list_ol
        New-UDSideNavItem -Text 'History' -PageName 'History' -Icon history
        New-UDSideNavItem -Text 'Charter' -PageName 'Charter' -Icon gavel
    }

    $DashboardSplat = @{
        Title                  = 'Draft Fantasy Football'
        Pages                  = $Pages
        EndpointInitialization = $BHEndpoints
        Theme                  = $Theme
        Navigation             = $Navigation
    }
    $Dashboard = New-UDDashboard @DashboardSplat

    $Schedule2 = New-UDEndpointSchedule -Every 2 -Minute
    $Schedule15 = New-UDEndpointSchedule -Every 15 -Minute
    $Schedule60 = New-UDEndpointSchedule -Every 1 -Hour

    $BaseSchedEndpoint = New-UDEndpoint -Schedule $Schedule2 -Endpoint {
        [int]$Gameweek = (Get-FplBootstrapStatic).events.Where{$_.is_current}.id
        $Cache:CurrentGameweek = $Gameweek
        if ($Cache:CurrentGameweek -gt 38) {
            $Cache:CurrentGameweek += -9
        }
        $Fixtures = Invoke-RestMethod -Uri 'https://fantasy.premierleague.com/api/fixtures/'
        $GameweekFixtures = $Fixtures.Where{$_.event -eq $Gameweek}
        $Time = [datetime]::UtcNow
        foreach ($Fixture in $GameweekFixtures) {
            $GameOngoing = ($Time -gt $Fixture.kickoff_time) -and ($Time -lt $Fixture.kickoff_time.AddHours(3))

            if ($GameOngoing -eq $true) {
                $Cache:InGame = $true
                break
            }
        }

        if (-not $Cache:Picks) {
            $Cache:Picks = @{}
        }

        foreach ($League in 'Prem', 'Freak', 'Vermin', 'Plankton', 'AlgaeN', 'AlgaeS') {
            if ($Cache:Picks[$League].Length -lt 180) {
                $Cache:Picks[$League] = Get-DraftPicks -League $League
            }
        }
    }
    $H2HSchedEndpoint = New-UDEndpoint -Schedule $Schedule15 -Endpoint {
        if ($Cache:InGame) {
            $Cache:H2H = @{
                'Prem'     = Get-DraftHeadToHead -League 'Prem'
                'Freak'    = Get-DraftHeadToHead -League 'Freak'
                'Vermin'   = Get-DraftHeadToHead -League 'Vermin'
                'Plankton' = Get-DraftHeadToHead -League 'Plankton'
                'AlgaeN'   = Get-DraftHeadToHead -League 'AlgaeN'
                'AlgaeS'   = Get-DraftHeadToHead -League 'AlgaeS'
            }
        }
    }
    $TablesSchedEndpoint = New-UDEndpoint -Schedule $Schedule15 -Endpoint {
        if ($Cache:InGame) {
            $Cache:Tables = @{
                'Prem'     = Get-DraftLeagueTable -League 'Prem'
                'Freak'    = Get-DraftLeagueTable -League 'Freak'
                'Vermin'   = Get-DraftLeagueTable -League 'Vermin'
                'Plankton' = Get-DraftLeagueTable -League 'Plankton'
                'AlgaeN'   = Get-DraftLeagueTable -League 'AlgaeN'
                'AlgaeS'   = Get-DraftLeagueTable -League 'AlgaeS'
            }
        }
    }
    $HourlySchedEndpoint = New-UDEndpoint -Schedule $Schedule60 -Endpoint {
        $Cache:Charter = Invoke-RestMethod -Uri "https://docs.google.com/document/d/e/2PACX-1vQRuKOpjpCzrxiGALWK6NaxtCcHgbewS3gnFoVB3miKn9DNO52SC5baZ2PQko6Ngo1Mf_wWeKGLuLDv/pub?embedded=true"
        $Cache:Teams = @{
            'Prem'     = Get-DraftTeam -League 'Prem'
            'Freak'    = Get-DraftTeam -League 'Freak'
            'Vermin'   = Get-DraftTeam -League 'Vermin'
            'Plankton' = Get-DraftTeam -League 'Plankton'
            'AlgaeN'   = Get-DraftTeam -League 'AlgaeN'
            'AlgaeS'   = Get-DraftTeam -League 'AlgaeS'
        }
        $Cache:H2H = @{
            'Prem'     = Get-DraftHeadToHead -League 'Prem'
            'Freak'    = Get-DraftHeadToHead -League 'Freak'
            'Vermin'   = Get-DraftHeadToHead -League 'Vermin'
            'Plankton' = Get-DraftHeadToHead -League 'Plankton'
            'AlgaeN'   = Get-DraftHeadToHead -League 'AlgaeN'
            'AlgaeS'   = Get-DraftHeadToHead -League 'AlgaeS'
        }
        $Cache:Players = @{
            'Prem'     = Get-DraftPlayer -League 'Prem'
            'Freak'    = Get-DraftPlayer -League 'Freak'
            'Vermin'   = Get-DraftPlayer -League 'Vermin'
            'Plankton' = Get-DraftPlayer -League 'Plankton'
            'AlgaeN'   = Get-DraftPlayer -League 'AlgaeN'
            'AlgaeS'   = Get-DraftPlayer -League 'AlgaeS'
        }
        $Cache:Tables = @{
            'Prem'     = Get-DraftLeagueTable -League 'Prem'
            'Freak'    = Get-DraftLeagueTable -League 'Freak'
            'Vermin'   = Get-DraftLeagueTable -League 'Vermin'
            'Plankton' = Get-DraftLeagueTable -League 'Plankton'
            'AlgaeN'   = Get-DraftLeagueTable -League 'AlgaeN'
            'AlgaeS'   = Get-DraftLeagueTable -League 'AlgaeS'
        }
        $Cache:Trades = @{
            'Prem'     = Get-DraftTrade -League 'Prem'
            'Freak'    = Get-DraftTrade -League 'Freak'
            'Vermin'   = Get-DraftTrade -League 'Vermin'
            'Plankton' = Get-DraftTrade -League 'Plankton'
            'AlgaeN'   = Get-DraftTrade -League 'AlgaeN'
            'AlgaeS'   = Get-DraftTrade -League 'AlgaeS'
        }
        $Cache:Waivers = @{
            'Prem'     = Get-DraftWaiverOrder -League 'Prem'
            'Freak'    = Get-DraftWaiverOrder -League 'Freak'
            'Vermin'   = Get-DraftWaiverOrder -League 'Vermin'
            'Plankton' = Get-DraftWaiverOrder -League 'Plankton'
            'AlgaeN'   = Get-DraftWaiverOrder -League 'AlgaeN'
            'AlgaeS'   = Get-DraftWaiverOrder -League 'AlgaeS'
        }
        $Cache:CupInfo = Get-DraftCupInfo
        $Cache:LeaguePoints = @{
            'Prem'     = Get-DraftLeaguePoints -League 'Prem' -Gameweek (1..$Cache:CurrentGameweek)
            'Freak'    = Get-DraftLeaguePoints -League 'Freak' -Gameweek (1..$Cache:CurrentGameweek)
            'Vermin'   = Get-DraftLeaguePoints -League 'Vermin' -Gameweek (1..$Cache:CurrentGameweek)
            'Plankton' = Get-DraftLeaguePoints -League 'Plankton' -Gameweek (1..$Cache:CurrentGameweek)
            'AlgaeN'   = Get-DraftLeaguePoints -League 'AlgaeN' -Gameweek (1..$Cache:CurrentGameweek)
            'AlgaeS'   = Get-DraftLeaguePoints -League 'AlgaeS' -Gameweek (1..$Cache:CurrentGameweek)
        }
    }

    $WeeklyScoresApiEndpoint = New-UDEndpoint -Url "/weeklyscores/:league" -Method "GET" -Endpoint {
        param($League)
        $Output = foreach ($Week in 1..$Cache:CurrentGameweek) {
            $WeekScores = @{}

            foreach ($Team in $Cache:LeaguePoints.$League) {
                $WeekScores[$Team.Manager] = $Team."Gameweek$($Week)points"
            }

            [pscustomobject]$WeekScores
        }

        $Request.ContentType = 'text/csv'
        Set-UDContentType -ContentType 'text/csv'
        $Output | ConvertTo-Csv | Out-String
    }

    $AllLeagueTeamsApiEndpoint = New-UDEndpoint -Url "/teams" -Method "GET" -Endpoint {
        $Output = foreach ($LeagueName in $Cache:Teams.Keys) {
            foreach ($Team in $Cache:Teams[$LeagueName]) {
                foreach ($Player in $Team.Players) {
                    [pscustomobject]@{
                        manager            = $Team.Manager
                        player_web_name    = $Player.o_web_name
                        player_first_name  = $Player.o_first_name
                        player_second_name = $Player.o_second_name
                    }
                }
            }
        }

        $Request.ContentType = 'text/csv; charset=utf-8'
        Set-UDContentType -ContentType 'text/csv; charset=utf-8'
        $Output | ConvertTo-Csv | Out-String
    }

    $TableApiEndpoint = New-UDEndpoint -Url "/table/:league" -Method "GET" -Endpoint {
        param($League)
        $Output = $Cache:Tables.$League | Select-Object 'Manager', 'Points'

        $Request.ContentType = 'text/csv; charset=utf-8'
        Set-UDContentType -ContentType 'text/csv; charset=utf-8'
        $Output | ConvertTo-Csv | Out-String
    }

    $H2HApiEndpoint = New-UDEndpoint -Url "/h2h/:league/:gameweek" -Method "GET" -Endpoint {
        param(
            $League,
            $Gameweek
        )
        $Output = if ($Gameweek) {
            $Cache:H2H.$League.Where{$_.Gameweek -eq $Gameweek}
        }
        else {
            $Cache:H2H.$League
        }

        $Output | ConvertTo-Json -Depth 99
    }

    $TradesApiEndpoint = New-UDEndpoint -Url "/trades/:league/:count" -Method "GET" -Endpoint {
        param(
            $League,
            $Count = 50
        )
        $Trades = Get-DraftTrade -League $League -TradeCount $Count
        $Output = foreach ($Trade in $Trades) {
            if ($Trade.Status -ne 'accepted') {
                continue
            }

            for ($i = 0; $i -lt $Trade.Playersinids.Count; $i++) {
                [pscustomobject]@{
                    type                   = $Trade.type
                    timestamp              = $Trade.respondedAt
                    out_manager            = $Trade.OutManager
                    out_player_web_name    = $Trade.o_players_out_web_name[$i]
                    out_player_first_name  = $Trade.o_players_out_first_name[$i]
                    out_player_second_name = $Trade.o_players_out_second_name[$i]
                    in_manager             = $Trade.InManager
                    in_player_web_name     = $Trade.o_players_in_web_name[$i]
                    in_player_first_name   = $Trade.o_players_in_first_name[$i]
                    in_player_second_name  = $Trade.o_players_in_second_name[$i]
                }
            }
        }

        $Request.ContentType = 'text/csv; charset=utf-8'
        Set-UDContentType -ContentType 'text/csv; charset=utf-8'
        $Output | ConvertTo-Csv | Out-String
    }

    $Endpoints = @(
        $BaseSchedEndpoint
        $H2HSchedEndpoint
        $TablesSchedEndpoint
        $HourlySchedEndpoint
        $WeeklyScoresApiEndpoint
        $AllLeagueTeamsApiEndpoint
        $TableApiEndpoint
        $H2HApiEndpoint
        $TradesApiEndpoint
    )

    $StartDashboardSplat = @{
        Dashboard       = $Dashboard
        Port            = $Port
        Wait            = $true
        EndPoint        = $Endpoints
        PublishedFolder = $ProfilePics
    }

    try {
        Start-UDDashboard @StartDashboardSplat
    }
    catch {
        Write-Error -Exception $_.Exception
    }
}
