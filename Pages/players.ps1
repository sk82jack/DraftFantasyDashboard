New-UDPage -Name 'Players' -Icon 'user' -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 8 -LargeOffset 2 -Endpoint {
            New-UDTabContainer -Tabs {
                New-UDTab -Text 'Prem' -Content {
                    New-UDGrid -Headers @('Player', 'Club', 'Rating', 'Points', 'Status', 'Owner') -Properties 'WebName', 'TeamNameShort', 'Rating', 'TotalPoints', 'Status', 'Owner' -DefaultSortColumn 'TotalPoints' -DefaultSortDescending -Endpoint {
                        $Cache:PremPlayers | Out-UDGridData
                    }
                }
                New-UDTab -Text 'Freak' -Content {
                    New-UDGrid -Headers @('Player', 'Club', 'Rating', 'Points', 'Status', 'Owner') -Properties 'WebName', 'TeamNameShort', 'Rating', 'TotalPoints', 'Status', 'Owner' -DefaultSortColumn 'TotalPoints' -DefaultSortDescending -Endpoint {
                        $Cache:FreakPlayers | Out-UDGridData
                    }
                }
                New-UDTab -Text 'Vermin' -Content {
                    New-UDGrid -Headers @('Player', 'Club', 'Rating', 'Points', 'Status', 'Owner') -Properties 'WebName', 'TeamNameShort', 'Rating', 'TotalPoints', 'Status', 'Owner' -DefaultSortColumn 'TotalPoints' -DefaultSortDescending -Endpoint {
                        $Cache:VerminPlayers | Out-UDGridData
                    }
                }
            }
        }
    }
}
