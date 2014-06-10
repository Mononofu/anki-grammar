$ = (s) ->
  if s[0] == "#"
    document.getElementById(s.substring(1))
  else if s[0] == "."
    document.getElementsByClassName(s.substring(1))
  else
    document.getElementsByTagName(s)

window.random = ->
  location.hash = ""
  location.reload()

window.conjugate = ->
  location.hash = $('#query').value
  location.reload()
  return false

word = words[Math.floor(Math.random(words.length) * words.length)]
if location.hash != ""
  query = location.hash[1...]
  $('#query').value = query
  candidates = (w for w in words when w.plain() == query or w.reading() == query)
  if candidates.length > 0
    word = candidates[0]
  else
    word = classify(query, query, "n/a")

for elem in $('.replace')
  try
    want = elem.innerHTML
    w = word
    for conj in want.split(' ')
      w = w[conj]()
    elem.innerHTML = w
  catch error
    elem.innerHTML = ""


