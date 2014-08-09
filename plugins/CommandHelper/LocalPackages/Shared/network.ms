_bind('network', closure(@args,
  if(@args['type'] != 'broadcast') {
    return()
  }
  broadcast(@args['message'])
  
  # @json = @args['json']
  # chjc_broadcast(@json)
))

_bind('network', closure(@args,
  if(@args['type'] != 'private') {
    return()
  }
  foreach(@pl in @args['extra']) {
    if(!ponline(@pl)) { continue() }
    tmsg(@pl, @args['message'])
  }
))

_bind('network_question', closure(@event,
  if(@event['command'] != 'online') {
    return()
  }
  execute(ponline(@event['args'][0]), @event['callback'])
))

_bind('network', closure(@args,
  include(_si('timed_store'))
  if(@args['type'] != 'join' && @args['type'] != 'part') {
    return()
  }
  _store_timed('players.'.@args['extra'].'_'.@args['type'], true, 5000)
))

_bind('network', closure(@args,
  if(@args['type'] != 'join') {
    return()
  }
  set_timeout(1000, closure(
    if(import('players.'.@args['extra'].'_part') != null) {
      return()
    }
    broadcast(@args['message'])
  ))
))

_bind('network', closure(@args,
  if(@args['type'] != 'part') {
    return()
  }
  set_timeout(1000, closure(
    if(import('players.'.@args['extra'].'_join') != null) {
      return()
    }
    broadcast(@args['message'])
  ))
))
