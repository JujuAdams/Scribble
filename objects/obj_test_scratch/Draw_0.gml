// Feather disable all

var _element = scribble("text\ntext\ntext\ntext\ntext\ntext\ntext\ntext\ntext\ntext")
               .max_size(107, 107)
               .clip()
               .align(fa_center, fa_middle)
               .scroll_auto();
               
_element.draw(room_width/2, room_height/2);

var _bbox = _element.get_bbox(room_width/2, room_height/2);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);

draw_line(room_width/2, 0, room_width/2, room_height);
draw_line(0, room_height/2, room_width, room_height/2);