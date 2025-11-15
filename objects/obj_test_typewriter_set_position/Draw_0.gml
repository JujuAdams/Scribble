var _reveal = ((mouse_x / room_width) * (element.get_reveal_count() + 1));
element.typist_set_position(_reveal).draw(10, 10);

draw_text(10, element.get_height() + 20, $"{_reveal} ({element.typist_get_position()}) of {element.get_reveal_count()}");