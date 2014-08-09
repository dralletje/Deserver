#############################################################################
## Auto announcer made in commandhelper
#############################################################################

#############################################################################
## This is the code to reload the config and messages
#############################################################################

import(@announcer)
if(is_integer(@announcer)) {
    clear_task(@announcer)
}
@config = yml_decode(read('config.yml'))

@prefix = replace(@config['prefix'], '&', '\u00A7')

@messagefile = yml_decode(read('announcements.yml'))
@messages = array()

foreach(array_keys(@messagefile), @group) {
    foreach(@messagefile[@group], @message) {
        array_push(@messages, array(replace(_capitalize(@message), '&', '\u00A7'), @group))
    }
}

@announcercode = closure(
    @num = rand(length(@messages))
    broadcast(@prefix.@messages[@num][0], 'rank.'@messages[@num][1])
)

@announcer = set_interval(@config['interval']*300000, 0, @announcercode)
export(@announcer)
