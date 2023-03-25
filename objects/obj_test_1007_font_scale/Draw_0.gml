var _wrap = mouse_x - x;

scribble("[wave]The brown fox jumps over the fence. [scale,2]Juju[/scale] is a little pug, his fur is white as snow.")
.layout_wrap(_wrap)
.draw(x, y);

draw_line(_wrap + x, 0, _wrap + x, room_height);