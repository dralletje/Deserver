#############################################################################
## Events.
#############################################################################
bind('block_break', array(priority: normal), null, @event,
    if(!_canbuild(@event['player'], array(@event['block']['X'], @event['block']['Y'], @event['block']['Z']), 'Block break event!')) {
        cancel()
    }
)

bind('block_place', array(priority: normal), null, @event,
    if(!_canbuild(@event['player'], array(@event['X'], @event['Y'], @event['Z']), 'Block place event!!!')) {
        cancel()
    }
)

bind('player_interact', array(priority: normal), array(item: data_values('lava_bucket')), @event,
    try(
        if(!_canbuild(player(), @event['location'], 'Interact with a lava bucket')) {
            cancel()
        }
    )
)

bind('player_interact', array(priority: normal), array(item: data_values('water_bucket')), @event,
    try(
        if(!_canbuild(player(), @event['location'], 'Interact with a water bucket')) {
            cancel()
        }
    )
)

bind('player_interact', array(priority: normal), array(item: data_values('painting')), @event,
    try(
        if(!_canbuild(player(), @event['location'], 'Interact with a painting')) {
            cancel()
        }
    )
)
