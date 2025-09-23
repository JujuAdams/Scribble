element = scribble_unique("here's some [wave]cute text[/wave]! [spr_large_coin]\nHere's some more text!")
.allow_glyph_data_getter()
.typist_options({ speed: 0.05, smoothness: 3 })
.typist_ease(SCRIBBLE_EASE_BOUNCE, 0, -40, 1, 1, 0, 0.1)
.typist_start();