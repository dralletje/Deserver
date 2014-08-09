proc('_get_player_info', @player,
    @info = import("player.info.@player")
    if(@info != null) { return(@info) }
    
    if(ponline(@player)) {
        @uuid = entity_uuid(pinfo(@player, 13))
    } else {
        @uuid = entity_uuid(pinfo(@player, 13))
    }
    
    @query = 'SELECT players.* FROM players INNER JOIN uuid_playerid ON players.player_id = uuid_playerid.player_id WHERE uuid_playerid.uuid=? LIMIT 1'
    @result = query('CommandHelper', @query, @uuid)
    
    if(@result == array()) {
        #Player is new
        console("@player is new, registering now!")
        @query = 'INSERT INTO players(username, status, login_count, online_time, timestamp) VALUES(?, ?, ?, ?, NOW())'
        @id = query('CommandHelper', @query,  pinfo(@player, 0), 'Online', 0, 0)
        @query = 'INSERT INTO uuid_playerid(uuid, player_id) VALUES(?, ?)'
        query('CommandHelper', @query, @uuid, @id)
        @result = _get_player_info(@player)
    }
    
    try( @result = @result[0] )
    
    export("player.info.@player", @result)
    return(@result)
)

proc('_get_world_info', @world,
    @info = import('world.info.'.@world)
    if(@info != null) { return(@info) }
    
    @query = query('CommandHelper', 'SELECT a.server_id, a.name, a.nick, a.color, a.closed, a.time, IFNULL(b.name, a.name) AS parent FROM `worlds` AS a LEFT OUTER JOIN `worlds` AS b ON a.parent = b.world_id')[0]
    export('worlds', @query)
)

proc('_get_player_home', @player, @home='%',
    @homes = import("player.homes.@player")
    if(@homes != null) { return(@homes) }
    
    @query = 'SELECT * FROM homes WHERE player_id=? AND name LIKE ?'
    @id = _get_player_info(@player)['player_id']
    
    @result = query('CommandHelper', @query, @id, @home.'%')
    
    try( @result = @result[0] )
    
    export("player.homes.@world", @result)
    return(@result)
)

proc('_set_player_home', @player, @home, @loc,

)