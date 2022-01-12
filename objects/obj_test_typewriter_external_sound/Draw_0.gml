var _element = scribble("[external]abc[external]");
_element.draw(10, 50, typist);

draw_set_font(scribble_fallback_font);
draw_text(10, 10, typist.get_state());
draw_text(10, 30, typist.get_position());