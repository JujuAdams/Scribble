var _x = 10;
var _y = 10;

var _string = "[fnt_test]abcdefghijklmnop\nabcdefghijklmnop";
var _element = scribble(_string);
_element.draw(10, _y);
_y += _element.get_height() + 10;