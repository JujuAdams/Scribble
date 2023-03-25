var _x = 10;
var _y = 10;

var _element = scribble("[blink]blinky text blinky text blinky text");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_blink(30, 8, 0);
var _element = scribble("higher on duration [blink]blink blink");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_blink(8, 30, 0);
var _element = scribble("higher off duration [blink]blink blink");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_blink(8, 8, 2);
var _element = scribble("blink offset 2 [blink]blink blink");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_blink(8, 8, 4);
var _element = scribble("blink offset 4 [blink]blink blink");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_blink(8, 8, 6);
var _element = scribble("blink offset 6 [blink]blink blink");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_blink(0, 0, 0);
var _element = scribble("double zero [blink]blink blink");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_reset();