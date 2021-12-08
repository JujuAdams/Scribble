if (mouse_check_button(mb_left))
{
    width  = mouse_x;
    height = mouse_y;
}

var _element = scribble("Hello dear Pug Master", 1);
_element.scale_to_box(width, height);
_element.draw(0, 0);

var _bbox = _element.get_bbox(0, 0);
draw_line(_bbox.x0, _bbox.y0, _bbox.x1, _bbox.y1);
draw_line(_bbox.x1, _bbox.y1, _bbox.x3, _bbox.y3);
draw_line(_bbox.x3, _bbox.y3, _bbox.x2, _bbox.y2);
draw_line(_bbox.x2, _bbox.y2, _bbox.x0, _bbox.y0);



var _element = scribble("Hello dear Pug Master", 2);
_element.origin(_element.get_width()/2, _element.get_height()/2);
_element.transform(1, 1, -15);
_element.draw(room_width/2, room_height/2 - 120);
draw_circle(room_width/2, room_height/2 - 120, 6, true);

var _bbox = _element.get_bbox(room_width/2, room_height/2 - 120);
draw_line(_bbox.x0, _bbox.y0, _bbox.x1, _bbox.y1);
draw_line(_bbox.x1, _bbox.y1, _bbox.x3, _bbox.y3);
draw_line(_bbox.x3, _bbox.y3, _bbox.x2, _bbox.y2);
draw_line(_bbox.x2, _bbox.y2, _bbox.x0, _bbox.y0);



var _element = scribble("Hello dear Pug Master", 3);
_element.scale_to_box(width, height);
_element.origin(_element.get_width()/2, _element.get_height()/2);
_element.transform(2, 2, -15);
_element.draw(room_width/2, room_height/2 + 120);
draw_circle(room_width/2, room_height/2 + 120, 6, true);

var _bbox = _element.get_bbox(room_width/2, room_height/2 + 120);
draw_line(_bbox.x0, _bbox.y0, _bbox.x1, _bbox.y1);
draw_line(_bbox.x1, _bbox.y1, _bbox.x3, _bbox.y3);
draw_line(_bbox.x3, _bbox.y3, _bbox.x2, _bbox.y2);
draw_line(_bbox.x2, _bbox.y2, _bbox.x0, _bbox.y0);