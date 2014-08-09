bind('entity_death', null, null, @event) {
  try(
      @killer = @event['cause']

      try( if(array_contains(all_players(), @killer['shooter'])) { @player = @killer['shooter'] } )
      try( if(array_contains(all_players(), @killer['damager'])) { @player = @killer['damager'] } )
      if(@player == null){ die() }
      
      if(_inCreative(@player)) { die() }
     
      @mobs = array('default': array('value':5, 'name': 'Mob'),
            'creeper': array('value':25, 'name': 'Creeper'),
            'spider': array('value':20, 'name': 'Spider'),
            'zombie': array('value':20, 'name': 'Zombie'),
            'cave_spider': array('value':25, 'name': 'CaveSpider'),
            'sheep': array('value':5, 'name': 'Sheep'),
            'snowman': array('value':1, 'name': 'Snowman'),
            'witch': array('value':45, 'name': 'Witch'),
            'blaze': array('value':65, 'name': 'Blaze'),
            'skeleton': array('value':20, 'name': 'Skeleton'),
            'bat': array('value':1, 'name': 'Bat'),
            'silverfish': array('value':15, 'name': 'SilverFish'),
            'pig_zombie': array('value':80, 'name': 'Pigman'),
            'slime': array('value':10, 'name': 'Slime'),
            'magmacube': array('value':15, 'name': 'MagmaCube'),
      )
     
      @mob = to_lower(@event['type'])
      
      @loc = @event['location']
      # make_effect(ploc(@player), 'CLICK1', 2)
        
      try( acc_add(@player, @mobs[@mob]['value']), acc_add(@player, @mobs['default']['value']) )
      # tmsg(@player, _tagmsg('Banker', 'You have been rewarded &6$'.@mobs[@mob]['value'].'&7 for killing a &6'.@mobs[@mob]['name']))
  )
}

_adminmsg('MoneyDrop Binds Loaded!')

bind('entity_death', null, null, @event) {
  try(
      @killer = @event['cause']

      try( if(array_contains(all_players(), @killer['shooter'])) { @player = @killer['shooter'] } )
      try( if(array_contains(all_players(), @killer['damager'])) { @player = @killer['damager'] } )
      if(@player == null){ die() }
      
      if(!_inWorld(pworld(@player), 'mars')) { die() }
     
      @mobs = array(
        '[Olympian]': array('value': 100000, 'name': 'OlympianBoss'),
      )
      
      try( 
        @mob = @mobs[get_mob_name(@event['id'])]
        try( acc_add(@player, @mob['value']), die(_tagmsg('Banker', 'Soemthing went wrong whilist giving money')) )
        tmsg(@player, _tagmsg('Banker', 'You have been rewarded &6$'.@mob['value'].'&7 for killing a &6'.@mob['name']))
      )
  )
}