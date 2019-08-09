function Start-Dashboard {
    $Pages = @()
    $Pages += . (Join-Path $PSScriptRoot "pages\fixtures.ps1")

    Get-ChildItem (Join-Path $PSScriptRoot "pages") -Exclude "fixtures.ps1" | ForEach-Object {
        $Pages += . $_.FullName
    }

    $BHEndpoints = New-UDEndpointInitialization -Module 'Modules\DraftFantasyFootball\DraftFantasyFootball.psd1'

    $Theme = Get-UDTheme Azure
    $ThemeSettings = @{
        'background-color' = '#252525'
        'color'            = '#FFFFFF'
    }
    $ThemeSettingsWithBorder = @{
        'background-color' = '#252525'
        'color'            = '#FFFFFF'
        'border'           = '#252525'
    }
    $Theme.Definition['.sidenav'] = $ThemeSettings
    $Theme.Definition['.sidenav li>a'] = $ThemeSettings
    $Theme.Definition['.tabs'] = $ThemeSettings
    $Theme.Definition['.tab'] = $ThemeSettings
    $Theme.Definition['.collapsible'] = $ThemeSettingsWithBorder
    $Theme.Definition['.collapsible-header'] = $ThemeSettingsWithBorder
    $Theme.Definition['.collapsible-body'] = $ThemeSettingsWithBorder

    $DashboardSplat = @{
        Title                  = 'Draft Fantasy Football'
        Pages                  = $Pages
        EndpointInitialization = $BHEndpoints
        Theme                  = $Theme
    }
    $Dashboard = New-UDDashboard @DashboardSplat

    try {
        Start-UDDashboard -Dashboard $Dashboard -Port 10000
    }
    catch {
        Write-Error -Exception $_.Exception
    }
}
