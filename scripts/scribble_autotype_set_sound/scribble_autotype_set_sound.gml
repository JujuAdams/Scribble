/// @param element      Text element to target. This element must have been created previously by scribble_draw()
/// @param soundArray   Array of sound assets that can be used for playback
/// @param overlap      Amount of overlap between sound effect playback, in milliseconds
/// 
/// It's quite common in games with typewriter-style text animations to have a "mumble" or "gibberish" sound effect
/// that plays whilst text is being revealed. This function allows you to define an array of sound effects that will
/// be randomly played as text is revealed.
/// 
/// Setting the overlap value to 0 will ensure that sound effects never overlap at all, which is generally what's
/// desirable, but it can sound a bit stilted and unnatural. By setting the overlap argument to a number above 0,
/// sound effects will be played with a little bit of overlap which improves the effect considerably. A value around
/// 30ms usually sounds ok. The overlap argument can be set to a value less than 0 if you'd like more space between
/// sound effects.

var _element = argument0;
var _sound   = argument1;
var _overlap = argument2;

if (!is_array(_sound)) _sound = [_sound];

_element[@ __SCRIBBLE.AUTOTYPE_SOUND_ARRAY  ] = _sound;
_element[@ __SCRIBBLE.AUTOTYPE_SOUND_OVERLAP] = _overlap;