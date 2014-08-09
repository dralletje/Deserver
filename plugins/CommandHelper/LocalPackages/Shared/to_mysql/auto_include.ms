proc('_uuid', @players, @callback,
  if(typeof(@players) != 'array') {
    @players = array(@players)
  }

  @result = array()
  @notyet = array()
  foreach(@player in @players) {
    try(
      @uuid = entity_uuid(pinfo(@pl, 13))
      broadcast(@player)
      array_push(@result, array(
        name: @player,
        uuid: @uuid
      ))
    , @ex,
      @notyet[] = @player
    )
  }

  @url = 'https://api.mojang.com/profiles/minecraft'
  http_request(@url, array(
    method: 'POST',
    headers: array(
      'Content-Type': 'application/json'
    ),
    params: json_encode(@notyet),
    success: closure(@response) {
      @body = json_decode(@response['body'])
      broadcast(@body)
      @result = array_merge(@body, @result)
      execute(@result, @callback)
    }
  ))
)

proc('_hellyeah',
  @query = 'SELECT a.world_id, a.server_id, a.name, a.nick, a.color, a.closed, a.time, IFNULL(b.name, a.name) AS parent
FROM `worlds` AS a LEFT OUTER JOIN `worlds` AS b ON a.parent = b.world_id'
  @array = _array_map(query('CommandHelper',@query), closure(@val) {
    return(@val['parent'])
  })
  broadcast(@array)
)

# Move this somewhere else!!
proc('_array_map', @array, @closure,
  @newarray = array()
  foreach(@key:@value in @array) {
    @newarray[@key] = execute(@value, @key, @array, @closure)
  }
  return(@newarray)
)
proc('_array_map_async', @array, @fn, @callback,
  @newarray = array()

  @counter = array(length(@array))
  foreach(@key:@value in @array) {
    execute(closure(@val) {
      @newarray[@key] = @val
      @counter[0] = @counter[0] - 1
      if(@counter[0] == 0) {
        execute(@newarray, @callback)
      }
    }, @value, @key, @array, @fn)
  }
)

proc('_player_set_uuid', @players, @callback,
  if(typeof(@players) != 'array') {
    @players = array(@players)
  }

  _uuid(@players, closure(@body) {
    @query = 'SELECT * FROM uuid_playerid WHERE uuid=\'%s\''
    _array_map_async(@body, closure(@cb, @pl) {
      query_async('CommandHelper', sprintf(@query, @pl['id']), closure(@value) {
        @res = array_get(@value, 0, array('uuid': null))
        broadcast(@res)
        execute(@res['uuid'], @cb)
      })
    }, closure(@result) {
      broadcast(@result)
    })
    return()

    @query = 'INSERT INTO uuid_playerid (uuid) VALUES (\'%s\')'
    _array_map_async(@body, closure(@cb, @player){
      @thing = sprintf(@query, @player['id'])
      query_async('CommandHelper', @thing, @cb)
    }, closure(@result) {
      broadcast(@result)
    })
  })
)
