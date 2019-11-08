New-UDPage -Name 'Trades' -Icon exchange_alt -Endpoint {
    New-UDRow -Columns {
        New-UDColumn -SmallSize 12 -MediumSize 12 -LargeSize 8 -LargeOffset 2 -Endpoint {
            New-UDTabContainer -Tabs {
                New-UDTab -Text 'Prem' -Content {
                    New-UDCollapsible -Items {
                        New-UDCollapsibleItem -Title 'Open Offers' -FontColor 'White' -Content {
                            New-UDGrid -Headers @('Type', 'Offered', 'Requested', 'Offered by', 'Offered to', 'Offer date') -DateTimeFormat "D/M/YY, H:mm" -NoExport -NoFilter -Properties @('Type', 'PlayersOut', 'PlayersIn', 'OutManager', 'InManager', 'createdAt') -Endpoint {
                                $Cache:Trades['Prem'] | Where-Object Status -eq 'awaiting_response' | Out-UDGridData
                            }
                        }
                        New-UDCollapsibleItem -Title 'History' -FontColor 'White' -Content {
                            New-UDGrid -Headers @('Type', 'Offered', 'Requested', 'Offered by', 'Offered to', 'Offer date', 'Response date', 'Status') -DateTimeFormat "D/M/YY, H:mm" -NoExport -NoFilter -Properties @('Type', 'PlayersOut', 'PlayersIn', 'OutManager', 'InManager', 'createdAt', 'respondedAt', 'Status') -Endpoint {
                                $Cache:Trades['Prem'] | Where-Object Status -ne 'awaiting_response' | Out-UDGridData
                            }
                        }
                        New-UDCollapsibleItem -Title 'Waiver Order' -FontColor 'White' -Content {
                            New-UDTable -Headers 'Manager' -Style 'centered' -Content {
                                $Cache:Waivers['Prem'] | Out-UDTableData -Property Manager
                            }
                        }
                    }
                }
                New-UDTab -Text 'Freak' -Content {
                    New-UDCollapsible -Items {
                        New-UDCollapsibleItem -Title 'Open Offers' -FontColor 'White' -Content {
                            New-UDGrid -Headers @('Type', 'Offered', 'Requested', 'Offered by', 'Offered to', 'Offer date') -DateTimeFormat "D/M/YY, H:mm" -NoExport -NoFilter -Properties @('Type', 'PlayersOut', 'PlayersIn', 'OutManager', 'InManager', 'createdAt') -Endpoint {
                                $Cache:Trades['Freak'] | Where-Object Status -eq 'awaiting_response' | Out-UDGridData
                            }
                        }
                        New-UDCollapsibleItem -Title 'History' -FontColor 'White' -Content {
                            New-UDGrid -Headers @('Type', 'Offered', 'Requested', 'Offered by', 'Offered to', 'Offer date', 'Response date', 'Status') -DateTimeFormat "D/M/YY, H:mm" -NoExport -NoFilter -Properties @('Type', 'PlayersOut', 'PlayersIn', 'OutManager', 'InManager', 'createdAt', 'respondedAt', 'Status') -Endpoint {
                                $Cache:Trades['Freak'] | Where-Object Status -ne 'awaiting_response' | Out-UDGridData
                            }
                        }
                        New-UDCollapsibleItem -Title 'Waiver Order' -FontColor 'White' -Content {
                            New-UDTable -Headers 'Manager' -Style 'centered' -Content {
                                $Cache:Waivers['Freak'] | Out-UDTableData -Property Manager
                            }
                        }
                    }
                }
                New-UDTab -Text 'Vermin' -Content {
                    New-UDCollapsible -Items {
                        New-UDCollapsibleItem -Title 'Open Offers' -FontColor 'White' -Content {
                            New-UDGrid -Headers @('Type', 'Offered', 'Requested', 'Offered by', 'Offered to', 'Offer date') -DateTimeFormat "D/M/YY, H:mm" -NoExport -NoFilter -Properties @('Type', 'PlayersOut', 'PlayersIn', 'OutManager', 'InManager', 'createdAt') -Endpoint {
                                $Cache:Trades['Vermin'] | Where-Object Status -eq 'awaiting_response' | Out-UDGridData
                            }
                        }
                        New-UDCollapsibleItem -Title 'History' -FontColor 'White' -Content {
                            New-UDGrid -Headers @('Type', 'Offered', 'Requested', 'Offered by', 'Offered to', 'Offer date', 'Response date', 'Status') -DateTimeFormat "D/M/YY, H:mm" -NoExport -NoFilter -Properties @('Type', 'PlayersOut', 'PlayersIn', 'OutManager', 'InManager', 'createdAt', 'respondedAt', 'Status') -Endpoint {
                                $Cache:Trades['Vermin'] | Where-Object Status -ne 'awaiting_response' | Out-UDGridData
                            }
                        }
                        New-UDCollapsibleItem -Title 'Waiver Order' -FontColor 'White' -Content {
                            New-UDTable -Headers 'Manager' -Style 'centered' -Content {
                                $Cache:Waivers['Vermin'] | Out-UDTableData -Property Manager
                            }
                        }
                    }
                }
            }
        }
    }
}
