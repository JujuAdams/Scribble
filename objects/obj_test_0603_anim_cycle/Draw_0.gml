var _x = 10;
var _y = 10;

var _element = scribble("[cycle,test 1]cycling text cycling text cycling text");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_cycle(0.7, 0.2);
var _element = scribble("[cycle,test 2]higher speed, lower frequency, different gradient");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_cycle(0.1, 2);
var _element = scribble("[cycle,test 1]lower speed higher frequency");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_reset();