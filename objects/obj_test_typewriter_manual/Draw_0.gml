var _string = "some manual typewriter text!";
var _element = scribble(_string);
var _pos = (mouse_x / room_width)*string_length(_string);

draw_set_font(scribble_fallback_font);
draw_text(10, 10, "reveal = " + string(_pos) + " of " + string(string_length(_string)));

_element.reveal(_pos).draw(10, 50);