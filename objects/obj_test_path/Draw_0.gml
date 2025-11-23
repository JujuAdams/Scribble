var _x = room_width/2;
var _y = room_height/2;

gpu_set_tex_filter(true);

var _element = scribble("Here is some text laid out along a smooth path");
_element.path(pth_test_curve, 0, 1);
_element.align("pin_centre", fa_bottom);
_element.layout_squash();
_element.draw(_x, _y);
draw_path(pth_test_curve, _x, _y, false);

gpu_set_tex_filter(false);