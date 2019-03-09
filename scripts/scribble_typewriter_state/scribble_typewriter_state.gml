/// @param json
///
/// 0 = State      : Text not yet faded in
/// 0 < State < 1  : Text is fading in
/// 1 = State      : Text fully visible
/// 1 < State < 2  : Text is fading out
/// 2 = State      : Text fully faded out

var _json = argument0;

switch( _json[? "typewriter method" ] )
{
    case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
        return _json[? "char fade t" ];
    break;
    
    case SCRIBBLE_TYPEWRITER_PER_LINE:
        return _json[? "line fade t" ];
    break;
}

return undefined;