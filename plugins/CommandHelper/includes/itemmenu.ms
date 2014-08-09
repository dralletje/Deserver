proc(_itemmenu_create, @array,
    
      # /command = >>>
      # include('/includes/itemmenu.ms') # Depends on where your file is located (the command file)

      # @array = array(title:'Title', id:'MenuID', menu: array(array( array(type: 'Item1ID', meta: array(display: 'Display', lore: 'Lore')), closure('/command')),
                                                             # array(array(type: 'Item2ID', meta: array(display: 'Display', lore: 'Multiline\nLore')), closure('/command')),
                                                             # array(array(type: 'Item3ID', meta: array(display: 'Display', lore: 'Lore')), closure('/command')),
                                                             # array(array(type: 'Item4ID', meta: array(display: 'Display', lore: 'Lore')), closure('/command')),
                                                             # 'Empty',
                                                             # 'RandomStringToSkipSlot',
                                                             # array(array(type: 'Item5ID', meta: array(display: 'Display', lore: 'Lore')), closure('/command')),
                                                             # array(array(type: 'Item6ID', meta: array(display: 'Display', lore: 'Lore')), closure('/command')),
                                                             # 'SpecialItem'
                                                       # ))

      # _itemmenu_create(@array)
    # <<<

    export('MenuOpen'.player(), true)
    export('CurMenu'.player(), @array)
    
    @title = @array['title']
    @id = @array['id']
    @size = ceil((array_size(@array['menu'])) / 9) * 9 # Dynamically set the size
    @chest = array(id: @id, size: @size, title: @title)
    @items = @array['menu']
    
    foreach(@loc:@item in @items) {
        if(!is_array(@items[@loc])) { 
            if(@items[@loc] == 'MoneyItem') { 
                @rawmoney = _split_in_groups(integer(acc_balance(player())), 3)
                @money = array_implode(@rawmoney, ',').' &7Rupees'
                @item = array(type: 266, meta: array(display: colorize('&7Current Money: &6'.@money), lore: array(colorize('&7This is the amount of money you have at the moment'), colorize('&7VIP receives &620% &7more money per mob kill'), colorize('&6&odeserver.buycraft.net'))))
                array_set(@chest, @size - 1, @item)
            }
            continue() # Any non array gets skipped so just add a random string to skip a slot
        }
        array_set(@items[@loc][0]['meta'], 'lore', split('\n', @items[@loc][0]['meta']['lore']))
        # Split lore on newlines
        
        array_set(@chest, @loc, @items[@loc][0])
    }
    
    create_virtualchest(@chest)
    popen_virtualchest(@id)
)

bind('virtualchest_closed', null, null, @event,
    @array = import('CurMenu'.player())
    export('MenuOpen'.player(), false) # Itemmenu is closed
)

bind('inventory_click', null, null, @event,
    @array = import('CurMenu'.player()) # Import Menu Array
    if(@array == null) { 
        die() 
    }
    if(import('MenuOpen'.player())) { # Itemmenu is Open
        cancel() # Cancel Click
        @number = @event['rawslot']
        try( execute(@array['menu'][@number][1]) ) # Execute closure, with try() in case you have an empty slot 
                                                   # or click an item out of your normal inventory
    }
)
