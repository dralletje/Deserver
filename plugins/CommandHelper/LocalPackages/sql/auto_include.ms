proc(_select, @table, @selections, @condition = null,
    @query = 'SELECT '
    if(!is_array(@selections)) {
        @query .= @selections.' '
    } else {
        @query .= '\''.array_implode(@selections, '\', \'').'\' '
    }
    @query .= 'FROM `'.@table.'` '

    if(@condition != null) { @query .= 'WHERE '.@condition }
    console('SQL: '.@query)
    return(@query)
)

proc(_insert, @table, @columns, @rows,
    @query = 'INSERT INTO `'.@table.'`(`'.array_implode(@columns, '`, `').'`) VALUES(\''

    @newrows = array()
    foreach(@rows, @vals) { 
        array_push(@newrows, array_implode(@vals, '\', \''))
    }
    @query .= array_implode(@newrows, '\'), (\'').'\')'
    console('SQL: '.@query)
    return(@query)
)

proc(_update, @table, @columns, @values, @condition = null,
    @query = 'UPDATE `'.@table.'` '.
             'SET '
    
    @sets = array()
    for(@i = 0, @i < array_size(@columns), @i++) {
        array_push(@sets, '`'.@columns[@i].'`=\''.@values[@i].'\'')
    }
    @query .= array_implode(@sets, ', ')
    if(@condition != null) { @query .= ' WHERE '.@condition }
    console('SQL: '.@query)
    return(@query)   
)

proc(_delete, @table, @condition = null,
    @query = 'DELETE FROM `'.@table.'`'
    if(@condition != null) { @query .= ' WHERE '.@condition }
    console('SQL: '.@query)
    return(@query)
)