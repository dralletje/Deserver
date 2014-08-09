# Important! It allows sending events to the network!
proc('_network_message', @message, @type='broadcast', @extra='',
  @prefix = import('message_types')

  _trigger('network', array(
    type: @type,
    extra: @extra,
    message: @message
  ))
  return()

  # Finishing touch for sending over the IRC
  if(is_array(@extra)) {
    @extra = '!'.json_encode(@extra)
  }
  if(@extra != '') {
    @extra = ':'.@extra
  }

  @message = replace(@message, '\u00a7', '&')
  _network_raw('*'.@prefix[@type].@extra' '.@message)
)

proc('_network_raw', @message,
  return()
  @message = replace(@message, '\u00a7', '&')
  irc_msg(1, '#NETWORK-HUB', @message)
)

proc('_network_question', @question, @callback,
  execute(array(), @callback)
  return()

  include('../CHIncludes/irc.ms')

  @id = rand(9999)
  _network_raw('? '.@id.' '.@question)
  @responses = array()
  @repliers = length(_irc_others()) - 1

  _bind('network_response', closure(@event, @id2,
    if(@event['id'] != @id) {
      return()
    }
    @responses[] = @event['response']
    if(length(@responses) == @repliers) {
      _unbind(@id2)
      execute(@responses, @callback)
    }
  ))
)

proc('_network_answer', @id, @answer,
  if(typeof(@id) == 'array') {
    @id = @id['id']
  }
  _network_raw('! '.@id.' '.@answer)
)
