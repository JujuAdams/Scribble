/// @param json
/// @param [x]
/// @param [y]
/// @param [leftMargin]
/// @param [topMargin]
/// @param [rightMargin]
/// @param [bottomMargin]
/// @param [xscale]
/// @param [yscale]
/// @param [angle]

var _json   = argument[0];
var _x      = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : 0;
var _y      = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : 0;
var _left   = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : 0;
var _top    = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : 0;
var _right  = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : 0;
var _bottom = ((argument_count > 6) && (argument[6] != undefined))? argument[6] : 0;
var _xscale = ((argument_count > 7) && (argument[7] != undefined))? argument[7] : SCRIBBLE_DEFAULT_XSCALE;
var _yscale = ((argument_count > 8) && (argument[8] != undefined))? argument[8] : SCRIBBLE_DEFAULT_YSCALE;
var _angle  = ((argument_count > 9) && (argument[9] != undefined))? argument[9] : SCRIBBLE_DEFAULT_ANGLE;

if ( !is_real( _json ) || !ds_exists( _json, ds_type_list ) )
{
    show_error( "Scribble data structure \"" + string( _json ) + "\" doesn't exist!\n ", false );
    exit;
}

if ((_xscale == 1) && (_yscale == 1) && (_angle == 0))
{
    //Avoid using matrices if we can
    var _l = _x + _json[| __E_SCRIBBLE.LEFT   ] - _left;
    var _t = _y + _json[| __E_SCRIBBLE.TOP    ] - _top;
    var _r = _x + _json[| __E_SCRIBBLE.RIGHT  ] + _right;
    var _b = _y + _json[| __E_SCRIBBLE.BOTTOM ] + _bottom;
    
    return [ _l, _t,
             _r, _t,
             _l, _b,
             _r, _b ];
}

var _matrix = matrix_build( _x,_y,0,   0,0,_angle,   _xscale,_yscale,1 );

var _l = _json[| __E_SCRIBBLE.LEFT   ] - _left;
var _t = _json[| __E_SCRIBBLE.TOP    ] - _top;
var _r = _json[| __E_SCRIBBLE.RIGHT  ] + _right;
var _b = _json[| __E_SCRIBBLE.BOTTOM ] + _bottom;

var _result = array_create(8);
var _vertex = matrix_transform_vertex( _matrix, _l, _t, 0 ); _result[0] = _vertex[0]; _result[1] = _vertex[1];
var _vertex = matrix_transform_vertex( _matrix, _r, _t, 0 ); _result[2] = _vertex[0]; _result[3] = _vertex[1];
var _vertex = matrix_transform_vertex( _matrix, _l, _b, 0 ); _result[4] = _vertex[0]; _result[5] = _vertex[1];
var _vertex = matrix_transform_vertex( _matrix, _r, _b, 0 ); _result[6] = _vertex[0]; _result[7] = _vertex[1];

return _result;