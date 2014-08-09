bind('player_chat', array(priority: 'Lowest'), null, @event,
  if(is_cancelled()) {
    return()
  }
  modify_event('recipients', array())
  _broadcast(sprintf(@event['format'], _get_player_nick(@event['player']), @event['message']))
)
