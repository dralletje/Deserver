proc(_grouplimit, @player,
  @default = 5000
  @limits = array(
        'manager': '-1',
        'owner': '250000',
        'uberadmin': '100000',
        'admin': '25000',
        'builder': '15000',
        'vip': '15000',
        'veteran': '10000',
        'trusted': '5000',
  )
  
  @retlimit = @default
  
  @specials = array('Dabaan': 20000, 'milese3': 100000)
  if(array_contains(array_keys(@specials), @player)) { 
    if(@retlimit < @specials[@player]) {
      return(@specials[@player])
    }
  }
  
  foreach(@rank:@limit in @limits) { 
    if(!has_permission(@player, 'rank.'.@rank)){ continue() }
    if(@limit == '-1') { return('-1') }
    if(@retlimit < @limit) {
      @retlimit = @limit
    }
  }
  
  return(@retlimit)
)

bind('world_changed', array('priority': 'high'), null, @event,    
    if(_inCreative(@event['player'])) { sudo('//limit '._grouplimit(@event['player'])) }
)