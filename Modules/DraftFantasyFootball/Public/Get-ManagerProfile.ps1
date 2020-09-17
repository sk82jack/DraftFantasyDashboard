function Get-ManagerProfile {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Manager
    )

    $Script:ManagerProfiles[$Manager]
}
