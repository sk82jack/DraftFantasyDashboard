function Get-DraftYear {
    [CmdletBinding()]
    param (
        [Parameter()]
        [datetime]
        $Date = (Get-Date)
    )

    if ($Date.Month -gt 7) {
        $Date.Year + 1
    }
    else {
        $Date.Year
    }
}
