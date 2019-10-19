New-UDPage -Name 'Fixtures' -Icon calendar_alt -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 8 -LargeOffset 2 -Endpoint {
            New-UDTabContainer -Tabs {
                New-UDTab -Text 'Prem' -Content {
                    New-UDTable -Headers @('Home', 'Home Score', 'Away Score', 'Away') -Content {
                        # Collapsibles with scores, collapsible items with teams
                        Get-DraftHeadToHead -League 'Prem' | Out-UDTableData -Property @('Manager1', 'Team1score', 'Team2score', 'Manager2')
                    }
                }
                New-UDTab -Text 'Freak' -Content {
                    New-UDTable -Headers @('Home', 'Home Score', 'Away Score', 'Away') -Content {
                        Get-DraftHeadToHead -League 'Freak' | Out-UDTableData -Property @('Manager1', 'Team1score', 'Team2score', 'Manager2')
                    }
                }
                New-UDTab -Text 'Vermin' -Content {
                    New-UDTable -Headers @('Home', 'Home Score', 'Away Score', 'Away') -Content {
                        Get-DraftHeadToHead -League 'Vermin' | Out-UDTableData -Property @('Manager1', 'Team1score', 'Team2score', 'Manager2')
                    }
                }
            }
        }
    }
}
