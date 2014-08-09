proc(_help, @file,
    try(
        assign(@text, read('../../CHConfig/help/'.@file.'.txt')),
        die(_tagmsg('Help', 'Help file {s}'.@file.' {p}does not exist.'))
    )  
    msg(_colorize(@text))
)

proc(_isAllowed, @player = player(),
    @allowed = array('Plancke', 'the_immortal', '~console')
    if(array_contains(@allowed, @player)) { return(true) }
    return(false)
)

proc(_inCreative, @player,
    @worlds = array('mercury','jupiter', 'venus', 'venus_nether', 'venus_the_end')
    if(array_contains(@worlds, pworld(@player))) { return(true) }
    return(false)
)

proc(_inPvP, @player = player(),
    #PVP removed
    return(false)
    # @worlds = array('newpvp','newpvp_the_end', 'newpvp_nether')
    # if(array_contains(@worlds, pworld(@player))) { return(true) }
    # return(false)
)

proc(_inWorld, @world, @reqworld,
    @actualworld = replace(replace(@world, '_nether', ''), '_the_end', '')
    if(@reqworld == @actualworld) { return(true) }
    return(false)
)

proc(_importConfig,
    if(import('config.pex') == null) { export('config.pex', yml_decode(read('../PermissionsEx/permissions.yml'))) \ _adminmsg('Pex Config Imported!') }
    if(import('config') == null) {
        @config = array()
        @files = split('\u000A', shell('ls', array(workingDir: '../../CHConfig')))
        foreach(@files, @file) {
            if(@file == 'help') { continue() }
            @key = split('.', @file)[0]
            @file = replace(@file, '\u000A', '')
            @value = yml_decode(read('../../CHConfig/'.@file))
            array_set(@config, @key, @value)
        }
        export('config', @config)
        _adminmsg('Configs Imported!')
    }    
)

proc(_readConfig, @file,
    _importConfig()
    if(@file == 'pex') { try( return(import('config.pex')) ) }
    try( @config = import('config')[@file], @ex, die(_tagmsg('God', 'Config %SCOLOR%'.@file.'%PCOLOR% not found')) )
    return(@config)
)

proc(_saveConfig, @name, @config,
    if(@name == 'pex') { export('config.pex', @config) }
)

proc(_colorize, @string,
    @config = _readConfig('config')
    @string = replace(@string, '%MCOLOR%', colorize(@config['tag-color']))
    @string = replace(@string, '%PCOLOR%', colorize(@config['primary-color']))
    @string = replace(@string, '%SCOLOR%', colorize(@config['secondary-color']))
    
    @string = replace(@string, '{t}', colorize(@config['tag-color']))
    @string = replace(@string, '{p}', colorize(@config['primary-color']))
    @string = replace(@string, '{s}', colorize(@config['secondary-color']))
    return(colorize(@string))
)

proc(_permcolorize, @string,
    @colors = array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 'a', 'b', 'c', 'd', 'e', 'f', 'o', 'l', 'k', 'n', 'm', 'A', 'B', 'C', 'D', 'E', 'F', 'O', 'L', 'K', 'N', 'M')
    foreach(@colors, @color) {
        if(has_permission('chat.color.'.@color)) {
            @string = replace(@string, '&'.@color, colorize('&'.@color))
        } else {
            @string = replace(@string, '&'.@color, '')
        }
    }
    return(_colorize(@string))
)


proc(_world_info, @inputWorld,
    @default = 'solarsystem'
    @config = _readConfig('worlds')
    @inputWorld = to_lower(@inputWorld)
    if(array_index_exists(@config['worlds'], @inputWorld)) {
        @disabled = false
        try( 
            @disabled = @config['worlds'][@inputWorld]['disabled']
            if(@disabled) { 
                msg(_tagmsg('Atlas', 'World {s}'.@config['worlds'][@inputWorld]['nick'].' {p}is disabled, sorry!'))
                return(_world_info(@default)) 
            }
        )
        
        return(@config['worlds'][@inputWorld]) 
    }
    foreach(array_keys(@config['worlds']), @world) {
        if(length(@world) < length(@inputWorld)) { continue() }
        if(substr(@world, 0, length(@inputWorld)) == @inputWorld) {
            return(_world_info(@world))
            #Basically always working towards the first if structure
        }
    }
    
    #value not found, checking groups
    foreach(array_keys(@config['groups']), @group) {
        for(@i = 0, @i < array_size(@config['groups'][@group]), @i++) {
            @world = @config['groups'][@group][@i]
            if(length(@world) < length(@inputWorld)) { continue() }
            if(substr(@world, 0, length(@inputWorld)) == @inputWorld) {
                return(_world_info(@group))
            }
        }
    }
    
    die(_tagmsg('Atlas', 'World {s}'.@inputWorld.' {p}could not be found!'))
)

proc(_world, @world, return(_world_info(@world)['realname']))
proc(_world_nick, @world, return(_world_info(@world)['nick']))
proc(_world_color, @world, return(color(_world_info(@world)['color'])))

proc(_group_info, @player,
    @config = _readConfig('pex')
    try(@usergroups = @config['users'][@player]['group'], @ex, @usergroups = array('player') )
    @array = array()
    
    @rank = 0
    foreach(@usergroup in @usergroups) {
        if(@rank <= @config['groups'][@usergroup]['options']['weight']) {
            @rank = @config['groups'][@usergroup]['options']['weight']
            array_set(@array, 'color', @config['groups'][@usergroup]['prefix'])
            array_set(@array, 'name', @config['groups'][@usergroup]['options']['realname'])
        }
    }
    return(@array)
)
proc(_group_color, @player, return(color(replace(_group_info(@player)['color'], '&', ''))))

proc(_get_player_color_pro, @player,
    @color = query('CommandHelper', 'SELECT prefix FROM `players` WHERE username = "'.@player.'"')[0]['prefix']
    if(@color == null) {
        @color = "&7"
    }
    return(colorize(@color))
)

proc(_get_player_color, @player, 
    @color = get_value('color.'.@player)
    if(@color == null) {
        @color = "&7"
    }
    return(@color)
    # @config = _readConfig('pex')
    # try( return(colorize(@config['users'][@player]['prefix'])) )
    # return(colorize(_group_color(@player)))
)

proc(_set_player_color, @player, @color,
    store_value('color.'.@player, @color)
    # if(!@color) { @color = _get_player_color(@player) }
    # @config = _readConfig('pex')
    # try( @config['users'][@player]['prefix'] = @color )
    # _saveConfig('pex', @config)
    runas('~console', "/pex user @player prefix @color")
    _set_list_name(@player)
)

proc(_distance, @arr1, @arr2, return(floor(pow(subtract(@arr2[0], @arr1[0]), 2) +  pow(subtract(@arr2[2], @arr1[2]), 2))) )

proc(_tagmsg, @tag, @msg,
    @tags = array(
        'help':'Help',
        'hat':'Hat',
        'region':'Region',
        'nick':'Nick',
        'mute':'Mute',
        'admin message':'AdminMsg',
        'gamemode':'Gamemode',            
        'groups':'Groups',
        'afk':'Afk',
        'restart':'Restart',
        'bug':'Stella',
        'reload':'Reload',
        'police':'Police',
        'console':'Console',
        'colorme':'God',
        'trader':'Trader',
        'backpack':'Backpack',
        'vortex':'Vortex',
        'god':'God',       
        'teleport':'Merlin',
        'we':'sk89q',
        'estate':'Estate Manager',
        'noperm': 'God',
        'unknown': 'God',
        
        'economy': 'Money',
        'walkspeed': 'WalkSpeed',
        'flyspeed': 'FlySpeed',
    )
    try( @tag = @tags[to_lower(@tag)] )
    @tag = _capitalize(@tag)
    @msg = replace(@msg, '\n', '\n'.colorize('{t}['.@tag.']{p} '))
    @return = '{t}['. @tag. '] {p}'.@msg
    return(_colorize(@return))
)

proc(_array_delete, @array, @value,
    if(!is_array(@array)) { return(array()) }
    for(assign(@i, 0), @i < length(@array), @i++,
        if(@array[@i] == @value) {
            array_remove(@array, @i)
        }
    )
    return(@array)
)

proc(_array_add, @array, @value,
    if(!is_array(@array)) {
        return(array())
    }
    if(array_contains(@array, @value)) {
        return(@array)
    }
    array_push(@array, @value)
    return(@array)
)

proc(_adminmsg, @msg, @tag = 'AdminMsg',
    console(@msg)
    foreach(_admins('on'), @pl) {
        try( tmsg(@pl, _tagmsg(@tag, '&c'.@msg)) )
    }
)

proc(_admins, @state = 'off',
    if(@state == 'off') { return(array_merge(pex_get_group_users('uberadmin'), pex_get_group_users('owner'))) }
    
    @admins = array()
    foreach(all_players(), @pl) {
        if(has_permission(@pl, 'adminmsg.receive')) { array_push(@admins, @pl) }
    }
    return(@admins)
)

proc(_getrecipients, @player,
    assign(@recipients, array())
    if(length(all_players())>= 10) { return(all_players()) }
    if(pworld(@player) == 'newearth'){
        return(all_players('newearth'))
    } else {
      foreach(all_players(), @pl) {
        if(pworld(@pl != 'newearth')) { array_push(@recipients, @pl) }
      }  
    }
    return(@recipients)
)

if(!is_proc('_player') && !is_proc('player')) {
    proc(_player, @nick,
        try( @player = player(@nick), @ex, @player = null)
        return(@player)  
    )
}

proc(_init, @player, @perm,
    if(
        not(has_permission(@perm)),
        die(_tagmsg('GOD', 'you don not have permission to use this command'))
    )

    assign(@init_player, _player(@player))
    if(
        is_null(@init_player),
        die(_tagmsg('GOD', 'Player is not online'))
    )

    return(@init_player)
)

proc(_hasperm, @perm, @rank = 'player',
    if(_isAllowed(player())) { return(true) }
    if(!has_permission(@perm)) {
        @rank = to_lower(@rank)
        @messages = array(
            'veteran': 'You need Veteran rank to execute this command',
            'vip': 'You need VIP to execute this command!',
            'player': 'You are not allowed to do that!',
        )
        if(!array_contains(array_keys(@messages), @rank)){ @rank = 'player' }
        die(_tagmsg('GOD', @messages[@rank]))
    }
    return(true)
)

proc(_import, @class,
    msg('importing '.@class)
    try(
        include('/includes/'.@class.'.ms'),
        die(_tagmsg('Import', 'Class '.@class.' could not be loaded'))
    )   
    msg('importing '.@class.' succeed')  
)

proc(_set_list_name, @player,
    @color = reg_replace("\\&[0-9]*\\[\\&[0-9]*(VIP)\\&[0-9]*\\] ", "", _get_player_color(@player))
    
    if(@color == null) { @color = _group_color(@player) } else { @color = colorize(@color) }
    @playername = _get_player_nick(@player)
    @tabname = _world_color(pworld(@player)).'@'.@color.@playername
    if(length(@tabname) > 16) { @tabname = substr(@tabname, 0,16) }
    set_list_name(@player, @tabname)
)

proc(_noperms, die(_tagmsg('NoPerm', 'You do not have the permission to do this')))
proc(_unknown, die(_tagmsg('Unknown', 'Unknown Command')))
proc(_capitalize, @string, return(to_upper(substr(@string, 0, 1)).substr(@string, 1)))

proc(_calculate_nearest_degree, @degree, @number,
        @intervals = 360/@degree
        @degrees = array()
        for(@i = 0, @i <= @intervals, @i++,
            array_push(@degrees, @i * @degree)
        )
        array_reverse(@degrees)
        foreach(@degrees, @d,
                if(@number + @degree / 2 > @d) {
                        @ret = @d
                        break()
                }
        )
        return(@ret)
)

proc(_split_in_groups, @string, @glength,
    @length = length(@string)
    @groups = integer(@length / @glength)
    @output = array()
    for(@i = 1, @i <= @groups, @i++,
        array_insert(@output, substr(@string, @length - (@glength * @i), @length - (@glength * (@i - 1))), 0)
    )
    
    if(@length != (array_size(@output) * @glength)) {
        array_insert(@output, substr(@string, 0, @length - (@groups * @glength)), 0)
    }
    
    return(@output)
)

# proc(_barMessages, @player, @messages, @seconds,
    # set_bar_health(@player, 100)
    # for(@i = 0,@i < array_size(@messages), @i++) {
        # set_timeout(@seconds * 1000 * @i, closure(
            # if(!ponline(@player)) { clear_task() }
            # set_bar_message(@player, _colorize(@messages[@i]))
        # ))
    # }
    # set_timeout(@seconds * 1000 * array_size(@messages), closure(premove_bar(@player)))
# )

proc(_clear_pinv, @player,
  if(!@player, @player = player())
  @inv = array()
  array_resize(@inv, 104)
  set_pinv(@player, @inv)
)
