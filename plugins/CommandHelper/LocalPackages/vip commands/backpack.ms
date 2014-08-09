bind('virtualchest_closed', null, null, @event,
    @id = @event['chest']['id']
    @chest = get_virtualchest(@id)
    store_value(@id, @chest)
)