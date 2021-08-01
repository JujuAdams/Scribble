var _x = 10;
var _y = 10;

var _element = scribble("[#ff0000]This should be red");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[#00ff00]This should be green");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[#0000ff]This should be blue");
_element.draw(_x, _y);
_y += _element.get_height() + 10;