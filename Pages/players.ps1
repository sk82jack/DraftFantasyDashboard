New-UDPage -Name 'Players' -Icon 'user' -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 8 -MediumOffset 2 -LargeSize 6 -LargeOffset 3 -Endpoint {
            New-UDTabContainer -Tabs {
                New-UDTab -Text 'Prem' -Content {
                    New-UDGrid -Headers @('Player', 'Rating', 'Points', 'Status', 'Owner') -Properties 'WebName', 'Rating', 'TotalPoints', 'Status', 'Owner' -DefaultSortColumn 'TotalPoints' -DefaultSortDescending -Endpoint {
                        Get-DraftPlayer -League 'Prem' | Out-UDGridData
                    }
                }
                New-UDTab -Text 'Freak' -Content {
                    New-UDGrid -Headers @('Player', 'Rating', 'Points', 'Status', 'Owner') -Properties 'WebName', 'Rating', 'TotalPoints', 'Status', 'Owner' -DefaultSortColumn 'TotalPoints' -DefaultSortDescending -Endpoint {
                        Get-DraftPlayer -League 'Freak' | Out-UDGridData
                    }
                }
                New-UDTab -Text 'Vermin' -Content {
                    New-UDGrid -Headers @('Player', 'Rating', 'Points', 'Status', 'Owner') -Properties 'WebName', 'Rating', 'TotalPoints', 'Status', 'Owner' -DefaultSortColumn 'TotalPoints' -DefaultSortDescending -Endpoint {
                        Get-DraftPlayer -League 'Vermin' | Out-UDGridData
                    }
                }
            }
        }
    }
}
