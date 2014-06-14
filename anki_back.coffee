elem = document.getElementById('replace-back')
try
  want = elem.innerHTML
  elem.innerHTML = word.conjugate(want)
catch error
  elem.innerHTML = ""
