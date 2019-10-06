function ConvertTo-DraftObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object[]]
        $InputObject,

        [Parameter(Mandatory)]
        [ValidateSet(
            'HeadToHead', 'LeagueTable', 'Trade', 'Team', 'Player', 'WaiverOrder', 'Points'
        )]
        [string]
        $Type,

        [Parameter()]
        [ValidateSet('Prem', 'Freak', 'Vermin')]
        [string]
        $League
    )
    switch ($Type) {
        'HeadToHead' {}
        'LeagueTable' {
            $HeadToHead = Get-DraftHeadToHead -League $League -Current
        }
        'Trade' {}
        'Team' {
            $Gameweek = $Script:BootstrapStatic.events.Where{$_.is_next}.id
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
        'Points' {}
    }

    foreach ($Object in $InputObject) {
        $Hashtable = Convert-DiacriticProperties -Object $Object

        switch ($Type) {
            'HeadToHead' {
                $Hashtable['Manager1'] = $Script:ConfigData[$League]['Teams'][$Hashtable['Team1Id']]
                $Hashtable['Manager2'] = $Script:ConfigData[$League]['Teams'][$Hashtable['Team2Id']]
                $Hashtable['Team1score'] = $Hashtable['Team1score'] -as [int]
                $Hashtable['Team2score'] = $Hashtable['Team2score'] -as [int]
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
                    $Script:Players.Where{$_.Id -eq $Player}.WebName
                }
                $Hashtable['OutManager'] = $Script:ConfigData[$League]['Teams'][$Hashtable['outTeamId']]
                $Hashtable['PlayersOut'] = foreach ($Player in $Hashtable['Playersoutids']) {
                    $Script:Players.Where{$_.Id -eq $Player}.WebName
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
                    $Fixture = $Player.Club.fixtures.Where{$_.gameweek -eq $Gameweek}
                    $PlayerHash['TeamAgainst'] = if ($Fixture.homeTeamShort -eq $PlayerHash['TeamNameShort']) {
                        'vs {0} (H)' -f $Fixture.awayTeamShort
                    }
                    else {
                        'vs {0} (A)' -f $Fixture.homeTeamShort
                    }
                    $Hashtable['Players'].Add([PSCustomObject]$PlayerHash)
                }
                $Hashtable['Players'] = [System.Collections.Generic.List[psobject]]($Hashtable['Players'] | Sort-Object ElementTypeId)
                foreach ($Player in $Hashtable.SubPlayers) {
                    $PlayerHash = Convert-DiacriticProperties -Object $Player
                    $PlayerHash['IsSub'] = $True
                    $PlayerHash['Manager'] = $Manager
                    $Hashtable['Players'].Add([PSCustomObject]$PlayerHash)
                }
            }
            'Player' {
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
            }
        }
        [pscustomobject]$Hashtable
    }
}
