var _x = 10;
var _y = 10;

element.draw(_x, _y);
_y += element.get_height() + 10;

var _element = scribble("Here's some other text");
_element.draw(_x, _y);
_y += _element.get_height() + 10;