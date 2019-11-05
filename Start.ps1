# UD Start Script
Import-Module $PSScriptRoot/DraftFantasyFootballDashboard.psd1 -Force

Get-UDDashboard | Stop-UDDashboard
openssl pkcs12 -export -out $PSScriptRoot/certificate.pfx -inkey /var/cert/private.key -in /var/cert/certificate.crt -certfile /var/cert/ca_bundle.crt -passout pass:
Start-DashBoard -CertificatePath $PSScriptRoot/certificate.pfx
