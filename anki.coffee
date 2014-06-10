window.$ = (s) ->
  if s[0] == "#"
    document.getElementById(s.substring(1))
  else if s[0] == "."
    document.getElementsByClassName(s.substring(1))
  else
    document.getElementsByTagName(s)

if $('#answer') == null
  word = words[Math.floor(Math.random() * words.length)]

for elem in $('.replace')
  try
    want = elem.innerHTML
    elem.innerHTML = word.conjugate(want)
  catch error
    elem.innerHTML = ""
