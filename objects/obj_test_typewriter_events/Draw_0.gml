var _element = scribble("[sdm,first]abc[sdm,end]");
_element.draw(10, 50, typist);

draw_text(10, 10, typist.get_state());
draw_text(10, 30, typist.get_position());