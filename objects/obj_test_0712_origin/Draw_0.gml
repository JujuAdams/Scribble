var _x = room_width/2;
var _y = 40;

var _angle = lerp(-10, 10, 0.5 + 0.5*dsin(current_time/50));
var _scale = lerp(1, 1.5, 0.5 + 0.5*dsin(current_time/50));

var _element = scribble("Origin set to bbox centre and middle");
_element.origin(_element.get_width()/2, _element.get_height()/2);
_element.draw(_x, _y);
draw_circle(_x, _y, 4, false);

_x  = 250;
_y +=  70;

var _element = scribble("Centre/middle origin with rotation");
_element.origin(_element.get_width()/2, _element.get_height()/2);
_element.post_transform(1, 1, _angle);
_element.draw(_x, _y);
draw_circle(_x, _y, 4, false);

_x += 250;

var _element = scribble("Left/middle origin with rotation");
_element.origin(0, _element.get_height()/2);
_element.post_transform(1, 1, _angle);
_element.draw(_x, _y);
draw_circle(_x, _y, 4, false);

_x = room_width/2;
_y = 180;

var _element = scribble("Centre/top origin with scale");
_element.origin(_element.get_width()/2, 0);
_element.post_transform(_scale, _scale, 0);
_element.draw(_x, _y);
draw_circle(_x, _y, 4, false);