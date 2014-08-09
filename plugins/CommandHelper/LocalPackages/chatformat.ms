bind('player_chat', null, null, @event,
    try(
        @config = _readConfig('chat')
        @format = @config['message-format']
        @format = replace(@format, '%message', '%2$s')
        @format = replace(@format, '%displayname', '%1$s')
        @format = replace(@format, '%world', _world_color(pworld())._world_nick(pworld()))
        @format = replace(@format, '%prefix', _get_player_color(@event['player']))  
        modify_event('format', _colorize(@format))
        
        @message = @event['message']
        modify_event('message', _permcolorize(@message))
    , console('Error in Chat event for player '.@event['player']))
)

bind('tab_complete_chat', null, null, @event,
    @message = to_lower(@event['message'])
    if(substr(@message, 0, 1) == '@' && array_size(split(@message, ' ')) == 1) {
        @players = all_players()
        @completions = array()
        foreach(@players, @player) {
            @nick = _get_player_nick(@player)
            if(length(@message) < length(@nick)) {
                if(to_lower('@' . substr(@nick, 0, length(@message) - 1)) == @message) {
                    array_push(@completions, '@' . @nick . ' ')
                }
            }
        }
        modify_event('completions', @completions)
    }
)

_adminmsg('ChatFormat Binds Loaded!')