function ConvertTo-DraftObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object[]]
        $InputObject,

        [Parameter(Mandatory)]
        [ValidateSet(
            'HeadToHead', 'LeagueTable', 'Trade', 'Team', 'Player', 'WaiverOrder', 'Points', 'Picks'
        )]
        [string]
        $Type,

        [Parameter()]
        [ValidateSet('Prem', 'Freak', 'Vermin')]
        [string]
        $League,

        [Parameter()]
        [int64[]]
        $Gameweek
    )
    switch ($Type) {
        'HeadToHead' {
            $Points = Get-DraftLeaguePoints -League $League -Gameweek $Gameweek
        }
        'LeagueTable' {
            $HeadToHead = Get-DraftHeadToHead -League $League
        }
        'Trade' {}
        'Team' {
            $Gameweek = $Script:BootstrapStatic.events.Where{$_.is_next}.id
            $Gameweek = $Gameweek | Foreach-Object {
                if ($_ -gt 38) {
                    $_ - 9
                }
                else {
                    $_
                }
            }
            $Positions = @{
                1 = 'GK'
                2 = 'DEF'
                3 = 'MID'
                4 = 'FWD'
            }
        }
        'Player' {
            if ($League) {
                $Teams = Get-DraftTeam -League $League
            }
        }
        'WaiverOrder' {
            foreach ($Manager in $InputObject) {
                [PSCustomObject]@{
                    Manager = $Script:ConfigData[$League]['Teams'][$Manager]
                }
            }
            return
        }
        'Points' {
            $Script:BootstrapStatic = Get-FplBootstrapStatic
            $Script:DraftPlayers = Get-DraftPlayer
            $PlayerMinutes = Get-DraftPlayerMinutes
        }
        'Picks' {
            $Script:DraftPlayers = Get-DraftPlayer
            $PickNo = 0
        }
    }

    foreach ($Object in $InputObject) {
        $Hashtable = Convert-DiacriticProperties -Object $Object

        switch ($Type) {
            'HeadToHead' {
                $Hashtable['Manager1'] = $Script:ConfigData[$League]['Teams'][$Hashtable['Team1Id']]
                $Hashtable['Manager2'] = $Script:ConfigData[$League]['Teams'][$Hashtable['Team2Id']]
                $Hashtable['Team1score'] = $Points.Where{$_.Manager -eq $Hashtable['Manager1']}."Gameweek${Gameweek}points"
                $Hashtable['Team2score'] = $Points.Where{$_.Manager -eq $Hashtable['Manager2']}."Gameweek${Gameweek}points"
            }
            'LeagueTable' {
                $Hashtable['Played'] = [int]$Hashtable['headToHeadData'].played
                $Hashtable['Won'] = $Hashtable['headToHeadData'].won
                $Hashtable['Drawn'] = $Hashtable['headToHeadData'].drawn
                $Hashtable['Lost'] = $Hashtable['headToHeadData'].lost
                $Hashtable['Points'] = $Hashtable['headToHeadData'].headToHeadLeaguepoints
                $Hashtable['Manager'] = $Script:ConfigData[$League]['Managers'][$Hashtable['UserId']]
                $Hashtable['Position'] = $null

                if ($HeadToHead[0].Gameweek -gt $Hashtable['Played']) {
                    $Hashtable['Played'] += 1
                    $Fixture = $HeadToHead.Where{$Hashtable['Manager'] -eq $_.Manager1}
                    if ($Fixture) {
                        if ($Fixture.Team1Score -gt $Fixture.Team2Score) {
                            $Hashtable['Won'] += 1
                            $Hashtable['Points'] += 3
                        }
                        elseif ($Fixture.Team1Score -eq $Fixture.Team2Score) {
                            $Hashtable['Drawn'] += 1
                            $Hashtable['Points'] += 1
                        }
                        else {
                            $Hashtable['Lost'] += 1
                        }
                        $Hashtable['TotalScore'] += $Fixture.Team1Score
                    }
                    else {
                        $Fixture = $HeadToHead.Where{$Hashtable['Manager'] -eq $_.Manager2}
                        if ($Fixture.Team2Score -gt $Fixture.Team1Score) {
                            $Hashtable['Won'] += 1
                            $Hashtable['Points'] += 3
                        }
                        elseif ($Fixture.Team2Score -eq $Fixture.Team1Score) {
                            $Hashtable['Drawn'] += 1
                            $Hashtable['Points'] += 1
                        }
                        else {
                            $Hashtable['Lost'] += 1
                        }
                        $Hashtable['TotalScore'] += $Fixture.Team2Score
                    }
                }
            }
            'Trade' {
                [string]$Hashtable['InManager'] = if ($Hashtable['inTeamId']) {
                    $Script:ConfigData[$League]['Teams'][$Hashtable['inTeamId']]
                }
                $Hashtable['PlayersIn'] = foreach ($Player in $Hashtable['Playersinids']) {
                    $Script:DraftPlayers.Where{$_.Id -eq $Player}.WebName
                }
                $Hashtable['OutManager'] = $Script:ConfigData[$League]['Teams'][$Hashtable['outTeamId']]
                $Hashtable['PlayersOut'] = foreach ($Player in $Hashtable['Playersoutids']) {
                    $Script:DraftPlayers.Where{$_.Id -eq $Player}.WebName
                }
                foreach ($Property in 'createdAt', 'respondedAt', 'updatedAt') {
                    $Hashtable[$Property] = ConvertFrom-PosixTime -PosixTime $Hashtable[$Property]
                    if (-not $Hashtable[$Property]) {
                        $Hashtable[$Property] = '-'
                    }
                }
                $Hashtable['PlayersIn'] = $Hashtable['PlayersIn'] -join ', '
                $Hashtable['PlayersOut'] = $Hashtable['PlayersOut'] -join ', '
            }
            'Team' {
                $Manager = $Script:ConfigData[$League]['Teams'][$Hashtable.Id]
                $Hashtable['Manager'] = $Manager
                $Hashtable['Players'] = [System.Collections.Generic.List[psobject]]::new()
                foreach ($Player in $Hashtable.LineupPlayers) {
                    $PlayerHash = Convert-DiacriticProperties -Object $Player
                    $PlayerHash['IsSub'] = $False
                    $PlayerHash['Manager'] = $Manager
                    $Fixture = $Player.Club.fixtures.Where{$_.gameweek -in $Gameweek}
                    $PlayerHash['TeamAgainst'] = if ($Fixture.homeTeamShort -eq $PlayerHash['TeamNameShort']) {
                        'vs {0} (H)' -f $Fixture.awayTeamShort
                    }
                    else {
                        'vs {0} (A)' -f $Fixture.homeTeamShort
                    }
                    $PlayerHash['Position'] = $Positions[[int]$Player.element_type_id]
                    $Hashtable['Players'].Add([PSCustomObject]$PlayerHash)
                }
                $Hashtable['Players'] = [System.Collections.Generic.List[psobject]]($Hashtable['Players'] | Sort-Object ElementTypeId)
                foreach ($Player in $Hashtable.SubPlayers) {
                    $PlayerHash = Convert-DiacriticProperties -Object $Player
                    $PlayerHash['IsSub'] = $True
                    $PlayerHash['Manager'] = $Manager
                    $Fixture = $Player.Club.fixtures.Where{$_.gameweek -in $Gameweek}
                    $PlayerHash['TeamAgainst'] = if ($Fixture.homeTeamShort -eq $PlayerHash['TeamNameShort']) {
                        'vs {0} (H)' -f $Fixture.awayTeamShort
                    }
                    else {
                        'vs {0} (A)' -f $Fixture.homeTeamShort
                    }
                    $PlayerHash['Position'] = $Positions[[int]$Player.element_type_id]
                    $Hashtable['Players'].Add([PSCustomObject]$PlayerHash)
                }
            }
            'Player' {
                $Hashtable['WeeklyPoints'] = $Hashtable['GameweekPoints']
                $Hashtable.Remove('GameweekPoints')
                foreach ($Fixture in $Hashtable['Club'].fixtures) {
                    $Fixture.date = ConvertFrom-PosixTime -PosixTime $Fixture.date
                }
                if ($League) {
                    $OwnedBy = $Teams.Players.Where{$_.Id -eq $Hashtable.Id}[0].Manager
                    $Hashtable['Status'] = if ($OwnedBy) {
                        'Owned'
                    }
                    else {
                        $OwnedBy = '-'
                        switch ($Hashtable['Waiverstatus']) {
                            'blocked' {
                                'Blocked'
                                break
                            }
                            'on_waivers' {
                                'Waivers'
                                break
                            }
                            'off_waivers' {
                                'Free'
                                break
                            }
                        }
                    }
                    $Hashtable['Owner'] = $OwnedBy
                }
            }
            'WaiverOrder' {}
            'Points' {
                $Manager = $Script:ConfigData[$League]['Teams'][$Hashtable.Id]
                $Hashtable['Manager'] = $Manager
                foreach ($Week in $Gameweek) {
                    if (-not $Script:BootstrapStatic.events.Where{$_.id -eq $Week}.finished) {
                        $AutoSubParams = @{
                            LineupIds     = $Hashtable["Gameweek$($Week)history"].lineup
                            SubIds        = $Hashtable["Gameweek$($Week)history"].subs
                            PlayerMinutes = $PlayerMinutes
                        }
                        $Hashtable["Gameweek$($Week)Lineup"] = Invoke-AutoSubs @AutoSubParams
                        $Hashtable["Gameweek$($Week)points"] = ($Hashtable["Gameweek$($Week)Lineup"].WeeklyPoints | Measure-Object -Sum).Sum
                        $Hashtable['GameweekLineup'] = $Hashtable["Gameweek$($Week)Lineup"]
                        $Hashtable['Gameweekpoints'] = $Hashtable["Gameweek$($Week)points"]
                    }
                }
            }
            'Picks' {
                $Manager = $Script:ConfigData[$League]['Teams'][$Hashtable.TeamId]
                $Hashtable['Manager'] = $Manager

                $Player = $Script:DraftPlayers.Where{$_.Id -eq $Hashtable.PlayerId}.WebName
                $Hashtable['Player'] = $Player

                $PickNo++
                $Hashtable['PickNo'] = $PickNo

                $LeagueTeamsNo = $Script:ConfigData[$League]['Teams'].Count
                $Round = [math]::Ceiling(($PickNo / $LeagueTeamsNo))
                $Hashtable['Round'] = $Round
            }
        }
        [pscustomobject]$Hashtable
    }
}
