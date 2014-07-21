
commands = window.commands =
  login: (data, res)->

    return res {error: "undefine email or password"} unless data.email? and data.password?
    
    nicolive.requestLogin data.email, data.password, (ret)->
      console.log ret
      res false
    
