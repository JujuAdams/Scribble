// Feather disable all

image_angle += 0.5;

draw_self();

var _element = scribble("Here's some text\nHere's another line")
.align("pin_center", "pin_middle")
.wrap(sprite_width, sprite_height) //or fit_to_box() or scale_to_box()
.origin(sprite_xoffset, sprite_yoffset)
.transform(1, 1, image_angle)
.blend(c_black, 1);
_element.draw(x, y);

draw_set_color(c_red);
var _bbox = _element.get_bbox(x, y);
draw_line(_bbox.x0, _bbox.y0, _bbox.x1, _bbox.y1);
draw_line(_bbox.x1, _bbox.y1, _bbox.x3, _bbox.y3);
draw_line(_bbox.x3, _bbox.y3, _bbox.x2, _bbox.y2);
draw_line(_bbox.x2, _bbox.y2, _bbox.x0, _bbox.y0);
draw_set_color(c_white);