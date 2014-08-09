#############################################################################
## Events.
#############################################################################
bind(block_break, array(priority: normal), null, @event,
    if(_plot_canbuild()) {
        return()
    } else {
        cancel()
    }
)

bind(block_place, array(priority: normal), null, @event,
    if(_plot_canbuild()) {
        return()
    } else {
        cancel()
    }
)

bind(player_interact, array(priority: normal), array(item: data_values('lava_bucket')), @event,
    if(_plot_canbuild()) {
        return()
    } else {
        cancel()
    }
)

bind(player_interact, array(priority: normal), array(item: data_values('water_bucket')), @event,
    if(_plot_canbuild()) {
        return()
    } else {
        cancel()
    }
)

bind(player_interact, array(priority: normal), array(item: data_values('painting')), @event,
    if(_plot_canbuild()) {
        return()
    } else {
        cancel()
    }
)
