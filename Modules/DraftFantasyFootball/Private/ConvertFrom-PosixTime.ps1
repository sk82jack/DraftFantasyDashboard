Function ConvertFrom-PosixTime {
    [CmdletBinding()]
    Param(
        [long]$PosixTime
    )
    if ($PosixTime) {
        [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddMilliseconds($PosixTime))
    }
}
