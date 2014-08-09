proc('_store_timed', @name, @value, @timeout=1000,
  export(''.@name, @value)
  set_timeout(@timeout, closure(
    export(''.@name, null)
  ))
)
