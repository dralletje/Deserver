bind('player_chat', array(priority: Low), null, @event,
    @message = @event['message']
    # if(get_value('afk', player())) { msg(_tagmsg('afk', 'You are marked as AFK')) }

    if(substr(@message, 0, 1) != '@') {
      die()
    }
    
    if(length(@message) > 1) {
        if(substr(@message, 0, 2) == '@!') {
            if(has_permission(@event['player'], 'rank.uberadmin')){
                _adminmsg('&c'._get_player_nick(@event['player']).':'.substr(@message, 2), 'AdminChat')
                cancel()
                die()
            }
        }
    }

    @splitmessage = reg_split(' ',  @message)
    @name = substr(@splitmessage[0], 1)
    @player = _player(@name)
    cancel()

    @c = player()
    @listeners = array(@c, @player)
    foreach(_admins('online'), @pl) {
      if(@pl == @c || @pl == @player) { continue() }
      array_push(@listeners, @pl)
    }

    if(@player == null) {
        @color = 'dark_red'
        @player = @name
    } else {
        @color = 'dark_green'
        @player = _get_player_nick(@player)
    }

    @msg = color(@color).'@'._capitalize(@player).color(white).substr(@message, length(@splitmessage[0]))
    @full = sprintf(@event['format'], _get_player_nick(@event['player']), @msg)
    _msg(@listeners, @full)
    
    foreach(@listener in @listeners) {
        try( play_sound(ploc(@listener), array('sound':'CHICKEN_EGG_POP'), array(@listener)) )
    }
)

# bind(player_chat, array(priority: normal), null, @event,
    # assign(
        # @message, @event['message']
    # )

    # assign(@message, replace(@message, 'Plancake', 'Plancke'))
    # assign(@message, replace(@message, 'plancake', 'Plancke'))

    # if(substr(@message, 0, 1) != '@') { return() }

    # assign(
        # @splitmessage,
        # reg_split(' ',  @message)
    # )

    # assign(
        # @name,
        # substr(@splitmessage[0], 1)
    # )

    # assign(
        # @player,
        # _player(@name)
    # )

    # assign(@listeners, array(@player, player()))
    # foreach(
        # _admins(),
        # @pl,
        # if(@pl == @player || @pl == player()) {
            # continue()
        # }
        # if(get_value(@pl, 'isnotlistening') == 'true') {
            # continue()
        # }
        # array_push(@listeners, @pl)
    # )

    # modify_event(
        # 'recipients',
        # @listeners
    # )

    # if(@player == null) {
        # assign(@color, 'dark_red')
        # assign(@player, @name)
    # } else {
        # assign(@color, 'dark_green')
        # assign(@player, _nick(@player))
    # }

    # modify_event(
        # 'message',
        # concat(
            # color(@color),
            # '@',
            # _capitalize(@player),
            # color(white),
            # substr(
                # @message,
                # length(@splitmessage[0])
            # )
        # )
    # )
# )
