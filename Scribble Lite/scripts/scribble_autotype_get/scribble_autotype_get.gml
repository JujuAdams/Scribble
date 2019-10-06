/// Returns: The text element's autotype state (see below)
/// @param textElement   A text element returned by scribble_draw()
/// 
/// The autotype state is a real value as follows:
///     state < 0   Autotype not set
///     state = 0   Not yet faded in, invisible
/// 0 < state < 1   Fading in
///     state = 1   Fully visible
/// 1 < state < 2   Fading out
///     state = 2   Fully faded out, invisible

var _scribble_array = argument0;

//Return an error code if the method is NONE
var _typewriter_method = _scribble_array[__SCRIBBLE.AUTOTYPE_METHOD];
if (_typewriter_method == SCRIBBLE_TYPEWRITER_NONE) return -1;

//Return an error code if the fade in state has not been set
//(The fade in state is initialised as -1)
var _typewriter_fade_in = _scribble_array[__SCRIBBLE.AUTOTYPE_FADE_IN];
if (_scribble_array[__SCRIBBLE.AUTOTYPE_FADE_IN] < 0) return -2;

switch(_typewriter_method)
{
    case SCRIBBLE_TYPEWRITER_PER_CHARACTER: var _typewriter_count = _scribble_array[__SCRIBBLE.CHARACTERS]; break;
    case SCRIBBLE_TYPEWRITER_PER_LINE:      var _typewriter_count = _scribble_array[__SCRIBBLE.LINES     ]; break;
}

//Normalise the parameter from 0 -> 1 using the total counter
var _typewriter_t = clamp(_scribble_array[__SCRIBBLE.AUTOTYPE_POSITION]/_typewriter_count, 0, 1);

//Add one if we're fading out
return _typewriter_fade_in? _typewriter_t : (_typewriter_t+1);