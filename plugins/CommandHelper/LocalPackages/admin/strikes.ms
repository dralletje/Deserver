#############################################################################
## Striked banning methods
#############################################################################

proc(_strike_get, @who,
    assign(@strikes, get_value('strike', to_lower(@who)))
    if(@strikes == null) { assign(@strikes, array()) }
    return(@strikes)
)

proc(_strike_add, @who, @reason, assign(@kick, true),
    assign(@who, to_lower(_player(@who, 'name')))
     
    if(ponline(@who)) {
        if(@kick) {
            pkick(@who, 'strike: '.@reason)
        } else {
            msg(_tagmsg('Police', 'You have got a strike: '.@reason.'; three strikes is a full ban.'))
        }
    }
    
    assign(@reasons, _strike_get(@player))
    array_push(@reasons, @reason)
    store_value('strike', to_lower(@who), @reasons)
    
    _adminmsg(player()' has struck '.@who.' ('.@reason.')')
)

