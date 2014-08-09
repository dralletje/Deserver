bind('player_chat', array(priority: normal), null, @event,
    @message = @event['message']
    # if(get_value('afk', player())) { msg(_tagmsg('afk', 'You are marked as AFK')) }
    
    if(substr(@message, 0, 1) != '@') { die() }

    @splitmessage = reg_split(' ',  @message)
    @name = substr(@splitmessage[0], 1)
    @player = _player(@name)

    @listeners = array(@player, player())
    foreach(_admins(), @pl) {
        # if(@pl == @player || @pl == player()) { 
            # continue()
        # }
        # if(get_value(@pl, 'isnotlistening') == 'true') {
            # continue()
        # }
        array_push(@listeners, @pl)
    }
    modify_event('recipients', array_unique(@listeners))

    if(@player == null) {
        @color = 'dark_red'
        @player = @name
    } else {
        @color = 'dark_green'
        @player = _get_player_nick(@player)
    }

    modify_event('message', color(@color).'@'._capitalize(@player).color(white).substr(@message, length(@splitmessage[0])))
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
