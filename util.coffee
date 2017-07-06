makeKey = (name) -> 'mononofu_' + name

window.globalSet = (name, value) ->
  if typeof(py) != "undefined"
    py[makeKey(name)] = value.toString()
  else if typeof(sessionStorage) != "undefined"
    sessionStorage.setItem(makeKey(name), value.toString())
  else
    window[makeKey(name)] = value.toString()

window.globalGet = (name) ->
  if typeof(py) != "undefined"
    py[makeKey(name)]
  else if typeof(sessionStorage) != "undefined"
    sessionStorage.getItem(makeKey(name))
  else
    window[makeKey(name)]
