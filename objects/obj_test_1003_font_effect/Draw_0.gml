var _x = 10;
var _y = 10;

var _element = scribble("Base spritefont");
_element.scale(3);
_element.font("spr_sprite_font");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Spritefont with 4-dir outline");
_element.scale(3);
_element.font("outline 4");
_element.outline(c_blue);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Spritefont with 8-dir outline");
_element.scale(3);
_element.font("outline 8");
_element.outline(c_blue);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Spritefont with shadow");
_element.scale(3);
_element.font("shadow");
_element.shadow(c_black, 1);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Spritefont with outline + shadow");
_element.scale(3);
_element.font("both");
_element.outline(c_blue);
_element.shadow(c_black, 1);
_element.draw(_x, _y);
_y += _element.get_height() + 10;