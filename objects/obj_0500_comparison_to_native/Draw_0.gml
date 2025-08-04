// Feather disable all

var _font  = fnt_riffic;
var _scale = 1;

var _string = "AbcD\nEfgH";

draw_set_font(_font);
var _width = string_width(_string);
var _height = string_height(_string);
draw_text_transformed(10, 10, _string, _scale, _scale, 0);
draw_set_font(-1);

scribble($"[{font_get_name(_font)}]{_string}").transform(_scale, _scale, 0).draw(20 + _scale*_width, 10);
scribble($"[{font_get_name(_font)}]{_string}").transform(_scale, _scale, 0).draw(10, 20 + _scale*_height);

draw_line(10, 10, 300, 10);