proc( '_spawn_hologram', @lines, @location = null, @alignment = 0.3 ){
	if( is_null( @location )) {
		if ( ponline( player() )){
			@location	= ploc()
		}else{
			return( false )
		}
	}
	@location	= _location_standardize( @location )
	#array_reverse( @lines )
	@idRaw		= null
	@server		= reg_replace( '[^a-zA-Z0-9_]', '', get_server_info()[0] )
	@holograms	= get_value( @server. '.holograms' )
	if( !is_array( @holograms )){
		@holograms	= array()
	}
	for( @i	= 0, @i < array_size( @holograms ), @i++ ){
		if( !array_index_exists( @holograms, @i. '_id' )){
			@idRaw	= @i
			break()
		}
	}
	if( is_null( @idRaw )){
		@idRaw	= array_size( @holograms )
	}
	@id						            = @idRaw. '_id'
	@newLoc					        	= array()
	@holograms[@id]			  		    = array()
	@holograms[@id]['id']				= @idRaw
	@holograms[@id]['entities']			= array()
	@holograms[@id]['location']			= array()
	@holograms[@id]['alignment']			= @alignment
	foreach( array_keys( @location ), @key ){
		@holograms[@id]['location'][@key]	= @location[@key]
		@newLoc[@key]				= @location[@key]
	}
	@newLoc['y']	+= 57
	foreach( @line in @lines ){
		@skull	= spawn_entity( 'WITHER_SKULL', 1, @newLoc )[0]
		@horse	= spawn_mob( 'HORSE', 1, @newLoc )[0]
		if( entity_exists( @skull ) && entity_exists( @horse )){
			set_entity_persistence( @horse, true )
			set_entity_rider( @skull, @horse )
			set_entity_spec( @skull, array( 'direction': array( 0, 0, 0 )))
			set_mob_age( @horse, -1700000, true )
			set_name_visible( @horse, true )
			set_mob_name( @horse, _colorize( @line ))
			@newLoc['y']	+= @alignment
			array_push( @holograms[@id]['entities'], entity_uuid( @skull ))
			array_push( @holograms[@id]['entities'], entity_uuid( @horse ))
		}else{
			if( entity_exists( @skull )){
				entity_remove( @horse )
			}else{
				entity_remove( @skull )
			}
			foreach( @holograms[@id]['entities'], @uuid ){
				@entity	= entity_id( @uuid )
				entity_remove( @entity )
			}
			return( false )
		}
	}
	store_value( @server. '.holograms', @holograms )
	return( @idRaw )
}

proc( '_remove_hologram', @id ){
	@id 		.= '_id'
	@server		= reg_replace( '[^a-zA-Z0-9_]', '', get_server_info()[0] )
	@holograms	= get_value( @server. '.holograms' )
	if( !is_array( @holograms )
	||  !array_index_exists( @holograms , @id )){
		return( false )
	}
	get_block_at( @holograms[@id]['location'] )
	foreach( @holograms[@id]['entities'], @uuid ){
		@entity	= entity_id( @uuid )
		entity_remove( @entity )
		array_remove( @holograms, @id )
		store_value( @server. '.holograms', @holograms )
	}
	return( true )
}

proc( '_holograms_in_radius', @location, @distance ){
	@location	= _location_standardize( @location )
	@server		= reg_replace( '[^a-zA-Z0-9_]', '', get_server_info()[0] )
	@holograms	= get_value( @server. '.holograms' )
	@ids		= array()
	if( is_array( @holograms )){
		foreach( array_keys( @holograms ), @id ){
			if( _3d_distance( @location, @holograms[@id]['location'] ) <= @distance ){
				array_push( @ids, @holograms[@id]['id'] )
			}
		}
		return( @ids )
	}else{
		return( array() )
	}
}

proc( '_all_holograms' ){
	@server		= reg_replace( '[^a-zA-Z0-9_]', '', get_server_info()[0] )
	@holograms	= get_value( @server. '.holograms' )
	@ids		= array()
	if( is_array( @holograms )){
		foreach( array_keys( @holograms ), @id ){
			array_push( @ids, @holograms[@id]['id'] )
		}
	return( @ids )
	}else{
		return( array() )
	}
}

proc( '_hologram_exists', @id ){
	@server		= reg_replace( '[^a-zA-Z0-9_]', '', get_server_info()[0] )
	@holograms	= get_value( @server. '.holograms' )
	if( is_array( @holograms ) && array_index_exists( @holograms, @id. '_id' )){
		return( true )
	}else{
		return( false )
	}
}

proc( '_get_hologram_loc', @id ){
	@id		    = @id. '_id'
	@server		= reg_replace( '[^a-zA-Z0-9_]', '', get_server_info()[0] )
	@holograms	= get_value( @server. '.holograms' )
	if( is_array( @holograms ) && array_index_exists( @holograms, @id )){
		return( @holograms[@id]['location'] )
	}
}

proc( '_set_hologram_loc', @id, @location = null ){
	if( is_null( @location )) {
		if ( ponline( player() )){
			@location	= ploc()
		}else{
			return( false )
		}
	}
	@location	= _location_standardize( @location )
	@idraw		= @id
	@id		    = @id. '_id'
	@lines		= array()
	@server		= reg_replace( '[^a-zA-Z0-9_]', '', get_server_info()[0] )
	@holograms	= get_value( @server. '.holograms' )
	if( is_array( @holograms ) && array_index_exists( @holograms, @id )){
		get_block_at( @location )
		foreach( @uuid in @holograms[@id]['entities'] ){
			@entity	= entity_id( @uuid )
			if( is_entity_living( @entity )){
				array_push( @lines, get_mob_name( @entity ))
			}
		}
		#array_reverse( @lines )
		if( _remove_hologram( @idraw )){
			if( _spawn_hologram( @lines, @location, @holograms[@id]['alignment'] ) != false ){
				return( true )
			}else{
				return( false )
			}
		}else{
			return( false )
		}
	}else{
		return( false )
	}
}

proc( '_get_hologram_text', @id ){
	@id			= @id. '_id'
	@lines		= array()
	@server		= reg_replace( '[^a-zA-Z0-9_]', '', get_server_info()[0] )
	@holograms	= get_value( @server. '.holograms' )
	if( is_array( @holograms ) && array_index_exists( @holograms, @id )){
		get_block_at( @holograms[@id]['location'] )
		foreach( @uuid in @holograms[@id]['entities'] ){
			@entity	= entity_id( @uuid )
			if( is_entity_living( @entity )){
				array_push( @lines, get_mob_name( @entity ))
			}
		}
		#array_reverse( @lines )
		return( @lines )
	}else{
		return( false )
	}
}

proc( '_set_hologram_text', @id, @textArray ){
	@idraw			= @id
	@id		    	= @id. '_id'
	@lines			= array()
	@server			= reg_replace( '[^a-zA-Z0-9_]', '', get_server_info()[0] )
	@holograms		= get_value( @server. '.holograms' )
	if( is_array( @holograms ) && array_index_exists( @holograms, @id )){
		@location	= @holograms[@id]['location']
		_remove_hologram( @idraw )
		if( _spawn_hologram( @textArray, @location, @holograms[@id]['alignment'] ) != false ){
			return( true )
		}else{
			return( false )
		}
	}else{
		return( false )
	}
}
