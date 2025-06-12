---
title: "font2"
date: 2025-02-08T21:11:51-08:00
draft: false
---

When I moved from arch to nixos, I switched from X to Wayland, and decided also to switch status bars from i3status to i3status-rust, because I wasn't insufferable enough. I wanted to have fun little icons for my statusbar that look like this:


![statusbar](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/statusbar.png)


So I went to go find a font! First I went with noto emoji. Emoji had issues:
- they're a little colorful, and I don't want to draw attention to my statusbar
- they don't really map to the icons I want to use. I'd have to make some pretty serious compromises.
- for the icons I do want to use, they sometimes aren't granular enough, i.e. there aren't enough battery charge-state emojis


So then I went hunting for fonts. Nerdfonts has the best free selection, fontawesome as well. Including them in nix's configuration was frustrating, and ultimately required pulling in far more glyphs than I actually wanted to use.


Then we came to the next problem: rendering priority! If I wanted to use a font with a glyph for a charging battery, well, an emoji exists to represent that concept. And the unicode codepoint, which is inside the emoji space in this nerdfont, for that monocolored glyph, is going to be rendered by an emoji font first and a regular font second. And since many of these fonts are using the emoji codepoint space but aren't registered as emoji fonts, well, some of your icons become emojis and some of them don't. I could probably have taken a nerdfont and set its metadata as an emoji font, but then it would be used to render emoji elsewhere...Great.


So I just made my own font. [I repacked JetBrainsMono Regular](https://github.com/graevy/newfont) with a fontforge python script. I grabbed some svgs[^1]. This was faster than anything else I tried.


The quickest hack was to use the unicode private use area for each glyph, even the ones that basically rendered an emoji, because of the aforementioned font-preference issue. I spent more time learning how to properly use a nix shell and integrating the new font from github declaratively than scripting. This still isn't 100%, because the font isn't bitwise reproducible due to some artifacts from hosting this on github (current hypothesis).


Really, I learned I'm too hesitant to roll my own scripts sometimes, too comfortable on the beaten path as my preferences esotericize.

[^1]: svgrepo.com had the best solution. My girlfriend also made the battery icons <3
