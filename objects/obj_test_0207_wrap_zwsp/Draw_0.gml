var _string = "pneumonoultramicrosco[zwsp]picsilicovolca[zwsp]noconiosis";

var _element = scribble(_string).layout_wrap(width);
_element.draw(x, y);

draw_circle(x, y, 6, true);
draw_rectangle(x, y, x + width, y + _element.get_height(), true);

draw_circle(room_width div 2, y + _element.get_height() + 40, 6, true);

scribble(_string).layout_wrap(width).draw(room_width div 2, y + _element.get_height() + 40);