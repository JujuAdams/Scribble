var _x = 10;
var _y = 10;

var _element = scribble("The .scale_to_box() method allows for a Scribble\ntext element to be scaled cheaply to fit a box.\nThis is especially useful when combined with MSDF\nfonts. Please note that this behaviour is\nmutually exclusive with .wrap() and .fit_to_box()", 0);
_element.scale_to_box(mouse_x - 10, mouse_y - 10)
_element.draw(_x, _y);
_y += _element.get_height() + 10;

draw_rectangle(10, 10, mouse_x, mouse_y, true);