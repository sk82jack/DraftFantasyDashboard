New-UDPage -Name 'Fixtures' -Icon calendar_alt -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 8 -MediumOffset 2 -LargeSize 6 -LargeOffset 3 -Endpoint {
            New-UDTabContainer -Tabs {
                New-UDTab -Text 'Prem' -Content {
                    New-UDTable -Headers @('Home', 'Home Score', 'Away Score', 'Away') -Content {
                        Get-DraftHeadToHead -League 'Prem' -Current | Out-UDTableData -Property @('Manager1', 'Team1score', 'Team2score', 'Manager2')
                    }
                }
                New-UDTab -Text 'Freak' -Content {
                    New-UDTable -Headers @('Home', 'Home Score', 'Away Score', 'Away') -Content {
                        Get-DraftHeadToHead -League 'Freak' -Current | Out-UDTableData -Property @('Manager1', 'Team1score', 'Team2score', 'Manager2')
                    }
                }
                New-UDTab -Text 'Vermin' -Content {
                    New-UDTable -Headers @('Home', 'Home Score', 'Away Score', 'Away') -Content {
                        Get-DraftHeadToHead -League 'Vermin' -Current | Out-UDTableData -Property @('Manager1', 'Team1score', 'Team2score', 'Manager2')
                    }
                }
            }
        }
    }
}
