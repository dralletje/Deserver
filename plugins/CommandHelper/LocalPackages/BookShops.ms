bind(player_interact, null, array(block: 68), @event,  # Wall Sign
    @signtext = get_sign_text(@event[location])
    
    if(pmode() == 'CREATIVE') { die() }
    
    if(@signtext[0] == 'Plancke' && substr(@signtext[1], 0, 1) == 'B') {
        @price = substr(@signtext[1], 2)
        @amount = @signtext[2]
        if(@signtext[3] == 'Your Head') { @itemname = @signtext[3] } else { @itemname = substr(@signtext[3], 0, length(@signtext[3]) - 5) }
        
        @money = integer(acc_balance(player()))
        
        if(@money >= @price) {
            
            @items = array('Eff 5': array('Efficiency V', DIG_SPEED, 5), 
                            'Unbr 3': array('Unbreaking III', DURABILITY, 3), 
                            'Fire 2': array('Fire Aspect II', FIRE_ASPECT, 2),
                            'Knock 2': array('Knockback II', KNOCKBACK, 2),
                            'Fort 3': array('Fortune III', LOOT_BONUS_BLOCKS, 3),
                            'Sharp 5': array('Sharpness V', DAMAGE_ALL, 5),
                            'Loot 3': array('Looting III', LOOT_BONUS_MOBS, 3),
                            'Prot 4': array('Protection IV', PROTECTION_ENVIRONMENTAL, 4),
                            'Thorns 3': array('Thorns III', THORNS, 3),
                            'Silk 1': array('Silk Touch I', SILK_TOUCH, 1),
                            'Your Head': 'lol'
                    )
            @colors = array(2,3,4,5,6,9,a,b,c,d,e,f)
            foreach(array_keys(@items), @itemkey,
                if(@itemname != @itemkey) { continue() } 
                
                @item = @items[@itemkey]
                acc_subtract(player(), @price)
                @color = @colors[rand(0,array_size(@colors))]
                
                if(@itemkey == 'Your Head') {
                    pgive_item(player(), '397:3', @amount, array(owner: player()))
                    msg(_tagmsg('Shop', 'Thank you for buying your head!'))
                } else {
                    pgive_item(player(), 403, @amount, array(display: color(r).color(@color).@item[0].' Book', 
                                                            lore: array(color(7).@price.' Rupees'),
                                                            repair: 0, 
                                                            stored: array(array(etype: @item[1], 
                                                                                elevel: @item[2]))
                                                            )
                    )
                    msg(_tagmsg('Shop', 'Thank you for buying a '.@item[0].' book'))
                }
                set_pinv(pinv())
                die()
            )
        }
    }
) 
bind(sign_changed, null, null, @event,
    try(
    assign(@signtext, @event[text])
    if(@signtext[0] == 'Plancke') {
        if(substr(@signtext[1], 0, 1) == 'B') {
            if(!has_permission('rank.uberadmin')) { 
                msg(_tagmsg('Shop', 'You do not have the permission to create a sign'))
                cancel() 
            }
        }
    }
    )
) 