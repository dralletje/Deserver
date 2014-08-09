bind('entity_damage', null, null, @event,
  try(
    @damager = @event['damager']
    @damager = player(@damager)
    @id = @event['id']
  , @ex, die() )
  
  try(
    @item = pinv(@damager, null)    
    @lore = @item['meta']['lore']
    if(@lore == null) { die() }
    
    @effects = array('POISON': array(19, 2, 2),
                     'FIRE': array('FIRE', 1, 1), 
                     'LIGHTNING': array('LIGHTNING', 5),
                     'WITHER': array(20, 1, 1), 
                     'HUNGER': array(17, 1, 5)
               )
               
    foreach(@loreline in @lore) {
        foreach(array_keys(@effects), @effect) {
            if(string_position(@display, @effect) != -1) {
                @e = @effects[@effect]
                if(@e[0] == 'FIRE') { set_entity_onfire(@id, 2) \ continue() } #Fire isn't a status effect
                if(@e[0] == 'LIGHTNING') { for(@i = 0, @i < @e[1], @i++) { lightning(entity_loc(@id)) \ continue() }}
                set_mob_effect(@id, @e[0], @e[1], @e[2], false)
            }
        }
    }
    
  ,@ex, die() )
)