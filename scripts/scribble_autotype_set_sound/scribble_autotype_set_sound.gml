/// @param string/textElement   Text element to target. This element must have been created previously by scribble_draw()
/// @param soundArray           Array of sound assets that can be used for playback
/// @param overlap              Amount of overlap between sound effect playback, in milliseconds
/// @param minPitch             Minimum pitch that a sound asset can be played at. See audio_sound_pitch()
/// @param maxPitch             Maximum pitch that a sound asset can be played at. See audio_sound_pitch()
/// @param [occuranceName]      Unique identifier to differentiate particular occurances of a string within the game
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

function scribble_autotype_set_sound()
{
	var _scribble_array = argument[0];
	var _sound          = argument[1];
	var _overlap        = argument[2];
	var _min_pitch      = argument[3];
	var _max_pitch      = argument[4];
	var _occurance_name = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : SCRIBBLE_DEFAULT_OCCURANCE_NAME;

	var _scribble_array = scribble_cache(_scribble_array, _occurance_name);
	if (_scribble_array == undefined) return undefined;

	if (!is_array(_sound)) _sound = [_sound];

	//Find our occurance data
	var _occurance_map = _scribble_array[SCRIBBLE.OCCURANCES_MAP];
	var _occurance_array = _occurance_map[? _occurance_name];

	_occurance_array[@ __SCRIBBLE_OCCURANCE.SOUND_ARRAY    ] = _sound;
	_occurance_array[@ __SCRIBBLE_OCCURANCE.SOUND_OVERLAP  ] = _overlap;
	_occurance_array[@ __SCRIBBLE_OCCURANCE.SOUND_MIN_PITCH] = _min_pitch;
	_occurance_array[@ __SCRIBBLE_OCCURANCE.SOUND_MAX_PITCH] = _max_pitch;
}