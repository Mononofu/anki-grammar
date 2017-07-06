for elem in document.getElementsByClassName('replace')
  try
    want = elem.innerHTML
    elem.innerHTML = getByPlain(globalGet('word')).conjugate(want)
  catch error
    elem.innerHTML = ""
