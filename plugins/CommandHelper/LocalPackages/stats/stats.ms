bind('player_quit', null, array('priority': 'high'), @event,
    @player = @event['player']
    
    @pstats = _getInfo(@player)[0]
    @time = integer( @pstats['online_time'] + ((time() - @pstats['timestamp']) / 1000) )
    _storeInfo(@player, array('status', 'online_time'), array('Offline', @time))
)

bind('player_join', null, null, @event,
    @table = 'commandhelper_players'
    @player = @event['player']
    @pstats = _getInfo(@player)[0]
    
    @trusted = 7200 #Time until trusted
    if(@pstats['online_time'] >= @trusted) { 
        if(!has_permission(@player, 'rank.trusted')) { 
            runas('~console', '/pex user '.@player.' group add trusted')
            runas('~console', '/pex user '.@player.' group remove player')
            broadcast(_tagmsg('god', @player.' {p}has been promoted to trusted'))
        }
    }
    _storeInfo(@player, array('status', 'timestamp', 'login_count'), array('Online', time(), (@pstats['login_count'] + 1)))
    
    _storeRanks(@player)
    
    _getInfo(@player)
)