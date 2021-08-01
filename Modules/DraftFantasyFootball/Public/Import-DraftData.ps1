function Import-DraftData {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            ParameterSetName = 'League'
        )]
        [ValidateSet('Prem', 'Freak', 'Vermin', 'Plankton')]
        [string]
        $League,

        [Parameter(
            Mandatory,
            ParameterSetName = 'Cup'
        )]
        [switch]
        $Cup,

        [Parameter(
            Mandatory,
            ParameterSetName = 'League'
        )]
        [ValidateSet('H2H', 'Picks', 'Standings')]
        [string]
        $DataType,

        [Parameter(Mandatory)]
        [int]
        $Year
    )

    $ImportFolder = Join-Path -Path $PSScriptRoot -ChildPath "..\Data\$Year"

    if ($League) {
        $Path = Join-Path -Path $ImportFolder -ChildPath "League$DataType$League.xml"
    }
    elseif ($Cup) {
        $Path = Join-Path -Path $ImportFolder -ChildPath "LeagueCup.xml"
    }
    Import-CliXml -Path $Path
}
