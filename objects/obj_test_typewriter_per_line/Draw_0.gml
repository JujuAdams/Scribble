var _element = scribble("[delay,2000][sdm,first]abc[sdm,end]");
_element.draw(10, 50, typist);

draw_set_font(scribble_fallback_font);
draw_text(10, 10, typist.get_state());
draw_text(10, 30, typist.get_position());