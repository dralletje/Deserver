# Message types
export('message_types', array(
  'broadcast': '',
  'private': 'PRV',
  'join': 'JOIN',
  'part': 'PART'
))


irc_create(1)
include('../CHIncludes/irc.ms')
_irc_connect()

bind('irc_connection_exception', null, null, @event,
  console(@event['exceptionclass'] .
    '(' . @event['message'] . ') .
    Reconnecting...')

  include('../CHIncludes/irc.ms')
  _irc_connect()
)

bind('irc_disconnected', null, null, @event,
  include('../CHIncludes/irc.ms')
  if(!@event['wasClean']) {
    console('Unclean disconnect. Reconnecting...')
    _irc_connect()
  }
)

bind('irc_connected', null, null, @event,
  console('Connected.')
)
bind('irc_welcomed', null, null, @event,
  console('Welcomed.')
  irc_join(1, '#NETWORK-HUB')
)
bind('irc_joined', null, null, @event,
  if (@event['who'] != irc_info(@event['id'])['nickname']) {
    return()
  }

  console('Joined' @event['channel'])
)

# Broadcasts
bind('irc_msg', null, null, @event,
  @array = split(' ', @event['message'], 1)
  if(substr(@array[0], 0, 1) != '*') {
    return()
  }
  @command = substr(@array[0], 1)
  @splitup = split(':', @command)
  @splitup[] = ''
  @command = @splitup[0]
  @extra = @splitup[1]

  try(
    if(substr(@extra, 0, 1) == '!') {
      @extra = json_decode(substr(@extra, 1))
    }
    , @ex, #nothing
  )

  @types = import('message_types')
  @type = array_index(@types, @command)


  if(@type == null) {
    @type = 'unknown'
    broadcast('Not yet implemented')
    _adminmsg('Not yet implemented: '.@command)
  }

  @message = substr(@array[1], 1)
  @message = colorize(@message)

  _trigger('network', array(
    message: @message,
    extra: @extra,
    type: @type
  ))
)

# Questions
bind('irc_msg', null, null, @event,
  if(substr(@event['message'], 0, 1) != '?') {
    return()
  }

  @b = split(' ', @event['message'])
  @id = @b[1]
  @command = @b[2]
  @args = @b[cslice(3, -1)]

  _trigger('network_question', array(
    command: @command,
    args: @args,
    id: @id,
    callback: closure(@answer,
      include(_si('network'))
      _network_answer(@id, @answer)
    )
  ))
)

# Responses
bind('irc_msg', null, null, @event,
  if(substr(@event['message'], 0, 1) != '!') {
    return()
  }

  @b = split(' ', @event['message'])
  @id = @b[1]
  @response = @b[2]

  _trigger('network_response', array(
    response: @response,
    id: @id
  ))
)
