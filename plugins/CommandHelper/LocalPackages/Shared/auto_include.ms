# Load shared include
proc('_si', @name,
  return('../CHIncludes/'.@name.'.ms')
)



# Send messages into the network
proc('_broadcast', @message,
  include(_si('network'))
  _network_message(@message)
)

proc('_msg', @players, @message,
  if(!is_array(@players)) {
    @players = array(@players)
  }

  include(_si('network'))
  _network_message(@message, 'private', @players)
)


# Custom events
proc('_trigger', @name, @args,
  @handlers = import('events')
  if(!is_array(@handlers)) {
    return()
  }
  foreach(@id:@handler in @handlers) {
    if(@handler['name'] != @name) {
      continue()
    }
    execute(@args, @id, @handler['code'])
  }
)

proc('_bind', @name, @handler,
  @value = import('events')
  if(!is_array(@value)) {
    @value = array()
    export('events', @value)
  }

  array_push(@value, array(
    name: @name,
    code: @handler
  ))
)

proc('_unbind', @id,
  @value = import('events')
  array_remove(@value, @id)
)
