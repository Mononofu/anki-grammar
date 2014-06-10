(function() {
  var $, candidates, conj, elem, query, w, want, word, _i, _j, _len, _len2, _ref, _ref2;

  $ = function(s) {
    if (s[0] === "#") {
      return document.getElementById(s.substring(1));
    } else if (s[0] === ".") {
      return document.getElementsByClassName(s.substring(1));
    } else {
      return document.getElementsByTagName(s);
    }
  };

  window.random = function() {
    location.hash = "";
    return location.reload();
  };

  window.conjugate = function() {
    location.hash = $('#query').value;
    location.reload();
    return false;
  };

  word = words[Math.floor(Math.random(words.length) * words.length)];

  if (location.hash !== "") {
    query = location.hash.slice(1);
    $('#query').value = query;
    candidates = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = words.length; _i < _len; _i++) {
        w = words[_i];
        if (w.plain() === query || w.reading() === query) _results.push(w);
      }
      return _results;
    })();
    if (candidates.length > 0) {
      word = candidates[0];
    } else {
      word = classify(query, query, "n/a");
    }
  }

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
      elem.innerHTML = "";
    }
  }

}).call(this);
