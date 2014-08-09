proc(_storeInfo, @player, @stat, @value,
    @table = 'commandhelper_players'
    
    # if(_isNew(@table, 'name', @player)) { _newSQLPlayer(@player) }
    @condition = '`name`=\''.@player.'\''
    if(!is_array(@stat)) { @stat = array(@stat) }
    if(!is_array(@value)) { @value = array(@value) }
    query('CommandHelper', _update(@table, @stat, @value, @condition))

    export('info.'.@player, null)
)

proc(_getInfo, @player,
    if(import('info.'.@player) != null) { return(import('info.'.@player)) }

    @table = 'commandhelper_players'
    if(_isNew(@table, 'name', @player)) {
        _newSQLPlayer(@player)
        @result = _getInfo(@player)
    } else {
        @result = query('CommandHelper', _select(@table, '*', '`name`=\''.@player.'\''))
    }
    export('info.'.@player, @result)
    return(@result)
)

proc(_isNew, @table, @column, @value,
    @result = query('CommandHelper', _select(@table, 'COUNT(`name`) AS amount', '`'.@column.'`=\''.@value.'\''))[0]
    if(@result['amount'] > 0) { return(false) }
    return(true)
)

proc(_newSQLPlayer, @player,
    @table = 'commandhelper_players'
    console('Adding new player')
    query('CommandHelper', _insert(@table, array('name'), array(array(@player))))
)

proc(_storeRanks, @player,
    @users = import('config.pex')['users']
    try(@userranks = @users[@player]['group'], @ex, @userranks = array('player'))
    @table = 'commandhelper_playerranks'
    @columns = array('name','rank')
    query_async('CommandHelper', _delete(@table, '`name`=\''.@player.'\''), closure())
    @rankarray = array()
    
    #LFK AND FONTN FIX
    @fix = array('LonelyFatKid', 'Fontn')
    if(array_contains(@fix, @player)) { return(query_async('CommandHelper', _insert(@table, @columns, array(array(@player, 'uberadmin'))), closure())) }
    #FIX
    
    foreach(@userranks, @rank) {
        array_push(@rankarray, array(@player, @rank))
    }
    return(query_async('CommandHelper', _insert(@table, @columns, @rankarray), closure()))
)

proc(_storeRankInfo,
    @ranks = import('config.pex')['groups']
    @columns = array('rank', 'realname', 'prefix', 'weight')
    @table = 'commandhelper_ranks'
    
    query_async('CommandHelper', _delete(@table), closure())
    
    @vals = array()
    foreach(array_keys(@ranks), @rank) {
        array_push(@vals, array(@rank, @ranks[@rank]['options']['realname'], @ranks[@rank]['options']['prefix'], @ranks[@rank]['options']['weight']))
    }
    @result = query_async('CommandHelper', _insert(@table, @columns, @vals), closure())
)