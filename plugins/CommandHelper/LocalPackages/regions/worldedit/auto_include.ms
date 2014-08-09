proc(_we_expand,
    assign(@pos1, sk_pos1())
    assign(@pos2, sk_pos2())
    sk_pos1(array(@pos1[0],0,@pos1[2],pworld()))
    sk_pos2(array(@pos2[0],256,@pos2[2],pworld()))
)

proc(_gmask, assign(@rank, 'trusted'),  assign(@mask, 'gmask'), assign(@command, get_cmd()),
    include('../plots/plots.inc')
    if(has_permission('rank.uberadmin')) {
        run(@command)
        return()
    }
    
    if(has_permission('rank.uberbuilder') && _inCreative(player())) {
        sudo('/gmask')
		sudo(@command)
		return()
	}
    
	if(has_permission('rank.venusbuilder') && _inWorld(pworld(), 'venus')) {
		sudo(@command)
		return()
	}
    
    if(has_permission('rank.marsbuilder') && _inWorld(pworld(), 'mars')) {
		sudo(@command)
		return()
	}
    
    if(has_permission('rank.earthbuilder') && _inWorld(pworld(), 'newearth')) {
		sudo(@command)
		return()
	}

    if(!has_permission('rank.'.@rank)) {
        die(_tagmsg('WE', 'You\'re not allowed to use worldedit'))
    }

    if(pworld() != 'mercury' && pworld() != 'jupiter') {
        die(_tagmsg('WE', 'You can only use WorldEdit on {s}Mercury {p}or {s}Jupiter'))
    }
    #die(_tagmsg('Immortal', 'Worldedit, also disabled :s'))

    assign(@plotname, _location_to_plot(ploc(), true))
    assign(@owners, get_value(@plotname))
    if(@owners == null) {
        die(_tagmsg('WE', 'This plot is not claimed.'))
    }
    
    assign(@members, get_value(@plotname.'.members'))
    if(is_array(@members) && array_contains_ic(@members, player())) {
        assign(@cando, true)
    }
    
    if(@owners != player() && !@cando) {
        die(_tagmsg('WE', 'You have to own the plot you want to worldedit on.'))
    }

    assign(@sk_pos1, sk_pos1())
    assign(@sk_pos2, sk_pos2())
    
    assign(@oldplot, import('plots.worldeditcache.'.player()))
    assign(@newplot, _location_to_plot(ploc()))

    if(!is_array(@oldplot)) {
        assign(@oldplot, array(null, null, null))
    }

    # Above code all works I think, but something with the global mask setting, the position stting to be precuse, needs some more attention :)
    if(@oldplot[0] != @newplot[0]|| @oldplot[1] != @newplot[1] || @oldplot[2] != pworld()) {
        assign(@loc, @newplot)
        assign(@location, _plot_to_location(@newplot))
        msg(@location[0].' -- '.@location[1])
        sk_pos1(@location[0])
        sk_pos2(@location[1])

        sudo('/'.@mask.' #region')
        export('plots.worldeditcache.'.player(), array(@newplot[0], @newplot[1], pworld()))
    } 
    
    sk_pos2(@sk_pos2)
    sk_pos1(@sk_pos1)
    sudo(@command)
)
