element = scribble_unique("here's some [wave]cute text[/wave]! [spr_large_coin]\nHere's some more text!");
element.allow_glyph_data_getter();
element.in(0.1, 10);
element.ease(SCRIBBLE_EASE_BOUNCE, 0, -40, 1, 1, 0, 0.1);