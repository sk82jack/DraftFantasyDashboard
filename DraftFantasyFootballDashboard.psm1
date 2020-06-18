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

    $Images = @{}
    foreach ($File in (Get-ChildItem -Path $PSScriptRoot/Images)) {
        $Images[$File.BaseName] = Join-Path -Path $PSScriptRoot -ChildPath ('Images/{0}' -f $File.Name)
    }

    $BHEndpoints = New-UDEndpointInitialization -Module 'Modules/DraftFantasyFootball/DraftFantasyFootball.psd1' -Variable 'Images'
    $ThemeDefinition = Import-PowerShellDataFile -Path (Join-Path $PSScriptRoot '/Themes/DraftFantasy.ps1')
    $Theme = New-UDTheme -Name $ThemeDefinition['Name'] -Definition $ThemeDefinition['Definition']

    $DashboardSplat = @{
        Title                  = 'Draft Fantasy Football'
        Pages                  = $Pages
        EndpointInitialization = $BHEndpoints
        Theme                  = $Theme
    }
    $Dashboard = New-UDDashboard @DashboardSplat

    $Schedule2 = New-UDEndpointSchedule -Every 2 -Minute
    $Schedule5 = New-UDEndpointSchedule -Every 5 -Minute
    $Schedule60 = New-UDEndpointSchedule -Every 1 -Hour

    $BaseEndpoint = New-UDEndpoint -Schedule $Schedule2 -Endpoint {
        $Gameweek = (Get-FplBootstrapStatic).events.Where{$_.is_current}
        $Cache:CurrentGameweek = $Gameweek.id
        if ($Cache:CurrentGameweek -gt 38) {
            $Cache:CurrentGameweek += -9
        }
        $Fixtures = Invoke-RestMethod -Uri 'https://fantasy.premierleague.com/api/fixtures/'
        $GameweekFixtures = $Fixtures.Where{$_.event -eq $Gameweek.id}
        $Cache:InGame = foreach ($Fixture in $GameweekFixtures) {
            ($Time -gt $Fixture.kickoff_time) -and ($Time -lt $Fixture.kickoff_time.AddHours(2))
            break
        }
    }
    $TeamsEndpoint = New-UDEndpoint -Schedule $Schedule5 -Endpoint {
        if ($Cache:InGame) {
            $Cache:Teams = @{
                'Prem'   = Get-DraftTeam -League 'Prem'
                'Freak'  = Get-DraftTeam -League 'Freak'
                'Vermin' = Get-DraftTeam -League 'Vermin'
            }
        }
    }
    $H2HEndpoint = New-UDEndpoint -Schedule $Schedule5 -Endpoint {
        if ($Cache:InGame) {
            $Cache:H2H = @{
                'Prem'   = Get-DraftHeadToHead -League 'Prem'
                'Freak'  = Get-DraftHeadToHead -League 'Freak'
                'Vermin' = Get-DraftHeadToHead -League 'Vermin'
            }
        }
    }
    $PlayersEndpoint = New-UDEndpoint -Schedule $Schedule5 -Endpoint {
        if ($Cache:InGame) {
            $Cache:Players = @{
                'Prem'   = Get-DraftPlayer -League 'Prem'
                'Freak'  = Get-DraftPlayer -League 'Freak'
                'Vermin' = Get-DraftPlayer -League 'Vermin'
            }
        }
    }
    $TablesEndpoint = New-UDEndpoint -Schedule $Schedule5 -Endpoint {
        if ($Cache:InGame) {
            $Cache:Tables = @{
                'Prem'   = Get-DraftLeagueTable -League 'Prem'
                'Freak'  = Get-DraftLeagueTable -League 'Freak'
                'Vermin' = Get-DraftLeagueTable -League 'Vermin'
            }
        }
    }
    $TradesEndpoint = New-UDEndpoint -Schedule $Schedule5 -Endpoint {
        if ($Cache:InGame) {
            $Cache:Trades = @{
                'Prem'   = Get-DraftTrade -League 'Prem'
                'Freak'  = Get-DraftTrade -League 'Freak'
                'Vermin' = Get-DraftTrade -League 'Vermin'
            }
        }
    }
    $WaiversEndpoint = New-UDEndpoint -Schedule $Schedule5 -Endpoint {
        if ($Cache:InGame) {
            $Cache:Waivers = @{
                'Prem'   = Get-DraftWaiverOrder -League 'Prem'
                'Freak'  = Get-DraftWaiverOrder -League 'Freak'
                'Vermin' = Get-DraftWaiverOrder -League 'Vermin'
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
            'Prem'   = Get-DraftTeam -League 'Prem'
            'Freak'  = Get-DraftTeam -League 'Freak'
            'Vermin' = Get-DraftTeam -League 'Vermin'
        }
        $Cache:H2H = @{
            'Prem'   = Get-DraftHeadToHead -League 'Prem'
            'Freak'  = Get-DraftHeadToHead -League 'Freak'
            'Vermin' = Get-DraftHeadToHead -League 'Vermin'
        }
        $Cache:Players = @{
            'Prem'   = Get-DraftPlayer -League 'Prem'
            'Freak'  = Get-DraftPlayer -League 'Freak'
            'Vermin' = Get-DraftPlayer -League 'Vermin'
        }
        $Cache:Tables = @{
            'Prem'   = Get-DraftLeagueTable -League 'Prem'
            'Freak'  = Get-DraftLeagueTable -League 'Freak'
            'Vermin' = Get-DraftLeagueTable -League 'Vermin'
        }
        $Cache:Trades = @{
            'Prem'   = Get-DraftTrade -League 'Prem'
            'Freak'  = Get-DraftTrade -League 'Freak'
            'Vermin' = Get-DraftTrade -League 'Vermin'
        }
        $Cache:Waivers = @{
            'Prem'   = Get-DraftWaiverOrder -League 'Prem'
            'Freak'  = Get-DraftWaiverOrder -League 'Freak'
            'Vermin' = Get-DraftWaiverOrder -League 'Vermin'
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
        Dashboard = $Dashboard
        Port      = $Port
        Wait      = $true
        EndPoint  = $Endpoints
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
