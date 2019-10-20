function Start-Dashboard {
    $Pages = @()
    $Pages += . (Join-Path $PSScriptRoot "Pages/fixtures.ps1")

    Get-ChildItem (Join-Path $PSScriptRoot "Pages") -Exclude "fixtures.ps1" | ForEach-Object {
        $Pages += . $_.FullName
    }

    $Images = @{}
    foreach ($File in (Get-ChildItem -Path $PSScriptRoot/Images)) {
        $Images[$File.BaseName] = 'Images/{0}' -f $File.Name
    }
    $BHEndpoints = New-UDEndpointInitialization -Module 'Modules/DraftFantasyFootball/DraftFantasyFootball.psd1' -Variable 'Images'
    $Theme = Get-UDTheme Azure
    $DashboardSplat = @{
        Title                  = 'Draft Fantasy Football'
        Pages                  = $Pages
        EndpointInitialization = $BHEndpoints
        Theme                  = $Theme
    }
    $Dashboard = New-UDDashboard @DashboardSplat

    try {
        Start-UDDashboard -Dashboard $Dashboard -Port 8585
    }
    catch {
        Write-Error -Exception $_.Exception
    }
}
