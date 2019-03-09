/// @param json

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