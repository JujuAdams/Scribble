/// 
/// 
/// Returns: The typewriter state.
/// @param textElement   A text element returned by scribble_draw()

var _scribble_array = argument0;

var _in_tw_method = _scribble_array[__SCRIBBLE.AUTOTYPE_METHOD];
if (_in_tw_method == SCRIBBLE_TYPEWRITER_NONE)
{
        _in_tw_method     = global.scribble_state_tw_method;
    var _in_tw_position   = global.scribble_state_tw_position;
    var _in_tw_smoothness = global.scribble_state_tw_smoothness;
}
else
{
    var _in_tw_position   = _scribble_array[__SCRIBBLE.AUTOTYPE_POSITION  ];
    var _in_tw_smoothness = _scribble_array[__SCRIBBLE.AUTOTYPE_SMOOTHNESS];
}

switch(_in_tw_method)
{
    case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
        var _typewriter_count      = _scribble_array[__SCRIBBLE.CHARACTERS];
        var _typewriter_smoothness = max(0, _in_tw_smoothness/_typewriter_count);
        var _typewriter_t          = clamp(_in_tw_position/_typewriter_count, 0, 1 + _typewriter_smoothness);
    break;
    
    case SCRIBBLE_TYPEWRITER_PER_LINE:
        var _typewriter_count      = _scribble_array[__SCRIBBLE.LINES];
        var _typewriter_smoothness = max(0, _in_tw_smoothness/_typewriter_count);
        var _typewriter_t          = clamp(_in_tw_position/_typewriter_count, 0, 1 + _typewriter_smoothness);
    break;
    
    default:
        var _typewriter_count      = 1;
        var _typewriter_t          = 1;
        var _typewriter_smoothness = 0;
    break;
}

return _typewriter_t;