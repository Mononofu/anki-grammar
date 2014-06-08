class Word
  constructor: (@_plain) ->
  plain: -> @_plain
  pastNegative: -> @negative().replace(/い$/, "かった")

class Verb extends Word
  polite: -> @stem() + "ます"
  politeNegative: -> @stem() + "ません"
  politePast: -> @stem() + "ました"
  politePastNegative: -> @stem() + "ませんでした"

class RuVerb extends Verb
  stem: -> @_plain.replace(/る$/, "")
  negative: -> @stem() + "ない" # Drop る and add ない.
  past: -> @stem() + "た" # Drop る and add た.

class UVerb extends Verb
  stem: -> @_plain # u-sound changes to i-sound.
    .replace(/う$/, "い")
    .replace(/る$/, "り")
    .replace(/む$/, "み")
    .replace(/ぶ$/, "び")
    .replace(/ぬ$/, "に")
    .replace(/つ$/, "ち")
    .replace(/す$/, "し")
    .replace(/く$/, "き")
    .replace(/ぐ$/, "ぎ")
  negative: ->
    switch @_plain
      when "ある" then "ない" # Exception: ある turns into ない.
    # For other words, replace u-sound with a-equivalent, add ない.
    # Except for う, that turns into わ.
      else @_plain
        .replace(/う$/, "わ")
        .replace(/る$/, "ら")
        .replace(/む$/, "ま")
        .replace(/ぶ$/, "ば")
        .replace(/ぬ$/, "な")
        .replace(/つ$/, "た")
        .replace(/す$/, "さ")
        .replace(/く$/, "か")
        .replace(/ぐ$/, "が") + "ない"
  past: ->
    switch @_plain
      when "行く" then "行った" # Exception: 行く turns into 行った.
      # For other words, replace u-sound with a-equivalent, add ない.
      # Except for う, that turns into わ.
      else @_plain
        .replace(/う$/, "った")
        .replace(/つ$/, "った")
        .replace(/る$/, "った")
        .replace(/む$/, "んだ")
        .replace(/ぶ$/, "んだ")
        .replace(/ぬ$/, "んだ")
        .replace(/す$/, "した")
        .replace(/く$/, "いた")
        .replace(/ぐ$/, "いだ")

class IAdjective extends Verb
  adverb: -> @_plain.replace(/い$/, "く")
  negative: -> @_plain.replace(/い$/, "くない")
  past: -> @_plain.replace(/い$/, "かった")

class NaAdjective extends Verb
  adverb: -> @_plain + "に"

class Suru extends Word
  constructor: -> @_plain = "する"
  stem: -> "し"
  negative: -> "しない"
  past: -> "した"

class Kuru extends Word
  constructor: -> @_plain = "くる"
  stem: -> "き"
  negative: -> "こない"
  past: -> "きた"


ruVerbs = (new RuVerb(plain) for plain in [
  "見る",
  "食べる",
  "寝る",
  "起きる",
  "考える",
  "教える",
  "出る",
  "着る",
  "いる",
])

uVerbs = (new UVerb(plain) for plain in [
  "ある",
  "話す",
  "聞く",
  "泳ぐ",
  "遊ぶ",
  "待つ",
  "飲む",
  "買う",
  "帰る",
  "死ぬ",
])

exceptions = [new Suru(), new Kuru()]

$ = (s) ->
  if s[0] == "#"
    document.getElementById(s.substring(1))
  else if s[0] == "."
    document.getElementsByClassName(s.substring(1))
  else
    document.getElementsByTagName(s)

words = ruVerbs.concat(uVerbs).concat(exceptions)
word = words[Math.floor(Math.random(words.length) * words.length)]
$('#front').innerHTML = word.plain()
$('#back').innerHTML = word.politePastNegative()
