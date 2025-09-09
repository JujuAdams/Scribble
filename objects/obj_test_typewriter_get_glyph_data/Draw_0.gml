element.draw(x, y);

var _data = element.get_glyph_data(element.get_position()-1);
draw_rectangle(_data.left + x, _data.top + y,
               _data.right + x, _data.bottom + y,
               true);

draw_text(10, 100, element.get_position());
draw_text(10, 120, element.get_glyph_count());