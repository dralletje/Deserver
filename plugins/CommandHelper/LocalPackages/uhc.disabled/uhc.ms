proc(_colornamesUHC,
    @scoreboard = 'UHC'    
    @config = yml_decode(read('uhc.config'))
    @teams = @config['teams']
    try( remove_scoreboard(@scoreboard) ) 
    try( create_scoreboard(@scoreboard) )
    try( create_objective(@scoreboard, 'DUMMY', @scoreboard) )
    
    foreach(@players, @player) {
        try( set_pscoreboard(@player, @scoreboard) )
    }
    
    # @players = array('Plancke', 'Fontn', 'LonelyFatKid', 'boatzy', 'Sandermoons', 'marrio2701', 'epicperson532964', 'aabbbb2', 'Sandermoons', 'immensejae09', 'luisguevara', 'milese3', 'shawty_scythe')
    # @teams = array(array('Plancke', 'Fontn', 'LonelyFatKid'), array('aabbbb2', 'Sandermoons', 'boatzy'), array('marrio2701', 'epicperson532964', 'immensejae09'), array('luisguevara', 'shawty_scythe', 'milese3'))
    foreach(array_keys(@teams), @teamname) {
        try( create_team(@teamname, @scoreboard) )
        @options = array()
        foreach(array_keys(@teams[@teamname]['options']), @option) {
            msg(@teams[@teamname]['options'], @option)
            array_set(@options, @option, colorize(@teams[@teamname]['options'][@option][0]))
        }
        set_team_display(@teamname, @options, @scoreboard)
        foreach(@teams[@teamname]['players'], @player) {
            team_add_player(@teamname, @player, @scoreboard)
        }
    }
    
    msg(_tagmsg('UHC', 'Players colored'))
)

proc(_uhcstart, 
    @config = yml_decode(read('uhc.config'))
    @teams = @config['teams']
    @players = array()
    @tplayers = array()
    @worlds = array()
    foreach(@teams, @team) {
        foreach(@team['players'], @player) {
            array_push(@players, @player)
        }
        array_push(@tplayers, @team['players'])
    }
    foreach(@config['worlds'], @world) {
        array_push(@worlds, @world['name'])
    }
    store_value('CurUHC', 'Status', 'On')
    store_value('CurUHC', 'Players', @players)
    store_value('CurUHC', 'StarterPlayers', @players)
    store_value('CurUHC', 'MaxPlayers', array_size(@players))
    store_value('CurUHC', 'Teams', @tplayers)
    store_value('CurUHC', 'Worlds', @worlds)
    
    @players = get_value('CurUHC', 'Players')
    @emptyinv = array(0: null, 1: null, 2: null, 3: null, 4: null, 5: null, 6: null, 7: null, 8: null, 9: null, 10: null, 11: null, 12: null, 13: null, 14: null, 15: null,
                     16: null, 17: null, 18: null, 19: null, 20: null, 21: null, 22: null, 23: null, 24: null, 25: null, 26: null, 27: null, 28: null, 29: null, 30: null, 
                     31: null, 32: null, 33: null, 34: null, 35: null, 100: null, 101: null, 102: null, 103: null)
    
    foreach(@players, @player) {
        runas('~console', '/pex user '.@player.' add multiverse.access.uhc')
        try( set_ploc(@player, array(0, 200, 0,'uhc')) )
        try( set_peffect(@player, 11, 255, 20) )
        try( set_pinv(@player, @emptyinv) )
        try( set_plevel(@player, 0) )
    }    
    
    _uhcspread(500)
    _uhcheal()
    set_world_time(0)
    sudo('/butcher')
)

proc(_uhcheal,
    @players = get_value('CurUHC', 'Players')
    foreach(@players, @player) {
        try( set_psaturation(@player, 20) )
        try( set_phealth(@player, 20) )
        try( set_pfood(@player, 20) )
    }
)

proc(_uhcspread, @spread,
    @teams = get_value('CurUHC', 'Teams')
    @angle = to_radians(360 / array_size(@teams))
    @pos = array()
    for(@i = 1, @i <= array_size(@teams), @i++) {
        @x = @spread * cos(@angle * @i)
        @z = @spread * sin(@angle * @i)
        array_push(@pos, array(@x, @z))
    }
    for(@i = 0, @i <= array_size(@pos) - 1, @i++) {
        @curpos = @pos[@i]
        @team = @teams[@i]
        @newloc = array(@curpos[0], 200, @curpos[1])
        foreach(@team, @player) {
            try( set_ploc(@player, @newloc) )
        }
    }
)

proc(_uhcstop,
    store_value('CurUHC', 'Status', 'Off')
    @players = get_value('CurUHC', 'StarterPlayers')
    foreach(@players, @player) {
        runas('~console', '/pex user '.@player.' remove multiverse.access.uhc')
        store_value('CurUHC', 'Teamchat', @player, false)
    }
)

bind(player_death, null, null, @event,
    if(get_value('CurUHC', 'Status') == 'On') {
        if(array_contains(get_value('CurUHC', 'Players'), player())) {
            @message = @event['death_message']
            broadcast(_tagmsg('UHC', @message))
            
            @maxplayers = get_value('CurUHC', 'MaxPlayers')
            @curplayers = array_size(get_value('CurUHC', 'Players')) - 1
            @newplayers = get_value('CurUHC', 'Players')
            array_remove_values(@newplayers, @event['player'])
            store_value('CurUHC', 'Players', @newplayers)

            broadcast(_tagmsg('UHC', player().' has died, there are '.@curplayers.'/'.@maxplayers.' players remaining.'))
            
            @teams = get_value('CurUHC', 'Teams')
            @newteams = array()
            foreach(@teams, @team) {
                array_remove_values(@team, @event['player'])
                if(array_size(@team) == 0) {
                    broadcast(_tagmsg('UHC', @event['player'].'\'s team has been obliterated.'))
                } else {
                    array_push(@newteams, @team)
                }
            }
            if(array_size(@newteams) == 1) {
                broadcast(_tagmsg('UHC', @newteams[0][0].'\'s team has won.'))
                _uhcstop()
                die()
            }
            store_value('CurUHC', 'Teams', @newteams)
            
            modify_event('death_message', null)
        }
    }
)

bind(player_command, null, null, @event,
    if(get_value('CurUHC', 'Status') == 'On') {
        @worlds = get_value('CurUHC', 'Worlds')
        @allowed = array('Plancke', 'LonelyFatKid', 'Fontn')
        if(array_contains(get_value('CurUHC', 'Players'), player()) && !array_contains(@allowed, player()) && array_contains(@worlds, pworld())) {
            cancel()
        }
    }
)

bind(player_chat, null, null, @event,
    @state = get_value('CurUHC', 'Teamchat', player())
    if(@state == null || @state == false) { die() }
    
    @message = @event['message']
    @teams = get_value('CurUHC', 'Teams')
    @listeners = array(player())
    foreach(@teams, @team) {
        if(array_contains(@team, player())) {
            foreach(@team, @player) {
                array_push(@listeners, @player)
            }
        }
    }
    
    modify_event('recipients', @listeners)
    modify_event('message', colorize('&7&o[TC] ')._capitalize(@message))
)