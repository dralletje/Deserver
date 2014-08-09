#############################################################################
## Events.
#############################################################################
bind(player_command, array(priority: normal), null, @event,
    if(substr(@event['command'], 0, 2) != '//') {
        return()
    }
    
    cancel()
    assign(@tempcommand, reg_split(' ', @event['command']))
    
    assign(@command, substr(@tempcommand[0], 2))
    assign(@rank, 'trusted')
    
    if(@command == 'set') {
        assign(@rank, 'player')
    }
   #assign(@exec, closure(
   _gmask(@rank, 'gmask', @event['command'])
   #))
   #assign(@we_time, import('worldedit_cooldown'))
   #if(!is_integer(@we_time)) {
   #    console('@we_time is null, or whatever, so I set it now...')
   #    export('worldedit_cooldown', add(time(), 2000))
   #    execute(@exec)
   #    return()
   #}

   #if(time() > @we_time) {
   #    export('worldedit_cooldown', add(time(), 2000))
   #    execute(@exec)
   #    return()
   #}

   #msg(_tagmsg('we', 'Due overload, your worldedit request will be handled in '.integer((@we_time - time())/1000).' second(s)'))
   #set_timeout(@we_time - time(),
   #    @exec
   #)
   #export('worldedit_cooldown', add(@we_time, 2000))
)
