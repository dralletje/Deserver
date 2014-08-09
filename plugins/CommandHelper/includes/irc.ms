proc('_irc_connect',
  @options = array()
  @options['username'] = 'testbot'
  @options['realname'] = 'Minecraft powered bot'
  @nick = 'Server'.rand(999)

  #@options['port']     = 25564
  #@host = 'localhost'

  @host = 'irc.deserver.tk'

  if (!irc_info(1)['connected']) {
      console('Connecting...')
      irc_connect(1, @nick, @host, @options)
  }
)

proc('_irc_others',
  @users = irc_channel_info(1, '#network-hub')['users']
  @better = array_keys(@users)
  @good = array_filter(@better, closure(@key, @val,
    return(reg_count('Server([0-9]*)', @val) == 1)
  ))
  return(@good)
)
