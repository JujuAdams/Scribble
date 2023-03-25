var _x = 10;
var _y = 10;

var _element = scribble("text test");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("text [offset,-10,10]offset text[/offset]");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("text [offset,10,-10]hanging offset");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("invalid [offset,10,10][/offset]offset tags");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("two [offset,0,10]offset [offset,0,-10]uses");
_element.draw(_x, _y);
_y += _element.get_height() + 10;