var _x = 10;
var _y = 10;

var _element = scribble_unique(0, "[spr_white_coin] <-- red coin![/] (.colour())").colour(c_red);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble_unique(1, "[spr_white_coin] <-- red coin![/] (.rgb_multiply())").rgb_multiply(c_red);
_element.draw(_x, _y);
_y += _element.get_height() + 10;