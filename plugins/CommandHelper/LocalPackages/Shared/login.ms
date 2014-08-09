bind('player_join', null, null, @event,
  @player = @event['player']
  @times = array('mercury': 'day', 'jupiter': 'day')
  if(array_index_exists(@times, pworld())) { set_ptime(@times[pworld()]) } else { preset_time() }

  if(@event['first_login']) {
      store_value('PromoteTimer.'.@player, nano_time())
      broadcast(_tagmsg('GOD', '{s}'.@player.'{p} Joined for the first time!'))
      console(_tagmsg('GOD', '{s}'.@player.'{p} Joined for the first time!'))
  }
  
  _help('motd')
  
  export('players.'.@player, true)
)



bind('player_quit', null, null, @event,
  include(_si('network'))

  @player = @event['player']
  @nick = _get_player_nick(@player)

  # @logoutcode = closure( if(!ponline(@player)) { broadcast(color('5').'* '._group_color(@player).@nick.color('7').' left...') })
  # @logger = set_timeout(2000, @logoutcode)

  @msg = _colorize('{t}* {p}'._get_player_color(@player).@nick.'{p} left...')
  _network_message(@msg, 'part', @player)

  modify_event('message', null)
)


bind('player_join', null, null, @event,
  include(_si('network'))

  @player = @event['player']
  @nick = _get_player_nick(@player)
  set_display_name(@player, @nick)

  @msg = _colorize('{t}* {p}'._get_player_color(@player).@nick.'{p} joined Deserver')
  _network_message(@msg, 'join', @player)

  _set_list_name(@player)
  modify_event('join_message', null)

  #modify_event('message',  _colorize('{t}* {p}'._get_player_color(@player).@nick.'{p} joined Deserver'))
  #_barMessages(@player, array('Welcome to Deserver!', 'Enjoy your stay'), 1)
)
