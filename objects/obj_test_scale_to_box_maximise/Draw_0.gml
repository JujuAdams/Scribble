var _element = scribble("The .scale_to_box() method allows for a Scribble\ntext element to be scaled cheaply to fit a box.\nThis is especially useful when combined with MSDF\nfonts. Please note that this behaviour is\nmutually exclusive with .wrap() and .fit_to_box()", 0);
_element.scale_to_box(mouse_x - x, mouse_y - y, true)
_element.draw(x, y);
draw_rectangle(_element.get_left(x), _element.get_top(y), _element.get_right(x), _element.get_bottom(y), true);

draw_line(mouse_x, 0, mouse_x, room_height);
draw_line(0, mouse_y, room_width, mouse_y);