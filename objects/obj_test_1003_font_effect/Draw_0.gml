var _x = 10;
var _y = 10;

var _outline_colour = make_colour_hsv((current_time/10) mod 255, 255, 255);
var _shadow_colour  = make_colour_hsv((127 + current_time/10) mod 255, 255, 255);

var _element = scribble("Base spritefont");
_element.scale(3);
_element.font("spr_sprite_font");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Spritefont with 4-dir outline");
_element.scale(3);
_element.font("outline 4");
_element.outline(_outline_colour);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Spritefont with 8-dir outline");
_element.scale(3);
_element.font("outline 8");
_element.outline(_outline_colour);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Spritefont with shadow");
_element.scale(3);
_element.font("shadow");
_element.shadow(_shadow_colour, 1);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("Spritefont with outline + shadow");
_element.scale(3);
_element.font("both");
_element.outline(_outline_colour);
_element.shadow(_shadow_colour, 1);
_element.draw(_x, _y);
_y += _element.get_height() + 10;