import commands

template_front = """<span id="word-type" class="hidden">{{WordType}}</span>
<span class="required-conjugation hidden">{{Front}}</span>
<span class="required-conjugation hidden">{{Back}}</span>

{{Back}}  of <span id="replace-front">{{Front}}</span>

<span id="error"></span>

<script>
%s
</script>"""

template_back = """{{FrontSide}}

<hr id="answer">

<span id="replace-back">{{Back}}</span>

<script>
%s
</script>"""

template_css = """.card {
  font-family: arial;
  font-size: 20px;
  text-align: center;
  color: black;
  background-color: white;
}
.hidden {
  display:none;
}"""

template_browser = """<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <style>
    %s
    </style>
  </head>
  <body>
    <input id="user-word-type" type="text" placeholder="WordType" oninput="update()">
    <input id="user-front" type="text" placeholder="Front" value="plain" oninput="update()">
    <input id="user-back" type="text" placeholder="Back" value="polite past" oninput="update()">
    <input type="button" value="Show Answer" onclick="show()">
    <input type="button" value="Random" onclick="random()">
    <br><br><br>
    <div class="card">
    </div>
    <script>
      var frontTemplate = '%s';
      var backTemplate = '%s';
      var card = document.getElementsByClassName('card')[0];

      function fillPlaceholders(template) {
        return template
            .replace(new RegExp('{{WordType}}', 'g'), document.getElementById('user-word-type').value)
            .replace(new RegExp('{{Front}}', 'g'), document.getElementById('user-front').value)
            .replace(new RegExp('{{Back}}', 'g'), document.getElementById('user-back').value);
      }

      function runScripts(tag) {
        var scripts = tag.getElementsByTagName('script');
        for(var i = 0; i < scripts.length; i++) {
          eval(scripts[i].innerHTML);
        }
      }

      function update() {
        card.innerHTML = fillPlaceholders(frontTemplate);
        runScripts(card);
      }

      function show() {
        card.innerHTML = fillPlaceholders(backTemplate)
            .replace('{{FrontSide}}', fillPlaceholders(frontTemplate));
        runScripts(card);
      }

      function random() {
        window.wo
        rd = undefined;
        update();
      }

      update();
    </script>
  </body>
</html>"""

def read_js(filename):
  with open("%s.js" % filename) as f:
    return f.read()

def escape_html(html):
  return html.replace("'", "\\'").replace("\n", "\\n").replace("</script>", "</scr'+'ipt>")

# Compile coffeescript to JS
commands.getoutput("coffee --compile *coffee")

front = template_front % ("%s\n\n\n%s" % (read_js("conjugate"), read_js("anki")))
with open("anki_front.html", "w") as f:
  f.write(front)

back = template_back % read_js("anki_back")
with open("anki_back.html", "w") as f:
  f.write(back)

with open("anki.css", "w") as f:
  f.write(template_css)

with open("anki.html", "w") as f:
  f.write(template_browser % (template_css, escape_html(front), escape_html(back)))
