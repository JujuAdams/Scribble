/// @param element      Text element to target. This element must have been created previously by scribble_draw()
/// @param soundArray   Array of sound assets that can be used for playback
/// @param minPitch
/// @param maxPitch
/// 
/// It's quite common in games with typewriter-style text animations to have a "mumble" or "gibberish" sound effect
/// that plays whilst text is being revealed. This function allows you to define an array of sound effects that will
/// be randomly played as text is revealed.

var _element   = argument0;
var _sound     = argument1;
var _min_pitch = argument2;
var _max_pitch = argument3;

if (!is_array(_sound)) _sound = [_sound];

_element[@ SCRIBBLE.AUTOTYPE_SOUND_ARRAY    ] = _sound;
_element[@ SCRIBBLE.AUTOTYPE_SOUND_OVERLAP  ] = 0;
_element[@ SCRIBBLE.AUTOTYPE_SOUND_PER_CHAR ] = true;
_element[@ SCRIBBLE.AUTOTYPE_SOUND_MIN_PITCH] = _min_pitch;
_element[@ SCRIBBLE.AUTOTYPE_SOUND_MAX_PITCH] = _max_pitch;