/// @param font
/// @param string
/// @param x
/// @param y

var _font   = argument0;
var _string = argument1;
var _x      = argument2;
var _y      = argument3;

var _vbuff = global.__scribble_cache_map[? _font + "~~~~~~~~" + _string ];
if ( _vbuff == undefined ) {
    _vbuff = scribble_basic_make( _font, _string );
    vertex_freeze( _vbuff );
    global.__scribble_cache_map[? _font + "~~~~~~~~" + _string ] = _vbuff;
    show_debug_message( "Cached <" + string_replace_all( _string, "\n", "\\N" ) + "> as vbuff=" + string( _vbuff ) );
}

scribble_basic_draw( _font, _vbuff, _x, _y );