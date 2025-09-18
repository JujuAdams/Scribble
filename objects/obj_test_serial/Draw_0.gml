scribble(text)
.max_size(maxWidth, maxHeight)
.layout_paginate()
.clip()
.draw(10, 10);

draw_rectangle(10, 10, 10 + maxWidth, 10 + maxHeight, true);

draw_set_halign(fa_right);

var _string = $"{maxWidth}x{maxHeight}";
_string += $"\npage = {scribble(text).get_page()}";
_string += $"\nscroll = {scribble(text).get_scroll_y()}";

draw_text(room_width-10, 10, _string);
draw_set_halign(fa_left);