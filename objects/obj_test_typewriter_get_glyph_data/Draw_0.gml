var _x = 10;
var _y = 10;

element.draw(_x, _y);

var _data = element.get_glyph_data(element.typist_get_position()-1);
draw_rectangle(_data.left + _x, _data.top + _y,
               _data.right + _x, _data.bottom + _y,
               true);

draw_text(10, element.get_height() + 20, element.typist_get_debug_info());