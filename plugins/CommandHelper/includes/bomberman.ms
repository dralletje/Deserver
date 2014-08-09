#############################################################################
## Bomberman procedures class
#############################################################################

# config variables
assign(@ignitionTimeout, 1000)
assign(@fireTimeout, 500)
assign(@immortalTimeout, 2000)

# Blocks to burn and to pass through
@burnable = array(
    data_values('plank')
)
@transparant = array(
    0,
    data_values('fire')
)

proc('_bomberman_isplaying', @player,
    if( pmode(@player) == 'CREATIVE' ) {
        return(false)
    }
    
    assign(@allowed, array(
        '_the_immortal'
    ))
    if( array_contains(@allowed, to_lower(player())) ) {
        return(true)
    }
    
    if( _bomberman_player_get(@player, 'isplaying', false) ) {
        return(true)
    }
    
    return(false)
)


#############################################################################
## Syncronize the players view with the stats we have gathered
#############################################################################
proc('_bomberman_player_synchotbar', @player,
    assign(@inv, array())
    
    # Clear all slots
    foreach(range(8), @slot) {
        assign(@inv[ @slot ], array('type': 0, 'qty': 0))
    }
    
    # Tnt at slot 0
    assign(@inv[0], array(
      'type': data_values('tnt'),
      'qty': _bomberman_player_get(@player, 'currenttnt')
    ))
    
    # Speed, in golden boots, at slot 6
    assign(@inv[5], array(
      'type': data_values('piston'),
      'qty': _bomberman_player_get(@player, 'bumppower')
    ))
    
    # Speed, in golden boots, at slot 6
    assign(@inv[6], array(
      'type': 317,
      'qty': _bomberman_player_get(@player, 'speed')
    ))
    
    
    # Blast power, in fire, at slot 7
    assign(@inv[7], array(
      'type': 51,
      'qty': _bomberman_player_get(@player, 'firerange')
    ))
    
    # Amount of money, in gold, at slot 8
    assign(@inv[8], array(
      'type': 266,
      'qty': _bomberman_player_get(@player, 'gold')
    ))
    
    set_pinv(@player, @inv)
    
    set_phealth(_bomberman_player_get(@player, 'lives') * 2)
    set_pwalkspeed( 0.2 + _bomberman_player_get(@player, 'speed') * 0.1)
)

#############################################################################
## Get, set, increase.. everthing you want to do with per-player values
#############################################################################
proc('_bomberman_default', @var,
    @defaults = array(
        'firerange': 3,
        'maxtnt': 1,
        'currenttnt': 1,
        'gold': 100,
        'speed': 1,
        'lives': 3,
        'bumppower': 1,
        
        'hurt': false
    )
    
    if( !array_index_exists(@defaults, @var), return(null))
    return(@defaults[@var])
)

proc('_bomberman_player_set', @player, @var, @value,
    store_value('bomberman.round', to_lower(@player), @var, @value)
    _bomberman_player_synchotbar(@player)
)

proc('_bomberman_player_get', @player, @var,
    @value = get_value('bomberman.round', to_lower(@player), @var)
    if( is_null(@value), assign(@value, _bomberman_default(@var)))
    return(@value)
)

proc('_bomberman_player_inc', @player, @var, assign(@amount, 1),
    @value = _bomberman_player_get(@player, @var)
    if( (@value + @amount) < 0 ) {
        return(false)
    }
    
    inc(@value, @amount)
    _bomberman_player_set(@player, @var, @value)
    return(true)
)

#############################################################################
## TNt handling (Not working)
#############################################################################

# Bombs will be saved like this:
# @bombs = array( 'id': 'currentlocation' )

# Then on every move, the id will be found with array_index(@location)
# and the location will be updated

# Formular for current speed to calculate the blocks it moved by power is
# floor((x*10+1)/4) + x*10
# but it doesn't look at walls or anything, so no win for me.

proc('_bomberman_tnt_create', @location,
    # Create a recorded tnt, and return a unique id
    return( @id )
)

# array_index()

proc('_bomberman_tnt_move', @IdOrLocation,
    ## ANYWAY, this is not possible yet

    assign(@bombs, _bomberman_tnt_bombs())

    # Move a tnt around
    if( is_array(@IdOrLocation) ) {
        assign( @location, @IdOrLocation )
        assign( @id, array_index( @bombs, @location ) )
    } else {
        assign( @id, @IdOrLocation )
        assign( @location, @bombs[ @id ] )
    }
    
    return( @id )
)

#############################################################################
## various messages
#############################################################################

proc('_bmsg', @message,
    msg(_tagmsg('Bomber', @message))
)

proc('_bmsg_levelup', @message,
    msg(_tagmsg('Level up!', @message))
)

#############################################################################
## Not sorted yet
#############################################################################

proc('_bomberman_burnblock',
    @type = 0
    @types = array(
        data_values('redstone'),
        data_values('piston'),
        317, # golden boots
        data_values('cobweb'),
        301, # leather boots
        data_values('tnt'),
        260, # apple
        322, # golden apple
    )
    
    @rr = rand(3)
    if(@rr == 1) {
        @rand = rand(length(@types))
        @type = @types[@rand]
    }
    
    return(@type)
)

