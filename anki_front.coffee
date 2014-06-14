shuffle = (xs) ->
  for i in [(xs.length-1)...0]
    j = Math.floor(Math.random() * xs.length)
    [xs[i], xs[j]] = [xs[j], xs[i]]
  return xs

if document.getElementById('answer') == null
  candidates = window.words

  type = document.getElementById('word-type')
  if type != null && type.innerHTML != ''
    candidates = (w for w in candidates when w.type().indexOf(type.innerHTML) >= 0)

  for word in shuffle(candidates)
    try
      for elem in document.getElementsByClassName('required-conjugation')
        # Test all required conjugations - if one of them throws (e.g. because it's not supported
        # by this word) we move to the next word.
        word.conjugate(elem.innerHTML)
      window.word = word
      break
    catch error
      document.getElementById('error').innerHTML = error

elem = document.getElementById('replace-front')
elem.innerHTML = window.word.conjugate(elem.innerHTML)
# Clear previous errors, since this word worked.
document.getElementById('error').innerHTML = ''
