#############################################################################
## stop people from login in when banned.
#############################################################################

bind(player_login, array(priority: highest), null, @event,
    include('strikes.ms')
    assign(@strikes, _strike_get(player()))

    if(length(@strikes) >= 3 ) {
        _adminmsg(player().' tried to join, but has three strikes so is banned.')
        modify_event('kickmsg', '[3 Strikes] 'array_implode(@strikes))
        modify_event('result', 'KICK_BANNED')
        die()
    }
)

bind(player_join, array(priority: low), null, @event,
    include('strikes.ms')
    assign(@strikes, _strike_get(player()))

    if(length(@strikes) == 0) {
        die()
    }
    
    _adminmsg(player().' has '.length(@strikes).' strikes!')
    msg(_tagmsg('police', 'You have the following strikes on your name:'))
    foreach(
        @strikes,
        @strike,
        msg(color(5).'* '.color(7).@strike)
    )
)

# bind(world_changed, array(priority: highest), null, @event,
    # include('strikes.ms')
    # assign(@strikes, _strike_get(player()))
    
    # if(length(@strikes) >= 2) {
        # msg(_tagmsg('police', 'You\'ve got more then two strikes, so your not allowed in another world anymore.'))
        # cancel()
    # }
# )
