//var _string = "Lorem ipsum dolor sit amet,\n\nconsectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

var _string = "test test test test a[spr_coin][spr_coin][spr_coin]b a...b test";

var _element = scribble(_string).scale(1).fit_to_box(width, height);
_element.draw(x, y);

draw_circle(x, y, 6, true);
draw_rectangle(x, y, x + width, y + _element.get_height(), true);

draw_set_color(c_yellow);
draw_rectangle(x, y, x + width, y + height, true);
draw_set_color(c_white);