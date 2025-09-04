var _element = scribble(test_string).allow_glyph_data_getter();
_element.draw(x, y, typist);

var _data = _element.get_glyph_data(typist.get_position()-1);
draw_rectangle(_data.left + x, _data.top + y,
               _data.right + x, _data.bottom + y,
               true);

draw_text(10, 100, typist.get_position());
draw_text(10, 120, _element.get_glyph_count());