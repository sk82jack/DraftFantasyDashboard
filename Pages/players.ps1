New-UDPage -Name 'Players' -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 8 -LargeOffset 2 -Endpoint {
            New-UDTabContainer -Tabs {
                New-UDTab -Text 'Prem' -Content {
                    New-UDGrid -Headers @('Player', 'Club', 'Rating', 'Points', 'Status', 'Owner') -Properties 'WebName', 'TeamNameShort', 'Rating', 'TotalPoints', 'Status', 'Owner' -DefaultSortColumn 'TotalPoints' -DefaultSortDescending -Endpoint {
                        $Cache:Players['Prem'] | Out-UDGridData
                    }
                }
                New-UDTab -Text 'Freak' -Content {
                    New-UDGrid -Headers @('Player', 'Club', 'Rating', 'Points', 'Status', 'Owner') -Properties 'WebName', 'TeamNameShort', 'Rating', 'TotalPoints', 'Status', 'Owner' -DefaultSortColumn 'TotalPoints' -DefaultSortDescending -Endpoint {
                        $Cache:Players['Freak'] | Out-UDGridData
                    }
                }
                New-UDTab -Text 'Vermin' -Content {
                    New-UDGrid -Headers @('Player', 'Club', 'Rating', 'Points', 'Status', 'Owner') -Properties 'WebName', 'TeamNameShort', 'Rating', 'TotalPoints', 'Status', 'Owner' -DefaultSortColumn 'TotalPoints' -DefaultSortDescending -Endpoint {
                        $Cache:Players['Vermin'] | Out-UDGridData
                    }
                }
            }
        }
    }
}
