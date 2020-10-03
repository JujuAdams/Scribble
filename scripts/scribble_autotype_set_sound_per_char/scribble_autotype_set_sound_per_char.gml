/// @param string/textElement   Text element to target. This element must have been created previously by scribble_draw()
/// @param soundArray           Array of sound assets that can be used for playback
/// @param minPitch             Minimum pitch that a sound asset can be played at. See audio_sound_pitch()
/// @param maxPitch             Maximum pitch that a sound asset can be played at. See audio_sound_pitch()
/// @param [occurrenceName]      Unique identifier to differentiate particular occurrences of a string within the game
/// 
/// It's quite common in games with typewriter-style text animations to have a "mumble" or "gibberish" sound effect
/// that plays whilst text is being revealed. This function allows you to define an array of sound effects that will
/// be randomly played as text is revealed.

function scribble_autotype_set_sound_per_char()
{
	var _scribble_array = argument[0];
	var _sound          = argument[1];
	var _min_pitch      = argument[2];
	var _max_pitch      = argument[3];
	var _occurrence_name = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : SCRIBBLE_DEFAULT_OCCURRENCE_NAME;

	var _scribble_array = scribble_cache(_scribble_array, _occurrence_name);
	if (_scribble_array == undefined) return undefined;

	if (!is_array(_sound)) _sound = [_sound];

	//Find our occurrence data
	var _occurrence_map = _scribble_array[SCRIBBLE.OCCURRENCES_MAP];
	var _occurrence_array = _occurrence_map[? _occurrence_name];

	_occurrence_array[@ __SCRIBBLE_OCCURRENCE.SOUND_ARRAY    ] = _sound;
	_occurrence_array[@ __SCRIBBLE_OCCURRENCE.SOUND_OVERLAP  ] = 0;
	_occurrence_array[@ __SCRIBBLE_OCCURRENCE.SOUND_PER_CHAR ] = true;
	_occurrence_array[@ __SCRIBBLE_OCCURRENCE.SOUND_MIN_PITCH] = _min_pitch;
	_occurrence_array[@ __SCRIBBLE_OCCURRENCE.SOUND_MAX_PITCH] = _max_pitch;
}