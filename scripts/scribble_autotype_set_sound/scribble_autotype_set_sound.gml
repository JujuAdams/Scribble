/// @param element
/// @param sound{array}
/// @param overlap{ms}

var _element = argument0;
var _sound   = argument1;
var _overlap = argument2;

if (!is_array(_sound)) _sound = [_sound];

_element[@ __SCRIBBLE.AUTOTYPE_SOUND_ARRAY  ] = _sound;
_element[@ __SCRIBBLE.AUTOTYPE_SOUND_OVERLAP] = _overlap;