bind('plugin_message_received', null, null, @e,
    _adminmsg(@e)
)

bind('player_death', null, null, @event,
    @player = @event['player']
    @cause = @event['cause']
    if(@cause['cause'] == 'FALL') {
        for(@i=0,@i<=255,@i++) {
            @block = data_name(get_block_at(array(@cause['location']['x'], @cause['location']['y'] - @i, @cause['location']['z'])))
            if(@block != "AIR") { break() }
        }
        
        
        broadcast(_colorize(_get_player_color(@player)._get_player_nick(@player).' {p}has died falling on {s}'.@block.'{p} from {s}'.floor(@cause['amount']).'{p} blocks!'))
        modify_event('death_message', null)
        die()
    }
    modify_event('death_message', color(4).@event['death_message'])
)

bind('player_join', null, null, @e,
    if(!_isAllowed(@e['player'])) { die() }
    @players = all_players()
    array_remove_values(@players, @e['player'])
    if(@players == array()) { die() }
    play_sound(ploc(@e['player']), array(sound: 'ENDERDRAGON_GROWL'), @players)
)

bind('world_changed', array(priority: normal), null, @event,    
    if(_inWorld(@event['to'], 'skyblock')){ if(!has_permission('rank.owner')) { set_pflight(player(), false) } }
    if(_inWorld(@event['to'], 'saturn')){ if(!has_permission('rank.owner')) { set_pflight(player(), false) } }
    if(_inWorld(@event['to'], 'mars')){ if(!has_permission('rank.owner')) { set_pflight(player(), false) } }
    if(_inWorld(@event['to'], 'space')){ if(!has_permission('rank.owner')) { set_pflight(player(), false) } }
    set_pwalkspeed(player(), 0.2)
    _set_list_name(player())
)

bind('player_chat', null, null, @event,
    @message = @event['message']
    if(length(@message) > 3 ) { if(substr(@message, 0, 4) == 'http') { die() }}
    modify_event('message', _capitalize(@message))
)

bind('server_ping', null, null, @event,
    modify_event('maxplayers', '50')
    @default = '\u00A75[Deserver] \u00A77Welcome!'
    # @motd = @default
    # @ips = get_value('IPList')
    # if(array_contains(array_keys(@ips), @event['ip'])) {
        # @message = @ips[@event['ip']]['message']
        # @motd = @message
        # if(@message == '$birthday') { @motd = '\u00A75Happy Birthday! \u00A77\u00A7o-Plancke' }
        # if(@message = '$default') { @motd = @default }
    # }
    # modify_event('motd', @motd)
    modify_event('motd', @default)
)

bind('player_fish', null, null, @e,
    @state = @e['state']
    if(@state != 'CAUGHT_FISH') { die() }
    @random = rand(0, 50)
    
    @items = array(
            array(type: 19, qty: 16), # Sponge
            array(type: 121, qty: 16), # End Stone
            array(type: '383:120', qty: 1), # Villager Egg
        )
    if(@random == 25) {
        @item = array_rand(@items, 1, false)
        drop_item(@e['player'], @item[0], true)
        msg(_tagmsg('Fisher', 'You\'ve caught something good!'))
    }
)

bind('player_join', null, null, @e,
    #VIP MAKEBIRD FIX
    @player = @e['player']
    if(!has_permission(@player, 'rank.vip')) { die() }
    @loc = ploc(@player)
    if(get_block_at(@loc) == '0:0') {
        for(@i = 0, @i <= round(@loc['y']), @i++) {
            @safe = array('x': @loc['x'], 'y': round(@loc['y'] - @i), 'z': @loc['z'], 'world': @loc['world'])
            if(get_block_at(@safe) != '0:0') { break() }
        }
        set_peffect(@player, 11, 50 ,10)
        set_ploc(@player, @safe)
    }
)

bind('sign_changed', null, null, @event,
    @signtext = @event['text']
    for(@i = 0, @i <= 3, @i++) {
        @signtext[@i] = colorize(@signtext[@i])
    }
    modify_event('text', @signtext)
) 