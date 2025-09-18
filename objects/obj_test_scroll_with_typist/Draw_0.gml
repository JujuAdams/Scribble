element.draw(10, 10);

draw_rectangle(10, 10, 10 + maxWidth, 10 + maxHeight, true);

draw_set_halign(fa_right);
var _string = $"{maxWidth}x{maxHeight}";
_string += $"\npaused = {element.get_paused()}";
draw_text(room_width-10, 10, _string);
draw_set_halign(fa_left);