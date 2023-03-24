var _x = room_width/2;
var _y = room_height/5;

var _element = scribble("2x xscale");
_element.origin(_element.get_width()/2, _element.get_height()/2);
_element.post_transform(2, 1, 0);
_element.draw(_x, _y);
draw_circle(_x, _y, 4, false);

_y = 2*room_height/5;

var _element = scribble("2x yscale");
_element.origin(_element.get_width()/2, _element.get_height()/2);
_element.post_transform(1, 2, 0);
_element.draw(_x, _y);
draw_circle(_x, _y, 4, false);

_y = 3*room_height/5;

var _element = scribble("2x xscale + yscale");
_element.origin(_element.get_width()/2, _element.get_height()/2);
_element.post_transform(2, 2, 0);
_element.draw(_x, _y);
draw_circle(_x, _y, 4, false);

_y = 4*room_height/5;

var _element = scribble("2x xscale + yscale + rotation");
_element.origin(_element.get_width()/2, _element.get_height()/2);
_element.post_transform(2, 2, -10);
_element.draw(_x, _y);
draw_circle(_x, _y, 4, false);