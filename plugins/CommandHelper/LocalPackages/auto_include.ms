proc(_set_ploc, assign(@player, null), @location,
    if(is_array(@player)) {
        @location = @player
        @player = player()
    }
    
    if(@player == null) {
        store_value('tpback.'. player(), ploc())
        return()
    }
        
    # if(_inPvP(@player)) {
        # assign(@health, pinfo(@player, 5))
        # if(@health < 5) {
            # die(_tagmsg('Warlord', 'You need more health to teleport!'))
        # }
        # set_phealth(@player, @health - 4)  
        ## Faction check for anti tp
        # try( @ownFaction = json_decode(read('../../../mstore/factions_uplayer@default/'.to_lower(@player).'.json'))['factionId'], @ownFaction = '' )
        # @playersInRadius = players_in_radius(array(x: ploc(@player)['x'], y: ploc(@player)['y'], z: ploc(@player)['z'], world: ploc(@player)['world']), 32)
        # if(is_array(@playersInRadius)) {
            # if(array_size(@playersInRadius) > 1) {
                # if(@ownFaction == '') { die(tmsg(@player, _tagmsg('Warlord', 'Don\'t teleport from battle!'))) }
                # foreach(@playersInRadius, @playerInRadius) {
                    # try( @faction = json_decode(read('../../../mstore/factions_uplayer@default/'.to_lower(@playerInRadius).'.json'))['factionId'], @faction = '' )
                    # if(@faction == '' || @faction != @ownFaction) { die(tmsg(@player, _tagmsg('Warlord', 'Don\'t teleport from battle!'))) }
                # }
            # }
        # }
    # }
    set_ploc(@player, @location)
    store_value('tpback.'. @player, ploc())
)

#= Multi Teleport ==================================================#
proc(_multiTP, @player, @locArray,
    #organise location array
    @x = @locArray[0]
    @y = @locArray[1]
    @z = @locArray[2]
    try(
        @world = @locArray[3]
    ,@err,
        @world = pworld(@player)
    )
    try(
        @yaw = @locArray[4]
    ,@err,
        @yaw = pfacing(@player)[0]
    )
    try(
        @pitch = @locArray[5]
    ,@err,
        @pitch = pfacing(@player)[1]
    )
    @horse = null
    @mobs = array()
    #Determin if @player is riding a mob and/or holding any leashes.
    if(@world == pworld(@player)){
        try(@horse = get_entity_vehicle(pinfo(@player)[13]))
        foreach(entities_in_radius(ploc(@player),16),@entity){
            try(
                if(get_leashholder(@entity) == pinfo(@player)[13]){
                    array_push(@mobs, @entity)
                }
            )
        }
    }
    #Determine a safe teleport height
    if(@y >= 254){
        @safeY = 252
    } else {
        for(@safeY = @y, @safeY < 252, @safeY++){
            if(!get_block_info(array(@x, (@safeY + 1), @z, @world))['solid'] && !get_block_info(array(@x, (@safeY + 2), @z, @world))['solid']){
                if(@horse == null){
                    @safeY
                    break()
                } else { #Riding makes the player 3 blocks high
                    if(!get_block_info(array(@x, (@safeY + 3), @z, @world))['solid']){
                        @safeY
                        break()
                    }
                }
            }
        }
    }
    #Send mobs first otherwise they may be left in an unloaded chunk.
    #Dismount and send horse first
    if(!is_null(@horse)){
        set_entity_rider(@horse, null)
        set_entity_loc(@horse,array(@x,@safeY + 1,@z,@world,@yaw,@pitch))
    }
    #Send leashed mobs next
    foreach(@mobs, @mob){
        set_entity_loc(@mob,array(@x,@safeY + 1,@z,@world,@yaw,@pitch))
    }
    #Finally teleport @player
    set_ploc(@player,array(@x,@safeY,@z,@world))
    pfacing(@player, @yaw,@pitch)
    #Re-mount
    if(!is_null(@horse)){
        set_entity_rider(@horse, pinfo(@player)[13])
    }
    #Re-leash
    foreach(@mobs, @mob){
        set_leashholder(@mob,pinfo(@player)[13])
    }
    return()
)

# proc(_help, @file,
    # try(
        # assign(@text, read('../../../help/'.@file.'.txt')),
        # die(_tagmsg('Help', 'Help file '.@file.' couldn\'t be loaded.'))
    # )  
    # msg(replace(@text, '&', '\u00A7'))
# )

proc(_effect, @player, @perm,
    if(!has_permission('effect.'.@perm)) { die(_tagmsg('Herobrine', 'you don\'t have permission to use this command')) } 
    @init_player = player()
    
    return(@init_player)
)