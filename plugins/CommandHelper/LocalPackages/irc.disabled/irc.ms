proc(_translateColor, @colorcode,
    @colors = yml_decode(read('/config.yml'))['color']
    foreach(@colors, @color) {
        if(@color['game'] == @colorcode) {
            return('\u0003'.@color['irc'])
        }
    }
    return('\u000315')
)


proc(_getReply, @trigger, @args, @match, @event,
    if (@trigger == 'hi') {
        return('Hello')
    }
    
    if (@trigger == 'reload') {
        run('/reloadalias')
        return('Reloaded')
    }
)

irc_create(1)

try(    
    @options = array()
    @options['exceptionhandler'] = @handler
    @options['username'] = 'PlanckBot'
    @options['realname'] = 'PlanckeBot'
    
    _adminmsg('Connecting...')
    
    irc_connect(1, 'PlanckBot', 'irc.deserver.tk', @options)
    
    console('Connected.')
)

bind('irc_welcomed', null, null, @event, irc_join(1, '#Deserver'))

bind('irc_msg', null, null, @event,
    @trigchar = '^'
    @allowedNicks = array('Plancke')

    if (!array_contains_ic(@allowedNicks, @event['who'])){ return() }

    @match = reg_match('^' . reg_escape(@trigchar) . '([^ ]+)(\\s+(.*))?$', @event['message'])

    if (@match) {
        @trigger = @match[1]
        @args = @match[3]

        if (@args == '') { @args = null }

        irc_msg(@event['id'], @event['target'], _getReply(@trigger, @args, @match, @event))
    }
)