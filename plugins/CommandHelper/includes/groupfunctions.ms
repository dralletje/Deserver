proc(_groupcolor, @player,
  if(has_permission(@player, 'rank.uberadmin')) { 
    assign(@color, 'DARK_PURPLE')
  }
  else if(has_permission(@player, 'rank.admin')) {
    assign(@color, 'DARK_RED')
  }
  else if(has_permission(@player, 'rank.veteran')) {
    assign(@color, 'YELLOW')
  }
  else if(has_permission(@player, 'rank.vip')) {
    assign(@color, 'RED')
  }
  else if(has_permission(@player, 'rank.builder')) {
    assign(@color, 'GOLD')
  }
  else if(has_permission(@player, 'rank.trusted')) {
    assign(@color, 'WHITE')
  }
  else {
  assign(@color, 'GRAY')
  }
  return(color(@color))
)
proc(_groupname, @player,
  if(has_permission(@player, 'rank.manager')) { 
    assign(@name, 'Manager')
  }
  if(has_permission(@player, 'rank.owner')) { 
    assign(@name, 'Owner')
  }
  if(has_permission(@player, 'rank.uberadmin')) { 
    assign(@name, 'Uber Admin')
  }
  else if(has_permission(@player, 'rank.admin')) {
    assign(@name, 'Admin')
  }
  else if(has_permission(@player, 'rank.veteran')) {
    assign(@name, 'Veteran')
  }
  else if(has_permission(@player, 'rank.vip')) {
    assign(@name, 'VIP')
  }
  else if(has_permission(@player, 'rank.builder')) {
    assign(@name, 'Builder')
  }
  else if(has_permission(@player, 'rank.trusted')) {
    assign(@name, 'Trusted')
  }
  else {
  assign(@name, 'Player')
  }
  return(@name)
)