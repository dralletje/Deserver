_importConfig()
_adminmsg('Commands reloaded.')



# bind('creature_spawn', null, array(priority: 'LOW'), @event, if(@event['location']['world'] == 'mercury' || @event['location']['world'] == 'jupiter') { cancel() } )
bind('entity_damage', null, array('type': 'ITEM_FRAME', 'cause': 'ENTITY_ATTACK'), @e, if(ponline(@e['damager']) && !sk_can_build(@e['damager'], entity_loc(@e['id']))) { cancel() } )