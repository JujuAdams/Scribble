// Feather disable all

element.draw(room_width/2, room_height/2);

var _bbox = element.get_bbox(room_width/2, room_height/2);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);

draw_line(room_width/2, 0, room_width/2, room_height);
draw_line(0, room_height/2, room_width, room_height/2);