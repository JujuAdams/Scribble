var _string = "דג סקרן שט בים מאוכזב ולפתע מצא חברה";
var _string = "דג 0123! סקרן";

var _element = scribble(_string).starting_format("fnt_hebrew", c_white).wrap(width);
_element.draw(x, y, typist);

var _bbox = _element.get_bbox(x, y);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);

draw_set_color(c_yellow);
draw_line(x, y, x, room_height);
draw_line(x, y, room_width, y);
draw_line(x + width, 0, x + width, room_height);
draw_set_color(c_white);

draw_set_font(fnt_hebrew);
draw_text(100, 200, StringHebrewParse(_string));