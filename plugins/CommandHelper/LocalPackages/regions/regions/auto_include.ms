proc(_region_add_player, assign(@player, player()), assign(@location, null),
    die()
)

proc(_region_from_location, @location,
    assign(@regions, get_values('regions', pworld(@player), 'locations'))
    if(length(@regions) == 0) { return(null) }
    
    assign(@lastdistance, 10000)
    assign(@lastregion, null)
    
    foreach(
        array_keys(@regions),
        @regiontag,
        assign(@distance, _distance(@regions[@regiontag], @location))
        
        if(@distance < @lastdistance) {
            assign(@lastdistance, @distance)
            assign(@lastregion, @regiontag)
        }
    )
    
    if(@lastregion == null) { return(null) }
    assign(@regionname, reg_split('\\.', @lastregion)[3])
    
    return(@regionname)
)

proc(_region_to_location, @loc,
    die()
)

proc(_region_owns, @location, assign(@player, player()),
    die()
)

proc(_region_world,
    die()
)

proc(_region_wipe, @location,
    die()
)

proc(_region_canbuild, assign(@location, null), assign(@player, player()),
    return(true)
    
    # if(is_array(@location)) {
        # assign(@regionname, _region_from_location(ploc(@player)))
    # } else {
        # assign(@regionname, @location)
    # }
    
	# if(@regionname == null) {
		# return(true)
	# }
	
    # assign(@members, get_value('regions', pworld(@player), @regionname, 'members'))
    # if(@members == null) {
        # assign(@members, array())
    # }
    
    # if(array_contains(@members, player())) {
        # return(true)
    # }
    
    # msg(_tagmsg('Vortex', 'You can\'t build on other humans land.'))
    # return(false)
)

