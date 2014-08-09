proc(_admin_hasperm, @player,
    if(has_permission('rank.admin')) { return() }
    if(has_permission('rank.veteran') && (length(_admins('on')) == 0)) { return() }    
    die(_noperms())
)
