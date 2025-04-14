draw_text(10, 10, "This test case checks bilinear filtering is being set for sprites");

var _x = 10;
var _y = 30;

var _string = "This text should be blurry.";
var _element = scribble(_string);
_element.scale(3);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _string = "[spr_coin] <- This sprite should be clear.";
var _element = scribble(_string);
_element.scale(3);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _oldFilter = gpu_get_tex_filter();
gpu_set_tex_filter(true);
var _string = "[spr_coin] <- This sprite should be blurry.";
var _element = scribble(_string);
_element.scale(3);
_element.draw(_x, _y);
_y += _element.get_height() + 10;
gpu_set_tex_filter(_oldFilter);