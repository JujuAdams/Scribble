var _x = room_width/2;
var _y = room_height/4;

var _element = scribble("No skew\nNo skew\nNo skew");
_element.skew(0, 0);
_element.draw(_x, _y);

_y = 2*room_height/4;

var _element = scribble("x-skew\nx-skew\nx-skew", 0);
_element.skew(0.5, 0);
_element.draw(_x, _y);

_y = 3*room_height/4;

var _element = scribble("y-skew\ny-skew\ny-skew");
_element.skew(0, 0.5);
_element.draw(_x, _y);
