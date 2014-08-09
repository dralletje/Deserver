proc('_solarEffects', @player,
        if(_world_nick(pworld(@player)) != 'SolarSystem') { die() }
        
        foreach(get_peffect(@player), @effect) {
            set_peffect(@player, @effect['id'], 1, 0)
        }
        
        _clear_pinv(@player)
        # set_timeout(55, closure(set_pinv(array(103: array(type: 20), 
                                                # 102: array(type: 299, meta: array(display: '\u00A75\u00A7lSpace Bodyarmor', color: array(r: 255, b: 255, g: 255))), 
                                                # 101: array(type: 300, meta: array(display: '\u00A75\u00A7lSpace Legs', color: array(r: 255, b: 255, g: 255))), 
                                                # 100: array(type: 301, meta: array(display: '\u00A75\u00A7lSpace Feets', color: array(r: 255, b: 255, g: 255)))
                                               # ))
                                # set_peffect(player(), 8, 4, 9999999)
                                
        # ))
        # set_peffect(@player, 1, 4, 9999999)
)

bind('world_changed', null, null, @event,
    if(_world_nick(@event['to']) == 'SolarSystem'){
        sudo('/mvtp space')
        # set_ploc(get_spawn(_world(@event['to'])))
        set_timeout(50, closure(
            @player = @event['player']
            _solarEffects(@player)
        ))
    }
)

bind('player_join', null, null, @event,
    @player = @event['player']
    if(_world_nick(pworld(@player)) == 'SolarSystem'){
        sudo('/mvtp space')
        # set_ploc(get_spawn(_world(@event['to'])))
        set_timeout(50, closure(
            _solarEffects(@player)
        ))
    }
)

bind('player_interact', null, array(block:68), @event,
    @player = @event['player']
    if(pworld(@player) != 'space') { die() }
    
    @loc = @event['location']
    @signtext = get_sign_text(@loc)
    
    if(@signtext[0] != '[ClickCounter]') { 
        if(@signtext[0] == '[ResetCounter]') {
            @signtext = array('[ClickCounter]', '0', 'Plancke', '')
            
            try( set_sign_text(array(@loc[x] + 2, @loc[y], @loc[z]), @signtext); die() )
            try( set_sign_text(array(@loc[x] - 2, @loc[y], @loc[z]), @signtext); die() )
            try( set_sign_text(array(@loc[x], @loc[y], @loc[z] + 2), @signtext); die() )
            try( set_sign_text(array(@loc[x], @loc[y], @loc[z] - 2), @signtext); die() )
        }
        die()
    }
    
    @signtext[1] += 1
    @signtext[2] = @player
    set_sign_text(@loc, @signtext)
    
)

bind('player_toggle_sneak', null, array(world:'space'), @event,
    # if(_world_nick(pworld(@player)) != 'SolarSystem') { die() }
    if(@event['sneaking']) { die() }
    
    @player = @event['player']
    @loc = ploc(@player)
    
    @signloc = array(x:@loc['x'], y:@loc['y'] - 1, z:@loc['z'], world:@loc['world'])

    if(!is_sign_at(@signloc)) { die() }
    assign(@signtext, get_sign_text(@signloc))
    if(@signtext[0] == '[JumpPad]') {
        set_pvelocity(@player, @signtext[1], @signtext[2], @signtext[3])
        play_sound(ploc(@player), array('sound': 'BAT_TAKEOFF', 'pitch': -5, 'volume': 1), @player)
    }
)