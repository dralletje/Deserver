proc(_nick, @player, return(_get_player_nick(@player)))
proc(_get_player_nick, @player = player(), 
    try(
        @pstats = _getInfo(@player)[0]
        @nick = @pstats['nick']
        if(@nick == '') { return(@player) }
        return(@nick)
    )
    return(@player)
)

proc(_set_player_nick, @player, @nick,
    _hasperm('commands.nick')
    @tempplayer = player(@player)
    
    if(@nick == null) {
        reset_display_name(@tempplayer)
        _storeInfo(@tempplayer, 'nick', '')
        msg(_tagmsg('nick', 'reset nickname of '. @tempplayer))
    } else {
        _storeInfo(@tempplayer, 'nick', @nick)
        set_display_name(@tempplayer, @nick)
        msg(_tagmsg('nick', 'changed nickname of '. @tempplayer. ' to "'. @nick.'"'))
    }

    _set_list_name(@tempplayer, null)
)

proc(_player, @nick, @default = 'null', @tag = 'God',
    @chars = length(@nick)
    @nick = to_lower(@nick)
    if(@nick != null && @nick != '' ) {
        foreach(all_players(), @player) {
            @nicknamos = to_lower(pinfo(@player, 4))
            if(@chars <= length(@nicknamos) && @nick ==  substr(@nicknamos, 0, @chars)) {
                try( 
                    if(_readConfig('pex')['users'][@player]['options']['afk'] == 'true') {
                        msg(_tagmsg('afk',  'Ahw, '. _get_player_nick(@player).' is currently afk :(')) 
                    }
                )
                return(@player)
            }
        }
    }
    switch(
        @default,
        'null',
            return(null),
        'player',
            return(player()),
        'die',
            die(_tagmsg(@tag, 'Player is not online')),
        'name',
            return(@nick),
    )
)