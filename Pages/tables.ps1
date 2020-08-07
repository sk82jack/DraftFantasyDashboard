New-UDPage -Name 'Tables' -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 8 -LargeOffset 2 -Endpoint {
            New-UDTabContainer -Tabs {
                New-UDTab -Text 'Prem' -Content {
                    New-UDTable -Headers @('Pos', 'Manager', 'P', 'W', 'D', 'L', 'S', 'Pts') -Style 'highlight' -Content {
                        $Cache:Tables['Prem'] | Out-UDTableData -Property @('Position', 'Manager', 'Played', 'Won', 'Drawn', 'Lost', 'Totalscore', 'Points')
                    }
                }
                New-UDTab -Text 'Freak' -Content {
                    New-UDTable -Headers @('Pos', 'Manager', 'P', 'W', 'D', 'L', 'S', 'Pts') -Style 'highlight' -Content {
                        $Cache:Tables['Freak'] | Out-UDTableData -Property @('Position', 'Manager', 'Played', 'Won', 'Drawn', 'Lost', 'Totalscore', 'Points')
                    }
                }
                New-UDTab -Text 'Vermin' -Content {
                    New-UDTable -Headers @('Pos', 'Manager', 'P', 'W', 'D', 'L', 'S', 'Pts') -Style 'highlight' -Content {
                        $Cache:Tables['Vermin'] | Out-UDTableData -Property @('Position', 'Manager', 'Played', 'Won', 'Drawn', 'Lost', 'Totalscore', 'Points')
                    }
                }
            }
        }
    }
}
