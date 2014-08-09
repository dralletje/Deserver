#############################################################################
## Events.
#############################################################################
bind('player_command', array(priority: normal), null, @event,
try(
    if(substr(@event['command'], 0, 2) != '//') {
        die()
    }
    
    cancel()
    assign(@tempcommand, reg_split(' ', @event['command']))
    
    assign(@command, substr(@tempcommand[0], 2))
    assign(@rank, 'trusted')
    
    if(@command == 'set' || @command == 'wand' || @command == 'undo') { @rank = 'player' }

    if(@command == 'pos1' || @command == 'pos2') { @rank = 'player' }

   assign(@exec, closure(
        _gmask(@rank, 'gmask', @event['command'])
   ))
   assign(@we_time, import('worldedit_cooldown'))
   if(!is_integer(@we_time)) {
       console('@we_time is null, or whatever, so I set it now...')
       export('worldedit_cooldown', add(time(), 2000))
       execute(@exec)
       die()
   }

   if(time() > @we_time) {
       export('worldedit_cooldown', add(time(), 2000))
       execute(@exec)
       die()
   }

   msg(_tagmsg('we', 'Due overload, your worldedit request will be handled in '.integer((@we_time - time())/1000).' second(s)'))
   set_timeout(@we_time - time(),
       @exec
   )
   export('worldedit_cooldown', add(@we_time, 2000))
)
)
