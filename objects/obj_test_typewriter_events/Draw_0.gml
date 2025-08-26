element.draw(10, 50);

draw_set_font(scribble_fallback_font);
draw_text(10, 10, element.get_state());
draw_text(10, 30, element.get_position());

