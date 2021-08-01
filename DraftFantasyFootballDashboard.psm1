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
        New-UDSideNavItem -Text 'Managers' -PageName 'Managers' -Icon users
        New-UDSideNavItem -Text 'Player List' -PageName 'Players' -Icon user
        New-UDSideNavItem -Text 'Trades' -PageName 'Trades' -Icon exchange_alt
        New-UDSideNavItem -Text 'Draft Order' -PageName 'Picks' -Icon list_ol
        New-UDSideNavItem -Text 'History' -PageName 'History' -Icon history
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
    $Schedule5 = New-UDEndpointSchedule -Every 5 -Minute
    $Schedule60 = New-UDEndpointSchedule -Every 1 -Hour

    $BaseEndpoint = New-UDEndpoint -Schedule $Schedule2 -Endpoint {
        [int]$Gameweek = (Get-FplBootstrapStatic).events.Where{$_.is_current}.id
        $Cache:CurrentGameweek = $Gameweek
        if ($Cache:CurrentGameweek -gt 38) {
            $Cache:CurrentGameweek += -9
        }
        $Fixtures = Invoke-RestMethod -Uri 'https://fantasy.premierleague.com/api/fixtures/'
        $GameweekFixtures = $Fixtures.Where{$_.event -eq $Gameweek}
        $Cache:InGame = foreach ($Fixture in $GameweekFixtures) {
            ($Time -gt $Fixture.kickoff_time) -and ($Time -lt $Fixture.kickoff_time.AddHours(2))
            break
        }

        if (-not $Cache:Picks) {
            $Cache:Picks = @{}
        }

        foreach ($League in 'Prem', 'Freak', 'Vermin', 'Plankton') {
            if (-not $Cache:Picks[$League]) {
                $Cache:Picks[$League] = Get-DraftPicks -League $League
            }
        }
    }
    $TeamsEndpoint = New-UDEndpoint -Schedule $Schedule5 -Endpoint {
        if ($Cache:InGame) {
            $Cache:Teams = @{
                'Prem'     = Get-DraftTeam -League 'Prem'
                'Freak'    = Get-DraftTeam -League 'Freak'
                'Vermin'   = Get-DraftTeam -League 'Vermin'
                'Plankton' = Get-DraftTeam -League 'Plankton'
            }
        }
    }
    $H2HEndpoint = New-UDEndpoint -Schedule $Schedule5 -Endpoint {
        if ($Cache:InGame) {
            $Cache:H2H = @{
                'Prem'     = Get-DraftHeadToHead -League 'Prem'
                'Freak'    = Get-DraftHeadToHead -League 'Freak'
                'Vermin'   = Get-DraftHeadToHead -League 'Vermin'
                'Plankton' = Get-DraftHeadToHead -League 'Plankton'
            }
        }
    }
    $PlayersEndpoint = New-UDEndpoint -Schedule $Schedule5 -Endpoint {
        if ($Cache:InGame) {
            $Cache:Players = @{
                'Prem'     = Get-DraftPlayer -League 'Prem'
                'Freak'    = Get-DraftPlayer -League 'Freak'
                'Vermin'   = Get-DraftPlayer -League 'Vermin'
                'Plankton' = Get-DraftPlayer -League 'Plankton'
            }
        }
    }
    $TablesEndpoint = New-UDEndpoint -Schedule $Schedule5 -Endpoint {
        if ($Cache:InGame) {
            $Cache:Tables = @{
                'Prem'     = Get-DraftLeagueTable -League 'Prem'
                'Freak'    = Get-DraftLeagueTable -League 'Freak'
                'Vermin'   = Get-DraftLeagueTable -League 'Vermin'
                'Plankton' = Get-DraftLeagueTable -League 'Plankton'
            }
        }
    }
    $TradesEndpoint = New-UDEndpoint -Schedule $Schedule5 -Endpoint {
        if ($Cache:InGame) {
            $Cache:Trades = @{
                'Prem'     = Get-DraftTrade -League 'Prem'
                'Freak'    = Get-DraftTrade -League 'Freak'
                'Vermin'   = Get-DraftTrade -League 'Vermin'
                'Plankton' = Get-DraftTrade -League 'Plankton'
            }
        }
    }
    $WaiversEndpoint = New-UDEndpoint -Schedule $Schedule5 -Endpoint {
        if ($Cache:InGame) {
            $Cache:Waivers = @{
                'Prem'     = Get-DraftWaiverOrder -League 'Prem'
                'Freak'    = Get-DraftWaiverOrder -League 'Freak'
                'Vermin'   = Get-DraftWaiverOrder -League 'Vermin'
                'Plankton' = Get-DraftWaiverOrder -League 'Plankton'
            }
        }
    }
    $CupEndpoint = New-UDEndpoint -Schedule $Schedule5 -Endpoint {
        if ($Cache:InGame) {
            $Cache:CupInfo = Get-DraftCupInfo
        }
    }
    $HourlyEndpoint = New-UDEndpoint -Schedule $Schedule60 -Endpoint {
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
    }

    $Endpoints = @(
        $BaseEndpoint
        $TeamsEndpoint
        $H2HEndpoint
        $PlayersEndpoint
        $TablesEndpoint
        $TradesEndpoint
        $WaiversEndpoint
        $CupEndpoint
        $HourlyEndpoint
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
