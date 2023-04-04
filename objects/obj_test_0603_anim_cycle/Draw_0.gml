var _x = 10;
var _y = 10;

var _element = scribble("Uneffected text");
_element.draw(_x, _y);
_y += _element.get_height() + 10;

//var _element = scribble("[cycle,test 1]cycling text cycling text cycling text");
//_element.draw(_x, _y);
//_y += _element.get_height() + 10;
//
//scribble_anim_cycle(0.5, 180, 255);
//var _element = scribble("[cycle,test 1]higher speed");
//_element.draw(_x, _y);
//_y += _element.get_height() + 10;
//
//scribble_anim_cycle(0.1, 255, 255);
//var _element = scribble("[cycle,test 2]lower speed, higher saturation, same brightness");
//_element.draw(_x, _y);
//_y += _element.get_height() + 10;

scribble_anim_reset();