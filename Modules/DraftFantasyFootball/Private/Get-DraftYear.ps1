function Get-DraftYear {
    [CmdletBinding()]
    param (
        [Parameter()]
        [datetime]
        $Date = (Get-Date)
    )

    if ($Date.Month -lt 8) {
        $Date.Year - 1
    }
    else {
        $Date.Year
    }
}
