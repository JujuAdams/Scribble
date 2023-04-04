var _x = 10;
var _y = 10;

var _element = scribble("Base spritefont");
_element.font("spr_sprite_font");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Spritefont with 4-dir outline");
_element.font("outline 4");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Spritefont with 8-dir outline");
_element.font("outline 8");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Spritefont with shadow");
_element.font("shadow");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Spritefont with outline + shadow");
_element.font("both");
_element.draw(_x, _y);
_y += _element.get_height() + 10;