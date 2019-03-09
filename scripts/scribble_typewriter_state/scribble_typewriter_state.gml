/// @param json

var _json = argument0;

switch( _json[? "typewriter method" ] )
{
    case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
        if ( _json[? "typewriter direction" ] > 0 )
        {
            return _json[? "char fade t" ];
        }
        else if ( _json[? "typewriter direction" ] < 0 )
        {
            return 1 - _json[? "char fade t" ];
        }
    break;
    
    case SCRIBBLE_TYPEWRITER_PER_LINE:
        if ( _json[? "typewriter direction" ] > 0 )
        {
            return _json[? "line fade t" ];
        }
        else if ( _json[? "typewriter direction" ] < 0 )
        {
            return 1 - _json[? "line fade t" ];
        }
    break;
}

return undefined;