var _x = 10;
var _y = 10;

var _string = "[fnt_style]This should be in Candara";
var _element = scribble(_string);
_element.draw(10, _y);
_y += _element.get_height() + 10;

var _string = "[fnt_copy]This should be in Candara but 2x larger";
var _element = scribble(_string);
_element.draw(10, _y);
_y += _element.get_height() + 10;