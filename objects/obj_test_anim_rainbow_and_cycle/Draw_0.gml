var _x = 10;
var _y = 10;

var _element = scribble("-->[rainbow]rainbow text rainbow text rainbow text[/rainbow]<--");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("-->[cycle,test]cycle text cycle text cycle text[/cycle]<--");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_cycle(SCRIBBLE_DEFAULT_CYCLE_SPEED, SCRIBBLE_DEFAULT_CYCLE_FREQUENCY);
var _element = scribble("-->[cycle,test]cycle text[/rainbow] [rainbow]rainbow text[/cycle]<--", 0);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_cycle(SCRIBBLE_DEFAULT_CYCLE_SPEED/4, SCRIBBLE_DEFAULT_CYCLE_FREQUENCY);
var _element = scribble("-->[cycle,test]cycle text[/rainbow] [rainbow]rainbow text[/cycle]<-- slower", 0);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_cycle(SCRIBBLE_DEFAULT_CYCLE_SPEED, SCRIBBLE_DEFAULT_CYCLE_FREQUENCY/4);
var _element = scribble("-->[cycle,test]cycle text[/rainbow] [rainbow]rainbow text[/cycle]<-- lower frequency", 0);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_cycle(SCRIBBLE_DEFAULT_CYCLE_SPEED/4, SCRIBBLE_DEFAULT_CYCLE_FREQUENCY/4);
var _element = scribble("-->[cycle,test]cycle text[/rainbow] [rainbow]rainbow text[/cycle]<-- slower and lower frequency", 0);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_cycle(SCRIBBLE_DEFAULT_CYCLE_SPEED, 0);
var _element = scribble("-->[cycle,test]cycle text[/rainbow] [rainbow]rainbow text[/cycle]<-- zero frequency", 0);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

scribble_anim_reset();