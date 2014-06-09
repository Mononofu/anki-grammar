(function() {
  var $, Adjective, IAdjective, II, Kuru, NaAdjective, Negative, PoliteAdjective, PoliteAdjectiveNegative, PoliteNaAdjective, PoliteVerb, PoliteVerbNegative, RuVerb, Suru, UVerb, Verb, Word, aSounds, adjectives, classify, conj, eSounds, elem, iSounds, oSounds, uSounds, verbs, w, want, word, words, _i, _j, _len, _len2, _ref, _ref2,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  aSounds = ["ら", "や", "ま", "は", "な", "た", "さ", "か", "あ", "ぱ", "ば", "だ", "ざ", "が"];

  iSounds = ["り", "", "み", "ひ", "に", "ち", "し", "き", "い", "ぴ", "び", "ぢ", "じ", "ぎ"];

  uSounds = ["る", "ゆ", "む", "ふ", "ぬ", "つ", "す", "く", "う", "ぷ", "ぶ", "づ", "ず", "ぐ"];

  eSounds = ["れ", "", "め", "へ", "ね", "て", "せ", "け", "え", "ぺ", "べ", "で", "ぜ", "げ"];

  oSounds = ["ろ", "よ", "も", "ほ", "の", "と", "そ", "こ", "お", "ぽ", "ぼ", "ど", "ぞ", "ご"];

  String.prototype.replaceLast = function(from, to) {
    var i, s, _ref;
    s = this.toString();
    for (i = 0, _ref = from.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
      if (s.slice(-1) === from[i]) return s.slice(0, -1) + to[i];
    }
    return s;
  };

  Word = (function() {

    function Word(_plain, _reading, _meaning) {
      this._plain = _plain;
      this._reading = _reading;
      this._meaning = _meaning;
    }

    Word.prototype.plain = function() {
      return this._plain;
    };

    Word.prototype.reading = function() {
      return this._reading;
    };

    Word.prototype.meaning = function() {
      return this._meaning;
    };

    Word.prototype.toString = function() {
      return this.plain();
    };

    return Word;

  })();

  Negative = (function(_super) {

    __extends(Negative, _super);

    function Negative(_plain) {
      this._plain = _plain;
    }

    Negative.prototype.plain = function() {
      return this._plain;
    };

    Negative.prototype.toString = function() {
      return this.plain();
    };

    Negative.prototype.past = function() {
      return this._plain.replace(/い$/, "かった");
    };

    Negative.prototype.te = function() {
      return this._plain.replace(/い$/, "くて");
    };

    Negative.prototype.conditional = function() {
      return this._plain.replace(/い$/, "ければ");
    };

    return Negative;

  })(Word);

  Verb = (function(_super) {

    __extends(Verb, _super);

    function Verb() {
      Verb.__super__.constructor.apply(this, arguments);
    }

    Verb.prototype.polite = function() {
      return new PoliteVerb(this.stem());
    };

    Verb.prototype.te = function() {
      return this.past().replace(/た$/, "て").replace(/だ$/, "で");
    };

    return Verb;

  })(Word);

  PoliteVerb = (function(_super) {

    __extends(PoliteVerb, _super);

    function PoliteVerb(_plain) {
      this._plain = _plain;
    }

    PoliteVerb.prototype.plain = function() {
      return this._plain + "ます";
    };

    PoliteVerb.prototype.toString = function() {
      return this.plain();
    };

    PoliteVerb.prototype.negative = function() {
      return new PoliteVerbNegative(this._plain);
    };

    PoliteVerb.prototype.past = function() {
      return this._plain + "ました";
    };

    PoliteVerb.prototype.volitional = function() {
      return this._plain + "ましょう";
    };

    return PoliteVerb;

  })(Verb);

  PoliteVerbNegative = (function(_super) {

    __extends(PoliteVerbNegative, _super);

    function PoliteVerbNegative(_plain) {
      this._plain = _plain;
    }

    PoliteVerbNegative.prototype.plain = function() {
      return this._plain + "ません";
    };

    PoliteVerbNegative.prototype.toString = function() {
      return this.plain();
    };

    PoliteVerbNegative.prototype.past = function() {
      return this._plain + "ませんでした";
    };

    return PoliteVerbNegative;

  })(PoliteVerb);

  RuVerb = (function(_super) {

    __extends(RuVerb, _super);

    function RuVerb() {
      RuVerb.__super__.constructor.apply(this, arguments);
    }

    RuVerb.prototype.stem = function() {
      return this._plain.replace(/る$/, "");
    };

    RuVerb.prototype.negative = function() {
      return new Negative(this.stem() + "ない");
    };

    RuVerb.prototype.past = function() {
      return this.stem() + "た";
    };

    RuVerb.prototype.potential = function() {
      return new RuVerb(this.stem() + "られる");
    };

    RuVerb.prototype.volitional = function() {
      return this.stem() + "よう";
    };

    RuVerb.prototype.conditional = function() {
      return this._plain.replaceLast(uSounds, eSounds) + "ば";
    };

    return RuVerb;

  })(Verb);

  UVerb = (function(_super) {

    __extends(UVerb, _super);

    function UVerb() {
      UVerb.__super__.constructor.apply(this, arguments);
    }

    UVerb.prototype.stem = function() {
      return this._plain.replaceLast(uSounds, iSounds);
    };

    UVerb.prototype.negative = function() {
      var base;
      base = (function() {
        switch (this._plain) {
          case "ある":
            return "ない";
          default:
            return this._plain.replace(/う$/, "わ").replaceLast(uSounds, aSounds) + "ない";
        }
      }).call(this);
      return new Negative(base);
    };

    UVerb.prototype.past = function() {
      switch (this._plain) {
        case "行く":
          return "行った";
        default:
          return this._plain.replace(/う$/, "った").replace(/つ$/, "った").replace(/る$/, "った").replace(/む$/, "んだ").replace(/ぶ$/, "んだ").replace(/ぬ$/, "んだ").replace(/す$/, "した").replace(/く$/, "いた").replace(/ぐ$/, "いだ");
      }
    };

    UVerb.prototype.potential = function() {
      return new RuVerb(this._plain.replaceLast(uSounds, eSounds) + "る");
    };

    UVerb.prototype.volitional = function() {
      return this._plain.replaceLast(uSounds, oSounds) + "う";
    };

    UVerb.prototype.conditional = function() {
      return this._plain.replaceLast(uSounds, eSounds) + "ば";
    };

    return UVerb;

  })(Verb);

  Suru = (function(_super) {

    __extends(Suru, _super);

    function Suru() {
      this._plain = "する";
    }

    Suru.prototype.stem = function() {
      return "し";
    };

    Suru.prototype.negative = function() {
      return new Negative("しない");
    };

    Suru.prototype.past = function() {
      return "した";
    };

    Suru.prototype.potential = function() {
      return new RuVerb("できる");
    };

    Suru.prototype.volitional = function() {
      return "しよう";
    };

    return Suru;

  })(Verb);

  Kuru = (function(_super) {

    __extends(Kuru, _super);

    function Kuru() {
      this._plain = "くる";
    }

    Kuru.prototype.stem = function() {
      return "き";
    };

    Kuru.prototype.negative = function() {
      return new Negative("こない");
    };

    Kuru.prototype.past = function() {
      return "きた";
    };

    Kuru.prototype.potential = function() {
      return new RuVerb("こられる");
    };

    Kuru.prototype.volitional = function() {
      return "こよう";
    };

    return Kuru;

  })(Verb);

  Adjective = (function(_super) {

    __extends(Adjective, _super);

    function Adjective() {
      Adjective.__super__.constructor.apply(this, arguments);
    }

    Adjective.prototype.polite = function() {
      return new PoliteAdjective(this);
    };

    Adjective.prototype.toString = function() {
      return this.plain();
    };

    return Adjective;

  })(Word);

  PoliteAdjective = (function(_super) {

    __extends(PoliteAdjective, _super);

    function PoliteAdjective(_plain) {
      this._plain = _plain;
    }

    PoliteAdjective.prototype.plain = function() {
      return this._plain + "です";
    };

    PoliteAdjective.prototype.toString = function() {
      return this.plain();
    };

    PoliteAdjective.prototype.negative = function() {
      return new PoliteAdjectiveNegative(this._plain.negative());
    };

    PoliteAdjective.prototype.past = function() {
      return this._plain.past() + "です";
    };

    return PoliteAdjective;

  })(Adjective);

  PoliteAdjectiveNegative = (function(_super) {

    __extends(PoliteAdjectiveNegative, _super);

    function PoliteAdjectiveNegative(_plain) {
      this._plain = _plain;
    }

    PoliteAdjectiveNegative.prototype.plain = function() {
      return this._plain + "です";
    };

    PoliteAdjectiveNegative.prototype.past = function() {
      return this._plain.past() + "です";
    };

    return PoliteAdjectiveNegative;

  })(PoliteAdjective);

  PoliteNaAdjective = (function(_super) {

    __extends(PoliteNaAdjective, _super);

    function PoliteNaAdjective() {
      PoliteNaAdjective.__super__.constructor.apply(this, arguments);
    }

    PoliteNaAdjective.prototype.past = function() {
      return this._plain + "でした";
    };

    return PoliteNaAdjective;

  })(PoliteAdjective);

  IAdjective = (function(_super) {

    __extends(IAdjective, _super);

    function IAdjective() {
      IAdjective.__super__.constructor.apply(this, arguments);
    }

    IAdjective.prototype.adverb = function() {
      return this._plain.replace(/い$/, "く");
    };

    IAdjective.prototype.negative = function() {
      return new Negative(this._plain.replace(/い$/, "くない"));
    };

    IAdjective.prototype.past = function() {
      return this._plain.replace(/い$/, "かった");
    };

    IAdjective.prototype.te = function() {
      return this._plain.replace(/い$/, "くて");
    };

    IAdjective.prototype.conditional = function() {
      return this._plain.replace(/い$/, "ければ");
    };

    return IAdjective;

  })(Adjective);

  II = (function(_super) {

    __extends(II, _super);

    function II() {
      this._plain = "よい";
    }

    II.prototype.plain = function() {
      return "いい";
    };

    return II;

  })(IAdjective);

  NaAdjective = (function(_super) {

    __extends(NaAdjective, _super);

    function NaAdjective() {
      NaAdjective.__super__.constructor.apply(this, arguments);
    }

    NaAdjective.prototype.adverb = function() {
      return this._plain + "に";
    };

    NaAdjective.prototype.negative = function() {
      return new Negative(this._plain + "じゃない");
    };

    NaAdjective.prototype.past = function() {
      return this._plain + "だった";
    };

    NaAdjective.prototype.te = function() {
      return this._plain + "で";
    };

    NaAdjective.prototype.conditional = function() {
      return this._plain + "であれば";
    };

    return NaAdjective;

  })(Adjective);

  verbs = [
    {
      plain: "見る",
      reading: "みる",
      meaning: "to see"
    }, {
      plain: "食べる",
      reading: "たべる",
      meaning: "to eat"
    }, {
      plain: "寝る",
      reading: "ねる",
      meaning: "to sleep"
    }, {
      plain: "起きる",
      reading: "おきる",
      meaning: "to wake up"
    }, {
      plain: "考える",
      reading: "かんがえる",
      meaning: "to think"
    }, {
      plain: "教える",
      reading: "おしえる",
      meaning: "to teach"
    }, {
      plain: "出る",
      reading: "でる",
      meaning: "to exit"
    }, {
      plain: "着る",
      reading: "きる",
      meaning: "to wear"
    }, {
      plain: "居る",
      reading: "いる",
      meaning: "to be (animate)"
    }, {
      plain: "在る",
      reading: "ある",
      meaning: "to be (inanimate)"
    }, {
      plain: "話す",
      reading: "はなす",
      meaning: "to talk"
    }, {
      plain: "聞く",
      reading: "きく",
      meaning: "to hear"
    }, {
      plain: "泳ぐ",
      reading: "およぐ",
      meaning: "to swim"
    }, {
      plain: "遊ぶ",
      reading: "あそぶ",
      meaning: "to play"
    }, {
      plain: "待つ",
      reading: "まつ",
      meaning: "to wait"
    }, {
      plain: "飲む",
      reading: "のむ",
      meaning: "to drink"
    }, {
      plain: "買う",
      reading: "かう",
      meaning: "to buy"
    }, {
      plain: "帰る",
      reading: "かえる",
      meaning: "to return"
    }, {
      plain: "死ぬ",
      reading: "しぬ",
      meaning: "to die"
    }, {
      plain: "為る",
      reading: "する",
      meaning: "to do"
    }, {
      plain: "来る",
      reading: "くる",
      meaning: "to come"
    }
  ];

  adjectives = [
    {
      plain: "良い",
      reading: "いい",
      meaning: "good"
    }
  ];

  classify = function(plain, reading, meaning) {
    var _ref;
    switch (reading) {
      case "する":
        return new Suru();
      case "くる":
        return new Kuru();
      case "いい":
        return new II();
      default:
        switch (reading.slice(-1)) {
          case "う":
          case "つ":
          case "む":
          case "ぶ":
          case "ぬ":
          case "す":
          case "く":
          case "ぐ":
            return new UVerb(plain, reading, meaning);
          case "る":
            switch (plain) {
              case "要る":
              case "帰る":
              case "切る":
              case "喋る":
              case "知る":
              case "入る":
              case "走る":
              case "減る":
              case "焦る":
              case "限る":
              case "蹴る":
              case "滑る":
              case "握る":
              case "練る":
              case "参る":
              case "交じる":
              case "混じる":
              case "嘲る":
              case "覆る":
              case "遮る":
              case "罵る":
              case "捻る":
              case "翻る":
              case "滅入る":
              case "蘇る":
                return new UVerb(plain, reading, meaning);
              default:
                if (_ref = reading.slice(-2, -1), __indexOf.call(eSounds.concat(iSounds), _ref) >= 0) {
                  return new RuVerb(plain, reading, meaning);
                } else {
                  return new UVerb(plain, reading, meaning);
                }
            }
            break;
          case "い":
            switch (reading) {
              case "嫌い":
              case "奇麗":
              case "綺麗":
              case "きれい":
                return new NaAdjective(plain, reading, meaning);
              default:
                return new IAdjective(plain, reading, meaning);
            }
        }
    }
  };

  words = (function() {
    var _i, _len, _ref, _results;
    _ref = verbs.concat(adjectives);
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      w = _ref[_i];
      _results.push(classify(w.plain, w.reading, w.meaning));
    }
    return _results;
  })();

  $ = function(s) {
    if (s[0] === "#") {
      return document.getElementById(s.substring(1));
    } else if (s[0] === ".") {
      return document.getElementsByClassName(s.substring(1));
    } else {
      return document.getElementsByTagName(s);
    }
  };

  word = words[Math.floor(Math.random(words.length) * words.length)];

  _ref = $('.replace');
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    elem = _ref[_i];
    try {
      want = elem.innerHTML;
      w = word;
      _ref2 = want.split(' ');
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        conj = _ref2[_j];
        w = w[conj]();
      }
      elem.innerHTML = w;
    } catch (error) {

    }
  }

}).call(this);
