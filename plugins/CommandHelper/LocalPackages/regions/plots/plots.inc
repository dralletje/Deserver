proc(_plot_location, @loc,
    if(is_array(@loc)) {
        assign(@loc, @loc[0])
    }
    if(!is_numeric(@loc)) {
        die('waoh::'.@loc)
    }
    if(@loc < 0) {
        return(floor(divide(@loc, 71)))
    } else {
        return(ceil(divide(@loc, 71)))
    }
)

proc(_plot_add_player_plot, assign(@player, player()), assign(@location, null),
            if(@location == null) { assign(@location, ploc(@player)) }
            assign(@plotcoords, _location_to_plot(@location))
            
            assign(@plotsperplayer, get_value('plots.players', @player))
            assign(@currentplot, array(@plotcoords[0], @plotcoords[1], pworld()))        
            if(!is_array(@plotsperplayer)) {
                assign(@plotsperplayer, array(@currentplot))
                store_value('plots.players', @player, @plotsperplayer)
                return()
            }
            if(array_contains(@plotsperplayer, @currentplot)) {
                return()
            }
            array_push(@plotsperplayer, @currentplot)
            store_value('plots.players', @player, @plotsperplayer)
)

proc(_location_to_plot, @location, assign(@escape, false),
    assign(@plot1, _plot_location(@location))
    assign(@plot2, _plot_location(@location[2]))
    
    if(@escape) {
        assign(@plot1, replace(@plot1, '-', '_'))
        assign(@plot2, replace(@plot2, '-', '_'))
        return('plots.'.pworld().'.'.@plot1.'.'.@plot2)
    }

    return(array(@plot1, @plot2, pworld()))
)

proc(_plot_to_location, @loc,
    proc(_abs, @int, return(integer(abs(@int))))
    assign(@loc, array(replace(@loc[0], '_', '-'), replace(@loc[1], '_', '-')))
    
    assign(@return, array(
        array(
            (((integer(abs(@loc[0])) - 1) * 71) * (@loc[0] / integer(abs(@loc[0])))),
            0,
            (((integer(abs(@loc[1])) - 1) * 71) * (@loc[1] / integer(abs(@loc[1]))))
        ),
        array(
            ((integer(abs(@loc[0])) * 71) * (@loc[0] / integer(abs(@loc[0])))),
            256,
            ((integer(abs(@loc[1])) * 71) * (@loc[1] / integer(abs(@loc[1]))))
        )
    ))
    return(@return)
)

proc(_plot_owns, @location, assign(@player, player()),
    if(get_value(@location) != @player) {
        die(_tagmsg('Estate manager', 'This is not your plot!'))
    }
    _plot_add_player_plot(@player, ploc(@player))
)

proc(_plot_world,
    if(pworld() != 'mercury' && pworld() != 'jupiter') {
        die(_tagmsg('Estate', 'You can only use plot related things on mercury or jupiter!'))
    }
)

proc(_plot_wipe, @location,
    clear_value('plots',pworld(), @location[0], @location[1])
    foreach(
        array_keys(get_values('plots', pworld(), @location[0], @location[1])),
        @key,
        clear_value(@key)
    )
)

proc(_plot_canbuild, assign(@location, null), assign(@player, player()),
    if(@location == null) {
        assign(@location, ploc(@player))
    }

    if(pworld() != 'mercury' && pworld() != 'jupiter') {
        return(true)
    }

    if(has_permission(@player, 'plots.admin')) {
        return(true)
    }
    
    assign(@plotname, _location_to_plot(@location, true))
    # If there is no value, the plot isn't claimed so you have to cancel it
    if(!has_value(@plotname)) {
        assign(@plotsperplayer, get_value('plots.players', @player))
        if(@plotsperplayer == null) { assign(@plotsperplayer, array()) }
        
        if(length(@plotsperplayer) >= 3) {
            msg(_tagmsg('Estate', 'This plot isn\'t claimed, but you already have three\nAsk an admin or veteran to claim one for you.'))
            return(false)
        }
        
        assign(@plotcoords, _location_to_plot(@location))
        _plot_add_player_plot(@player)
        store_value(@plotname,  @player)
        msg(_tagmsg('Estate', 'This is now officially your plot!'))
        _plot_outline(@plotcoords)
        return(true)
    }
    
    # If you're the owner, then you're the owner...
    assign(@owner, get_value(@plotname))
    if(equals_ic(@owner, @player)) {
        return(true)
    }
    
    #if you're a member, you can build too!
    assign(@members, get_value(@plotname.'.members'))
    if(is_array(@members) && array_contains_ic(@members, @player)) {
        return(true)
    }
    
    return(false)
)

proc(_plot_outline, @plot,
    if(pworld() != 'jupiter') { return() }
    assign(@locations, _plot_to_location(@plot))
    assign(@b1, @locations[0])
    assign(@b2, @locations[1])
    
    for(
        assign(@y, min(@b1[0], @b2[0])), 
        lte(@y, max(@b1[0], @b2[0])), 
        inc(@y),
        set_block_at(
            array(@y, (get_highest_block_at(array(@y, 0, @b1[2]))[1] - 1), @b1[2]),
            '35:14'
        )
        set_block_at(
            array(@y, (get_highest_block_at(array(@y, 0, @b2[2]))[1] - 1), @b2[2]),
            '35:14'
        )
        set_block_at(
            array(@y, get_highest_block_at(array(@y, 0, @b1[2]))[1], @b1[2]),
            '85'
        )
        set_block_at(
            array(@y, get_highest_block_at(array(@y, 0, @b2[2]))[1], @b2[2]),
            '85'
        )
    )
    
    for(
        assign(@x, min(@b1[2], @b2[2])), 
        lte(@x, max(@b1[2], @b2[2])), 
        inc(@x),
        set_block_at(
            array(@b1[0], (get_highest_block_at(array(@b1[0], 0, @x))[1] - 1), @x),
            '35:14'
        )
        set_block_at(
            array(@b2[0], (get_highest_block_at(array(@b2[0], 0, @x))[1] - 1),@x),
            '35:14'
        )
        set_block_at(
            array(@b2[0], get_highest_block_at(array(@b2[0], 0, @x))[1],@x),
            '85'
        )
        set_block_at(
            array(@b1[0], get_highest_block_at(array(@b1[0], 0, @x))[1], @x),
            '85'
        )
    )
)
