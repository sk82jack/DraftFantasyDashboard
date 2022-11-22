function Start-Dashboard {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]
        $Port = 8585,

        [Parameter()]
        [string]
        $CertificatePath
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

    $BaseEndpoint = New-UDEndpoint -Schedule $Schedule2 -Endpoint {
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

        foreach ($League in 'Prem', 'Freak', 'Vermin', 'Plankton') {
            if ($Cache:Picks[$League].Length -lt 180) {
                $Cache:Picks[$League] = Get-DraftPicks -League $League
            }
        }
    }
    $H2HEndpoint = New-UDEndpoint -Schedule $Schedule15 -Endpoint {
        if ($Cache:InGame) {
            $Cache:H2H = @{
                'Prem'     = Get-DraftHeadToHead -League 'Prem'
                'Freak'    = Get-DraftHeadToHead -League 'Freak'
                'Vermin'   = Get-DraftHeadToHead -League 'Vermin'
                'Plankton' = Get-DraftHeadToHead -League 'Plankton'
            }
        }
    }
    $TablesEndpoint = New-UDEndpoint -Schedule $Schedule15 -Endpoint {
        if ($Cache:InGame) {
            $Cache:Tables = @{
                'Prem'     = Get-DraftLeagueTable -League 'Prem'
                'Freak'    = Get-DraftLeagueTable -League 'Freak'
                'Vermin'   = Get-DraftLeagueTable -League 'Vermin'
                'Plankton' = Get-DraftLeagueTable -League 'Plankton'
            }
        }
    }
    $HourlyEndpoint = New-UDEndpoint -Schedule $Schedule60 -Endpoint {
        $Cache:Charter = Invoke-RestMethod -Uri "https://docs.google.com/document/d/e/2PACX-1vQRuKOpjpCzrxiGALWK6NaxtCcHgbewS3gnFoVB3miKn9DNO52SC5baZ2PQko6Ngo1Mf_wWeKGLuLDv/pub?embedded=true"
        $Cache:Teams = @{
            'Prem'     = Get-DraftTeam -League 'Prem'
            'Freak'    = Get-DraftTeam -League 'Freak'
            'Vermin'   = Get-DraftTeam -League 'Vermin'
            'Plankton' = Get-DraftTeam -League 'Plankton'
        }
        $Cache:H2H = @{
            'Prem'     = Get-DraftHeadToHead -League 'Prem'
            'Freak'    = Get-DraftHeadToHead -League 'Freak'
            'Vermin'   = Get-DraftHeadToHead -League 'Vermin'
            'Plankton' = Get-DraftHeadToHead -League 'Plankton'
        }
        $Cache:Players = @{
            'Prem'     = Get-DraftPlayer -League 'Prem'
            'Freak'    = Get-DraftPlayer -League 'Freak'
            'Vermin'   = Get-DraftPlayer -League 'Vermin'
            'Plankton' = Get-DraftPlayer -League 'Plankton'
        }
        $Cache:Tables = @{
            'Prem'     = Get-DraftLeagueTable -League 'Prem'
            'Freak'    = Get-DraftLeagueTable -League 'Freak'
            'Vermin'   = Get-DraftLeagueTable -League 'Vermin'
            'Plankton' = Get-DraftLeagueTable -League 'Plankton'
        }
        $Cache:Trades = @{
            'Prem'     = Get-DraftTrade -League 'Prem'
            'Freak'    = Get-DraftTrade -League 'Freak'
            'Vermin'   = Get-DraftTrade -League 'Vermin'
            'Plankton' = Get-DraftTrade -League 'Plankton'
        }
        $Cache:Waivers = @{
            'Prem'     = Get-DraftWaiverOrder -League 'Prem'
            'Freak'    = Get-DraftWaiverOrder -League 'Freak'
            'Vermin'   = Get-DraftWaiverOrder -League 'Vermin'
            'Plankton' = Get-DraftWaiverOrder -League 'Plankton'
        }
        $Cache:CupInfo = Get-DraftCupInfo
        $Cache:LeaguePoints = @{
            'Prem'     = Get-DraftLeaguePoints -League 'Prem' -Gameweek (1..$Cache:CurrentGameweek)
            'Freak'    = Get-DraftLeaguePoints -League 'Freak' -Gameweek (1..$Cache:CurrentGameweek)
            'Vermin'   = Get-DraftLeaguePoints -League 'Vermin' -Gameweek (1..$Cache:CurrentGameweek)
            'Plankton' = Get-DraftLeaguePoints -League 'Plankton' -Gameweek (1..$Cache:CurrentGameweek)
        }
    }

    $WeeklyScoresEndpoint = New-UDEndpoint -Url "/weeklyscores/:league" -Method "GET" -Endpoint {
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

    $AllLeagueTeamsEndpoint = New-UDEndpoint -Url "/teams" -Method "GET" -Endpoint {
        $Output = foreach ($LeagueName in $Cache:Teams.Keys) {
            foreach ($Team in $Cache:Teams[$LeagueName]) {
                foreach ($Player in $Team.Players) {
                    [pscustomobject]@{
                        manager            = $Team.Manager
                        player_web_name    = $Player.WebName
                        player_first_name  = $Player.FirstName
                        player_second_name = $Player.SecondName
                    }
                }
            }
        }

        $Request.ContentType = 'text/csv'
        Set-UDContentType -ContentType 'text/csv'
        $Output | ConvertTo-Csv | Out-String
    }

    $TableEndpoint = New-UDEndpoint -Url "/table/:league" -Method "GET" -Endpoint {
        param($League)
        $Output = $Cache:Tables.$League | Select 'Manager', 'Points'

        $Request.ContentType = 'text/csv'
        Set-UDContentType -ContentType 'text/csv'
        $Output | ConvertTo-Csv | Out-String
    }

    $Endpoints = @(
        $BaseEndpoint
        $H2HEndpoint
        $TablesEndpoint
        $HourlyEndpoint
        $WeeklyScoresEndpoint
        $AllLeagueTeamsEndpoint
        $TableEndpoint
    )

    $StartDashboardSplat = @{
        Dashboard       = $Dashboard
        Port            = $Port
        Wait            = $true
        EndPoint        = $Endpoints
        PublishedFolder = $ProfilePics
    }
    if ($CertificatePath) {
        $StartDashboardSplat['Certificate'] = [System.Security.Cryptography.X509Certificates.X509Certificate2]::CreateFromCertFile($CertificatePath)
    }
    try {
        Start-UDDashboard @StartDashboardSplat
    }
    catch {
        Write-Error -Exception $_.Exception
    }
}
