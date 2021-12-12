var _x = room_width/2;
var _y = room_height/2;

var _element = scribble("Test text\nTest text\nTest text");
_element.padding(20, 20, 20, 20);
_element.transform(2, 2, 30);
_element.origin(_element.get_width()/2, _element.get_height()/2);

var _bbox = _element.get_bbox(_x, _y);
draw_line(_bbox.x0, _bbox.y0, _bbox.x1, _bbox.y1);
draw_line(_bbox.x1, _bbox.y1, _bbox.x3, _bbox.y3);
draw_line(_bbox.x3, _bbox.y3, _bbox.x2, _bbox.y2);
draw_line(_bbox.x2, _bbox.y2, _bbox.x0, _bbox.y0);

_element.draw(_x, _y);

draw_circle(_x, _y, 4, false);

//draw_line(10, 10, room_width, 10);
//draw_line(10, 10, 10, room_height);