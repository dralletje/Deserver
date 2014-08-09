#############################################################################
## Striked banning methods
#############################################################################

proc(_builder_get, @who,
    assign(@BuilderPoints, get_value('builder', to_lower(@who)))
    if( !is_array(@BuilderPoints) ) { 
        assign(@BuilderPoints, array()) 
    }
    return(@BuilderPoints)
)

proc(_builder_add, @who, @reason,
    assign(@who, @who)
     
    if(ponline(@who)) {
        tmsg(@who, _tagmsg('Builder', 'You have got a Builder Point; Three points is Builder Promotion'))
    }
    
    assign(@points, get_value('builder', @who))
    if( !is_array(@points) ) {
        assign(@points, array())
    }
    array_push(@points, @reason)
    store_value('builder', @who, @points)
    
    _adminmsg(player().' has given a point for Builder to '.@who)
)

