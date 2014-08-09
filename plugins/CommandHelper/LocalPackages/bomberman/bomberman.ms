_adminmsg('Bomberman Loaded!')

bind('block_place', null, array('type': 46), @event,
    include('../../includes/bomberman.ms')
    if( !_bomberman_isplaying(player()) ) {
        die()
    }

    @location = array(
        @event['X'], @event['Y'], @event['Z']
    )
    
    if( !_bomberman_player_inc(player(), 'currenttnt', -1) ) {
        _bmsg('You have no tnt left?!')
        cancel()
        die()
    }
    
    @maxfire = _bomberman_player_get(player(), 'firerange')
    
    set_timeout(@ignitionTimeout, closure(
        set_block_at(@location, data_values('fire'))
    
        @directions  = array(
            array(0, 1),
            array(0, -1),
            array(2, 1),
            array(2, -1)
        )
        
        @locations = array(@location)
        @burned = array()
        
        foreach(@directions, @direction) { 
            @newlocation = (@location[0..])
            @abovelocation = (@newlocation[0..])
            
            inc( @newlocation[@direction[0]], @direction[1] )
            inc(@abovelocation[1], -1)
            
            @newblock = split(':', get_block_at(@newlocation))[0]
            @aboveblock = split(':', get_block_at(@abovelocation))[0]
             
            @fire = (0)
            
            while(array_contains(@transparant, @newblock) && @aboveblock != '0' && @fire < @maxfire, 
                array_push(@locations, @newlocation[0..])
                
                inc(@newlocation[@direction[0]], @direction[1])
                inc(@abovelocation[@direction[0]], @direction[1])
                
                @newblock = (split(':', get_block_at(@newlocation))[0])
                @aboveblock = (split(':', get_block_at(@abovelocation))[0])
                
                inc(@fire, 1)
            )
            
            if( array_contains(@burnable, @newblock) ) {
                array_push(@locations, @newlocation[0..])
                array_push(@burned, @newlocation[0..])
                
                array_push(@locations, array(
                    @newlocation[0], @newlocation[1] + 1, @newlocation[2]
                ))
            }
        }
        
        foreach(@locations, @location) {
            set_block_at(@location, data_values('fire'))
        }
        
        set_timeout(@fireTimeout, closure(
            # Explosion done
            _bomberman_player_inc(player(), 'currenttnt', 1)
            
            foreach(@locations, @location) {
                set_block_at(@location, 0)
            }
            
            foreach(@burned, @lo) {
                @item = _bomberman_burnblock()
                if(@item == 0, continue())
                
                set_timeout(5, closure(
                    drop_item(@lo, array(
                        'type': @item,
                        'qty': 1
                    ))
                ))
            }
            
        ))
    ))
)

bind('entity_damage', null, array('type': 'PLAYER'), @event,
    if(@event['cause'] != 'FIRE' && @event['cause'] != 'FIRE_TICK') {
        die()
    }

    include('../../includes/bomberman.ms')
    if( !_bomberman_isplaying(player()) ,die())
    
    cancel()
    set_ponfire(0)
    
    if(_bomberman_player_get(player(), 'hurt') == true, die())
    
    # on hurt start
    _bomberman_player_inc(player(), 'lives', -1)
    play_entity_effect(@event['id'], 'HURT')
    # On hurt end
    
    _bomberman_player_set(player(), 'hurt', true)
    set_timeout(@immortalTimeout, closure(
        _bomberman_player_set(player(), 'hurt', false)
    ))
)

bind('item_pickup', null, null, @event,
    include('../../includes/bomberman.ms')
    if( !_bomberman_isplaying(player()) ) {
        die()
    }
    
    @item  = @event['item']
    modify_event('item', null)
    
    # Redstone, extend the fire range
    if( @item['type'] == data_values('redstone') ) {
        _bomberman_player_inc(player(), 'firerange')
        _bmsg_levelup('Increased you blast power!')
        die()
    }

    # Tnt, increasing TNT
    if( @item['type'] == data_values('tnt') ) {
        _bomberman_player_inc(player(), 'currenttnt')
        _bmsg_levelup('Found another tnt, you can use it now!')
        die()
    }
    
    # Leather boots, increase walk speed
    if( @item['type'] == 301 ) { # Leather boots
        _bomberman_player_inc(player(), 'speed')
        _bmsg_levelup('SPEED UP!!!')
        die()
    }
    
    # Slow down, temporary, when picking cobweb
    if( @item['type'] == data_values('cobweb') ) {
        set_peffect(player(), 2, 10, 5) # Add effect for sloweness for five seconds
        _bmsg_levelup('Oh no, you got slowed down by some webs')
        die()
    }
    
    # Speed up for some time, when getting golden boots
    if( @item['type'] == 317 ) { # Golden boots
        set_peffect(player(), 1, 10, 5) # Add effect for speed for five seconds
        _bmsg_levelup('Supaor speed!')
        die()
    }
    
    # Get a pork for an extra live?
    if( @item['type'] == 322 ) { # Golden apple
        _bomberman_player_inc(player(), 'lives', 3)
        _bmsg_levelup('Super revive!')
        die()
    }
    
    if( @item['type'] == 260 ) { # apple
        _bomberman_player_inc(player(), 'lives', 1)
        _bmsg_levelup('Omnumnumnum')
        die()
    }
    
    # NOT IMPLEMENTED YET
    # Piston, get tnt move power stuff
    if( @item['type'] == 33 ) { #piston
        _bomberman_player_inc(player(), 'bumppower')
        _bmsg_levelup('Your arms grow stronger.')
        die()
    }
    
    #modify_event('item', @item)
    msg(@event)
)

#############################################################################
## Restrict dropping, opening inv, block breaking
#############################################################################
bind('item_drop', null, null, @event,
    include('../../includes/bomberman.ms')
    if( !_bomberman_isplaying(player()) ) {
        die()
    }
    
    cancel()
    _bmsg('Don\'t drop items in game!')
)

bind('block_break', null, null, @event,
    include('../../includes/bomberman.ms')
    if( !_bomberman_isplaying(player()) ) {
        die()
    }
    
    cancel()
    _bmsg('Don\'t try to break blocks while playing!')
)

bind('inventory_open', null, null, @event,
    include('../../includes/bomberman.ms')
    if( !_bomberman_isplaying(player()) ) {
        die()
    }
    msg('test')
    cancel()
    _bmsg('Na-ah!')
)

#############################################################################
## Bump away TNT blocks (not working)
#############################################################################
bind('player_interact', null, array('block': 46, 'button': 'right'), @event,
    include('../../includes/bomberman.ms')
    if( !_bomberman_isplaying(player()) ) {
        die()
    }
    
    cancel()
    
    # array(x, z) for the different facings
    assign(@facings, array(
        'north': array(0, 1),
        'south': array(0, -1),
        
        'west': array(1, 0),
        'east': array(-1, 0)
    ))
    
    assign(@power, rand(10, 20) / 10);
    
    if( !array_index_exists(@facings, @event['facing']), die())
    _bmsg(@power)
    assign(@facing, @facings[ @event['facing'] ])
    assign(@vector, array(
        (@facing[0] * @power),
        0.3,
        (@facing[1] * @power),
    ))
    
    set_block_at(@event['location'], 0)
    assign(@falling, spawn_falling_block(
        @event['location'],
        46,
        @vector
    ))
    export(@falling)
)


