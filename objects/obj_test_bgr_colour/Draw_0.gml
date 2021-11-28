draw_text(10, 10, "SCRIBBLE_BGR_COLOR_HEX_CODES = " + string(SCRIBBLE_BGR_COLOR_HEX_CODES));

var _x = 10;
var _y = 50;

var _element = scribble("[#ff0000]This should be red");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[#00ff00]This should be green");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[#0000ff]This should be blue");
_element.draw(_x, _y);
_y += _element.get_height() + 10;