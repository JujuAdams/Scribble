draw_text(10, 10, animation_speed);

var _x = 10;
var _y = 50;

var _element = scribble("[wave]wavy text wavy text wavy text");
_element.animation_speed(animation_speed);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[shake]shaky text shaky text shaky text");
_element.animation_speed(animation_speed);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[wobble]wobbly text wobbly text wobbly text");
_element.animation_speed(animation_speed);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[pulse]pulsing text pulsing text pulsing text");
_element.animation_speed(animation_speed);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[wheel]wheely text wheely text wheely text");
_element.animation_speed(animation_speed);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[jitter]jittery text jittery text jittery text");
_element.animation_speed(animation_speed);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[blink]blinky text blinky text blinky text");
_element.animation_speed(animation_speed);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[rainbow]rainbow text rainbow text rainbow text");
_element.animation_speed(animation_speed);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _element = scribble("[cycle, 200, 140, 190, 150]cycling text cycling text cycling text");
_element.animation_speed(animation_speed);
_element.draw(_x, _y);
_y += _element.get_height() + 10;