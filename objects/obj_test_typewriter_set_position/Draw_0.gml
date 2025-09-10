var _reveal = floor((mouse_x / room_width) * element.get_reveal_count());
element.set_position(_reveal);
element.draw(10, 10);

draw_text(10, 30, $"{_reveal} ({element.get_position()}) of {element.get_glyph_count()}");