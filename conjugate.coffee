class Word
  constructor: (@_plain, @_reading, @_meaning) ->
  plain: -> @_plain
  pastNegative: -> @negative().replace(/い$/, "かった")
  teNegative: -> @negative().replace(/い$/, "くて")

class Verb extends Word
  polite: -> @stem() + "ます"
  politeNegative: -> @stem() + "ません"
  politePast: -> @stem() + "ました"
  politePastNegative: -> @stem() + "ませんでした"
  te: -> @past().replace(/た$/, "て").replace(/だ$/, "で")

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

class Suru extends Verb
  constructor: -> @_plain = "する"
  stem: -> "し"
  negative: -> "しない"
  past: -> "した"

class Kuru extends Verb
  constructor: -> @_plain = "くる"
  stem: -> "き"
  negative: -> "こない"
  past: -> "きた"

class Adjective extends Word
  polite: -> @_plain + "です"
  politeNegative: -> @negative() + "です"
  politePast: -> @past() + "です"
  politePastNegative: -> @pastNegative() + "です"

class IAdjective extends Adjective
  adverb: -> @_plain.replace(/い$/, "く")
  negative: -> @_plain.replace(/い$/, "くない")
  past: -> @_plain.replace(/い$/, "かった")
  te: -> @_plain.replace(/い$/, "くて")

class II extends IAdjective
  constructor: -> @_plain = "よい"
  plain: -> "いい"

class NaAdjective extends Adjective
  adverb: -> @_plain + "に"
  negative: -> @_plain + "じゃない"
  past: -> @_plain + "だった"
  politePast: -> @_plain + "でした"
  te: -> @_plain + "で"

verbs = [
  {plain: "見る", reading: "みる", meaning: "to see"}
  {plain: "食べる", reading: "たべる", meaning: "to eat"}
  {plain: "寝る", reading: "ねる", meaning: "to sleep"}
  {plain: "起きる", reading: "おきる", meaning: "to wake up"}
  {plain: "考える", reading: "かんがえる", meaning: "to think"}
  {plain: "教える", reading: "おしえる", meaning: "to teach"}
  {plain: "出る", reading: "でる", meaning: "to exit"}
  {plain: "着る", reading: "きる", meaning: "to wear"}
  {plain: "居る", reading: "いる", meaning: "to be (animate)"}
  {plain: "在る", reading: "ある", meaning: "to be (inanimate)"}
  {plain: "話す", reading: "はなす", meaning: "to talk"}
  {plain: "聞く", reading: "きく", meaning: "to hear"}
  {plain: "泳ぐ", reading: "およぐ", meaning: "to swim"}
  {plain: "遊ぶ", reading: "あそぶ", meaning: "to play"}
  {plain: "待つ", reading: "まつ", meaning: "to wait"}
  {plain: "飲む", reading: "のむ", meaning: "to drink"}
  {plain: "買う", reading: "かう", meaning: "to buy"}
  {plain: "帰る", reading: "かえる", meaning: "to return"}
  {plain: "死ぬ", reading: "しぬ", meaning: "to die"}
  {plain: "為る", reading: "する", meaning: "to do"}
  {plain: "来る", reading: "くる", meaning: "to come"}
]

adjectives = [
  {plain: "良い", reading: "いい", meaning: "good"}
]

classify = (plain, reading, meaning) -> switch reading
  when "する" then new Suru()
  when "くる" then new Kuru()
  when "いい" then new II()
  else switch reading.slice(-1)
    # Words ending in u-sound that is not る are u-verbs.
    when "う", "つ", "む", "ぶ", "ぬ", "す", "く", "ぐ" then new UVerb(plain, reading, meaning)
    # If they end in る, it depends on the sound preceding the る.
    # The exceptions to this rule depend on the kanji for the word, e.g. 居る and 要る are both read
    # いる, but the former is a ru-verb and the letter a u-verb.
    when "る" then switch plain
      when "要る", "帰る", "切る", "喋る", "知る", "入る", "走る", "減る", "焦る", "限る", "蹴る"
         , "滑る", "握る", "練る", "参る", "交じる", "混じる", "嘲る", "覆る", "遮る", "罵る", "捻る"
         , "翻る", "滅入る", "蘇る" then new UVerb(plain, reading, meaning)
      else switch reading.slice(-2, -1)
        # For i- and e- sounds, it's a ru-verb, except for the exceptions above.'
        when "り", "み", "ひ", "に", "ち", "し", "き", "い"
           , "れ", "め", "へ", "ね", "て", "せ", "け", "え"
           , "ぴ", "び", "ぢ", "じ", "ぎ"
           , "ぺ", "べ", "で", "ぜ", "げ" then new RuVerb(plain, reading, meaning)
        # For a-, u- and o-sounds (= everything else), it's a u-verb.
        else new UVerb(plain, reading, meaning)

words = (classify(w.plain, w.reading, w.meaning) for w in verbs.concat(adjectives))

$ = (s) ->
  if s[0] == "#"
    document.getElementById(s.substring(1))
  else if s[0] == "."
    document.getElementsByClassName(s.substring(1))
  else
    document.getElementsByTagName(s)

word = words[Math.floor(Math.random(words.length) * words.length)]
$('#front').innerHTML = word.plain()
$('#back').innerHTML = word.politePastNegative()
