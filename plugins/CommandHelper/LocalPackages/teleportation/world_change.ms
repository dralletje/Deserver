bind('world_changed', null, null, @event,
    # if(@event['to'] == @event['from']) {
        # store_value('worldloc', pworld(), player(), ploc())
        # return()
    # }
    
    if(@event['to'] == 'mars' || @event['to'] == 'skyblock' || @event['to'] == 'pluto') {
        if(!_isAllowed(player())) {
            set_pflight(player(), false)
        } else {
            set_pflight(player(), true)
        }
    }
    
    @world = _world_info(@event['to'])
    try(
        set_ptime(@world['time']),
        preset_time()
    )
    
    msg(_tagmsg('Teleport', 'Welcome to '.color(@world['color']).@world['nick']))    
)