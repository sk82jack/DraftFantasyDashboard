New-UDPage -Name 'Picks' -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 8 -LargeOffset 2 -Endpoint {
            New-UDTabContainer -Tabs {
                $Headers = @('#', 'Round', 'Manager', 'Player', 'Club', 'Position', 'Total Points')
                $Properties = @('PickNo', 'Round', 'Manager', 'Player', 'PlayerClub', 'PlayerPosition', 'PlayerPoints')
                New-UDTab -Text 'Prem' -Content {
                    New-UDGrid -Id 'PremHistory' -Headers $Headers -Properties $Properties  -DefaultSortColumn 'PickNo' -NoPaging -Endpoint {
                        $Cache:Picks['Prem'] | Out-UDGridData
                        Invoke-UDJavaScript -JavaScript "
                            var checkExist = setInterval(function () {
                            if (document.getElementById('PremHistory').querySelector('table.griddle-table') != null) {
                                document.getElementById('PremHistory').querySelector('table.griddle-table').parentNode.style.overflowX = 'auto'
                                clearInterval(checkExist);
                            }
                        }, 100);
                        "
                    }
                }
                New-UDTab -Text 'Freak' -Content {
                    New-UDGrid -Id 'FreakHistory' -Headers $Headers -Properties $Properties -DefaultSortColumn 'PickNo' -NoPaging -Endpoint {
                        $Cache:Picks['Freak'] | Out-UDGridData
                        Invoke-UDJavaScript -JavaScript "
                            var checkExist = setInterval(function () {
                            if (document.getElementById('FreakHistory').querySelector('table.griddle-table') != null) {
                                document.getElementById('FreakHistory').querySelector('table.griddle-table').parentNode.style.overflowX = 'auto'
                                clearInterval(checkExist);
                            }
                        }, 100);
                        "
                    }
                }
                New-UDTab -Text 'Vermin' -Content {
                    New-UDGrid -Id 'VerminHistory' -Headers $Headers -Properties $Properties -DefaultSortColumn 'PickNo' -NoPaging -Endpoint {
                        $Cache:Picks['Vermin'] | Out-UDGridData
                        Invoke-UDJavaScript -JavaScript "
                            var checkExist = setInterval(function () {
                            if (document.getElementById('VerminHistory').querySelector('table.griddle-table') != null) {
                                document.getElementById('VerminHistory').querySelector('table.griddle-table').parentNode.style.overflowX = 'auto'
                                clearInterval(checkExist);
                            }
                        }, 100);
                        "
                    }
                }
            }
        }
    }
}
