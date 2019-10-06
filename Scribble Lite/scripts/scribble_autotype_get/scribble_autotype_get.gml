/// 
/// 
/// Returns: The text element's autotype state (see below)
/// @param textElement   A text element returned by scribble_draw()
/// 
/// 

var _scribble_array = argument0;

var _typewriter_method = _scribble_array[__SCRIBBLE.AUTOTYPE_METHOD];
if (_typewriter_method == SCRIBBLE_TYPEWRITER_NONE) return -1;

var _typewriter_fade_in = _scribble_array[__SCRIBBLE.AUTOTYPE_FADE_IN];
if (_scribble_array[__SCRIBBLE.AUTOTYPE_FADE_IN] < 0) return -1;

switch(_typewriter_method)
{
    case SCRIBBLE_TYPEWRITER_PER_CHARACTER: var _typewriter_count = _scribble_array[__SCRIBBLE.CHARACTERS]; break;
    case SCRIBBLE_TYPEWRITER_PER_LINE:      var _typewriter_count = _scribble_array[__SCRIBBLE.LINES     ]; break;
}

var _typewriter_t = clamp(_scribble_array[__SCRIBBLE.AUTOTYPE_POSITION]/_typewriter_count, 0, 1);

return _typewriter_fade_in? _typewriter_t : (_typewriter_t+1);