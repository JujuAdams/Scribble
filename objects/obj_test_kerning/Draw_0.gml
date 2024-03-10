var _x = 10;
var _y = 10;

var _string = "AV OX";

draw_set_font(fnt_riffic);
draw_text(_x, _y, _string);
_y += string_height(_string) + 30;
draw_set_font(-1);

draw_set_font(fnt_riffic);
draw_text_scribble(_x, _y, _string);
_y += string_height_scribble(_string) + 30;
draw_set_font(-1);

var _element = scribble("[scale,1.3333][spr_sdf_riffic]" + _string);
_element.draw(_x, _y);
_y += _element.get_height() + 30;