var _string = "His manner was not effusive. It seldom was; but he was glad, I think, to see me. With hardly a word spoken, but with a kindly eye, he waved me to an armchair, threw across his case of cigars, and indicated a spirit case and a gasogene in the corner. Then he stood before the fire and looked me over in his singular introspective fashion.";

var _element = scribble(_string).layout_wrap(room_width/2);
_element.draw(10, 50, typist);

draw_set_font(scribble_fallback_font);
draw_text(10, 10, typist.get_state());
draw_text(10, 30, typist.get_position());