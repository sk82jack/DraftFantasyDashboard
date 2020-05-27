# UD Start Script
Import-Module $PSScriptRoot/DraftFantasyFootballDashboard.psd1 -Force

Get-UDDashboard | Stop-UDDashboard
Start-DashBoard
