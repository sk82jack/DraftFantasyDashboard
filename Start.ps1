# UD Start Script
Import-Module .\DraftFantasyFootballDashboard.psd1 -Force

Get-UDDashboard | Stop-UDDashboard
Start-DashBoard
