scribble(text)
.layout_paginate()
.clip()
.scroll(scrollY, false)
.serial()
.serial_position(serialY)
.max_size(maxWidth, maxHeight)
.draw(10, 10);

draw_rectangle(10, 10, 10 + maxWidth, 10 + maxHeight, true);

var _string = $"{maxWidth}x{maxHeight}";
_string += $"\nscrollY = {scrollY}";
_string += $"\nserialY = {serialY}";

draw_set_halign(fa_right);
draw_text(room_width-10, 10, _string);
draw_set_halign(fa_left);