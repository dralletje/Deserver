proc(_canbuild, @player, @location, @error,
    include('plots/plots.inc')
    # checks for permission, change it to any you want
    if(has_permission('rank.admin')) {
        return('true')
    }

    if(pworld(@player) == 'mercury' || pworld(@player) == 'jupiter') {
        #msg(_tagmsg('Immortal', 'Because of a 1.3 bug, plots and creative are disabled for the time being.'))
        #return(false)
        return(_plot_canbuild(@location, @player))
    }
    
    return(true)
    
    # My region system failed at deserver :(
    # return(_region_canbuild(@location, @player))
)
