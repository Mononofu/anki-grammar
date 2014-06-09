# The order must be equal for all vowels or replacing won't work correctly.
aSounds = ["ら", "や", "ま", "は", "な", "た", "さ", "か", "あ", "ぱ", "ば", "だ", "ざ", "が"]
iSounds = ["り", "",   "み", "ひ", "に", "ち", "し", "き", "い", "ぴ", "び", "ぢ", "じ", "ぎ"]
uSounds = ["る", "ゆ", "む", "ふ", "ぬ", "つ", "す", "く", "う", "ぷ", "ぶ", "づ", "ず", "ぐ"]
eSounds = ["れ", "",   "め", "へ", "ね", "て", "せ", "け", "え", "ぺ", "べ", "で", "ぜ", "げ"]
oSounds = ["ろ", "よ", "も", "ほ", "の", "と", "そ", "こ", "お", "ぽ", "ぼ", "ど", "ぞ", "ご"]

String.prototype.replaceLast = (from, to) ->
  s = this.toString()
  for i in [0...from.length]
    if s[-1...] == from[i]
      return s[0...-1] + to[i]
  return s

class Word
  constructor: (@_plain, @_reading, @_meaning) ->

  plain: -> @_plain
  reading: -> @_reading
  meaning: -> @_meaning

  toString: -> @plain()

class Negative extends Word
  constructor: (@_plain) ->
  plain: -> @_plain
  toString: -> @plain()
  past: -> @_plain.replace(/い$/, "かった")
  te: -> @_plain.replace(/い$/, "くて")
  conditional: -> @_plain.replace(/い$/, "ければ")
  adverb: -> @_plain.replace(/い$/, "く")

class Verb extends Word
  polite: -> new PoliteVerb(@stem())
  te: -> @past().replace(/た$/, "て").replace(/だ$/, "で")

class PoliteVerb extends Verb
  constructor: (@_plain) ->
  plain: -> @_plain + "ます"
  toString: -> @plain()
  negative: -> new PoliteVerbNegative(@_plain)
  past: -> @_plain + "ました"
  volitional: -> @_plain + "ましょう"

class PoliteVerbNegative extends PoliteVerb
  constructor: (@_plain) ->
  plain: -> @_plain + "ません"
  toString: -> @plain()
  past: -> @_plain + "ませんでした"

class RuVerb extends Verb
  type: -> "ru-verb"
  stem: -> @_plain.replace(/る$/, "")
  negative: -> new Negative(@stem() + "ない") # Drop る and add ない.
  past: -> @stem() + "た" # Drop る and add た.
  potential: -> new RuVerb(@stem() + "られる")
  volitional: -> @stem() + "よう"
  conditional: -> @_plain.replaceLast(uSounds, eSounds) + "ば"

class UVerb extends Verb
  type: -> "u-verb"
  stem: -> @_plain.replaceLast(uSounds, iSounds)
  negative: ->
    base = switch @_plain
      when "ある" then "ない" # Exception: ある turns into ない.
      # For other words, replace u-sound with a-equivalent, add ない (except for う turns into わ).
      else @_plain.replace(/う$/, "わ").replaceLast(uSounds, aSounds) + "ない"
    new Negative(base)
  past: -> switch @_plain
    when "行く" then "行った" # Exception: 行く turns into 行った.
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
  potential: -> new RuVerb(@_plain.replaceLast(uSounds, eSounds) + "る")
  volitional: -> @_plain.replaceLast(uSounds, oSounds) + "う"
  conditional: -> @_plain.replaceLast(uSounds, eSounds) + "ば"

class Suru extends Verb
  type: -> "suru-verb"
  stem: -> "し"
  negative: -> new Negative("しない")
  past: -> "した"
  potential: -> new RuVerb("できる")
  volitional: -> "しよう"

class Kuru extends Verb
  type: -> "kuru-verb"
  stem: -> "き"
  negative: -> new Negative("こない")
  past: -> "きた"
  potential: -> new RuVerb("こられる")
  volitional: -> "こよう"

class Adjective extends Word
  polite: -> new PoliteAdjective(this)
  toString: -> @plain()

class PoliteAdjective extends Adjective
  constructor: (@_plain) ->
  plain: -> @_plain + "です"
  toString: -> @plain()
  negative: -> new PoliteAdjectiveNegative(@_plain.negative())
  past: -> @_plain.past() + "です"

class PoliteAdjectiveNegative extends PoliteAdjective
  constructor: (@_plain) ->
  plain: -> @_plain + "です"
  past: -> @_plain.past() + "です"

class PoliteNaAdjective extends PoliteAdjective
  past: -> @_plain + "でした"

class IAdjective extends Adjective
  type: -> "i-adjective"
  adverb: -> @_plain.replace(/い$/, "く")
  negative: -> new Negative(@_plain.replace(/い$/, "くない"))
  past: -> @_plain.replace(/い$/, "かった")
  te: -> @_plain.replace(/い$/, "くて")
  conditional: -> @_plain.replace(/い$/, "ければ")

class II extends IAdjective
  plain: -> "いい"

class NaAdjective extends Adjective
  type: -> "na-adjective"
  adverb: -> @_plain + "に"
  negative: -> new Negative(@_plain + "じゃない")
  past: -> @_plain + "だった"
  te: -> @_plain + "で"
  conditional: -> @_plain + "であれば"

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
  {plain: "奇麗", reading: "きれい", meaning: "pretty"}
  {plain: "静か", reading: "しずか", meaning: "quiet"}
  {plain: "親切", reading: "しんせつ", meaning: "kind"}
  {plain: "好き", reading: "すき", meaning: "like"}
  {plain: "嫌い", reading: "きらい", meaning: "hate"}
  {plain: "美味しい", reading: "おいしい", meaning: "tasty"}
  {plain: "高い", reading: "たかい", meaning: "tall"}
]

classify = (plain, reading, meaning) -> switch reading
  when "する" then new Suru(plain, reading, meaning)
  when "くる" then new Kuru(plain, reading, meaning)
  when "いい" then new II(plain, reading, meaning)
  else switch plain[-1...]
    # Words ending in u-sound that is not る are u-verbs.
    when "う", "つ", "む", "ぶ", "ぬ", "す", "く", "ぐ" then new UVerb(plain, reading, meaning)
    # If they end in る, it depends on the sound preceding the る.
    # The exceptions to this rule depend on the kanji for the word, e.g. 居る and 要る are both read
    # いる, but the former is a ru-verb and the letter a u-verb.
    when "る" then switch plain
      when "要る", "帰る", "切る", "喋る", "知る", "入る", "走る", "減る", "焦る", "限る", "蹴る"
         , "滑る", "握る", "練る", "参る", "交じる", "混じる", "嘲る", "覆る", "遮る", "罵る", "捻る"
         , "翻る", "滅入る", "蘇る" then new UVerb(plain, reading, meaning)
      else
        if reading[-2...-1] in eSounds.concat(iSounds)
          # For i- and e- sounds, it's a ru-verb, except for the exceptions above.'
          new RuVerb(plain, reading, meaning)
        else # For a-, u- and o-sounds (= everything else), it's a u-verb.
          new UVerb(plain, reading, meaning)
    when "い" then switch plain
      when "嫌い", "奇麗", "綺麗", "きれい" then new NaAdjective(plain, reading, meaning)
      else new IAdjective(plain, reading, meaning)
    else new NaAdjective(plain, reading, meaning)

words = (classify(w.plain, w.reading, w.meaning) for w in verbs.concat(adjectives))

$ = (s) ->
  if s[0] == "#"
    document.getElementById(s.substring(1))
  else if s[0] == "."
    document.getElementsByClassName(s.substring(1))
  else
    document.getElementsByTagName(s)

word = words[Math.floor(Math.random(words.length) * words.length)]
for elem in $('.replace')
  try
    want = elem.innerHTML
    w = word
    for conj in want.split(' ')
      w = w[conj]()
    elem.innerHTML = w
  catch error
