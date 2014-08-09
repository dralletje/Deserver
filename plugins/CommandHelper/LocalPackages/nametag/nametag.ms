# proc(_colornames,
    # @scoreboard = 'Ranks'

    # try( remove_scoreboard(@scoreboard) )

    # @ListManager = array()
    # @ListOwner = array()
    # @ListUberAdmin = array()
    # @ListAdmin = array()
    # @ListVeteran = array()
    # @ListVIP = array()
    # @ListBuilder = array()
    # @ListTrusted = array()
    # @ListPlayer = array()
    # foreach(all_players(), @pl,
        # if(has_permission(@pl, 'rank.manager')) {
            # array_push(@ListManager, @pl)
            # continue()
        # }
        # if(has_permission(@pl, 'rank.owner')) {
            # array_push(@ListOwner, @pl)
            # continue()
        # }
        # if(has_permission(@pl, 'rank.uberadmin')) {
            # array_push(@ListUberAdmin, @pl)
            # continue()
        # }
        # if(has_permission(@pl, 'rank.admin')) {
            # array_push(@ListAdmin, @pl)
            # continue()
        # }
        # if(has_permission(@pl, 'rank.veteran')) {
            # array_push(@ListVeteran, @pl)
            # continue()
        # }
        # if(has_permission(@pl, 'rank.vip')) {
            # array_push(@ListVIP, @pl)
            # continue()
        # }
        # if(has_permission(@pl, 'rank.builder')) {
            # array_push(@ListBuilder, @pl)
            # continue()
        # }
        # if(has_permission(@pl, 'rank.trusted')) {
            # array_push(@ListTrusted, @pl)
            # continue()
        # }
        # if(has_permission(@pl, 'rank.player')) {
            # array_push(@ListPlayer, @pl)
            # continue()
        # }

    # )
    # @List = array(@ListPlayer, @ListTrusted, @ListBuilder, @ListVIP, @ListVeteran, @ListAdmin, @ListUberAdmin, @ListOwner, @ListManager)

    # foreach(all_players(), @player,

        # @ranks = array(array('Player', array('prefix': colorize('&7'))),
                        # array('Trusted', array('prefix': colorize('&f'))),
                        # array('Builder', array('prefix': colorize('&6'))),
                        # array('VIP', array('prefix': colorize('&c'))),
                        # array('Veteran', array('prefix': colorize('&e'))),
                        # array('Admin', array('prefix': colorize('&4'))),
                        # array('UberAdmin', array('prefix': colorize('&5'))),
                        # array('Owner', array('prefix': colorize('&5'))),
                        # array('Manager', array('prefix': colorize('    &7&l>> &5&l'), 'suffix': colorize(' &7&l<<')))
                    # )

		# try(create_scoreboard(@scoreboard)) #create scoreboard
        # try(create_objective('Ranks', 'DUMMY', @scoreboard))

        # set_pscoreboard(@player, @scoreboard)

        # for(@i = 0, @i <= array_size(@ranks) - 1, @i++,
            # try( create_team(@ranks[@i][0], @scoreboard) )
            # set_team_display(@ranks[@i][0], @ranks[@i][1], @scoreboard)
            # foreach(@List[@i], @player,
                # team_add_player(@ranks[@i][0], @player, @scoreboard)
            # )
        # )
	# )
# )

proc(_colorNames, @names = all_players(),
    if(@player == 'the_immortal') { return() }

    @scoreboard = 'main'
    try(create_scoreboard(@scoreboard))
    try(create_objective('Ranks', 'DUMMY', @scoreboard))

    @ranks = array( array('Manager', array('prefix': colorize('&5[Manager] '), 'suffix': colorize('&r'))),
                    array('Owner', array('prefix': colorize('&5[Owner] '), 'suffix': colorize('&r'))),
                    array('UberAdmin', array('prefix': colorize('&5[Uber] '), 'suffix': colorize('&r'))),
                    array('Admin', array('prefix': colorize('&4[Admin] '), 'suffix': colorize('&r'))),
                    array('Veteran', array('prefix': colorize('&e[Veteran] '), 'suffix': colorize('&r'))),
                    array('VIP', array('prefix': colorize('&c[VIP] '), 'suffix': colorize('&r'))),
                    array('UberBuilder', array('prefix': colorize('&3[Builder] '), 'suffix': colorize('&r'))),
                    array('Builder', array('prefix': colorize('&6[Builder] '), 'suffix': colorize('&r'))),
                    array('Trusted', array('prefix': colorize('&f'), 'suffix': colorize('&r'))),
                    array('Player', array('prefix': colorize('&7'), 'suffix': colorize('&r'))),
                )
    if(!is_array(@names)) { @names = array(@names) }
    foreach(@rank in @ranks) {
        try( create_team(@rank[0], @scoreboard) )
        set_team_display(@rank[0], @rank[1], @scoreboard)
    }


    foreach(@player in @names) {
        if(@player == 'Plancke') { team_add_player('Manager', @player, @scoreboard); continue() }
        if(@player == 'tatara88') { team_add_player('Owner', @player, @scoreboard); continue() }


        foreach(@rank in @ranks) {
            if(@rank[0] == 'Manager' || @rank[0] == 'Owner') { continue() }
            if(!has_permission(@player, 'rank.'.to_lower(@rank[0]))) { continue() }
            team_add_player(@rank[0], @player, @scoreboard)
            break();
        }
    }
)


bind('player_join', null, null, @event,
    _colorNames(@event['player'])
)
