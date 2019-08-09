function Convert-DiacriticProperties {
    [CmdletBinding()]
    param (
        $Object
    )

    $Hashtable = [ordered]@{}
    $TextInfo = (Get-Culture).TextInfo
    $Object.psobject.properties | ForEach-Object {
        $Name = $TextInfo.ToTitleCase($_.Name) -replace '_'
        if ($_.Value -is [string]) {
            $Value = [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($_.value)).trim()
        }
        else {
            $Value = $_.Value
        }
        $Hashtable[$Name] = $Value
    }
    $Hashtable
}
