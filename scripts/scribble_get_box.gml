/// array scribble_get_box(json, [x], [y], [leftMargin], [topMargin], [rightMargin], [bottomMargin], [xscale], [yscale], [angle]);
/// Sets the relative position of the textbox for a Scribble data structure
///
/// This script returns the positions of each corner of a box that encapsulates the text.
/// It returns an 8-element array. You can use the E_SCRIBBLE_BOX enum to conveniently reference each coordinate.
///
/// @param json             The Scribble data structure to use
/// @param [x]              The x position in the room to draw at. Defaults to 0
/// @param [y]              The y position in the room to draw at. Defaults to 0
/// @param [leftMargin]     The additional space to add to the left-hand side of the box. Positive values create more space. Defaults to 0
/// @param [topMargin]      The additional space to add to the top of the box. Positive values create more space. Defaults to 0
/// @param [rightMargin]    The additional space to add to the right-hand side of the box. Positive values create more space. Defaults to 0
/// @param [bottomMargin]   The additional space to add to the bottom of the box. Positive values create more space. Defaults to 0
/// @param [xscale]         The horizontal scaling of the text. Defaults to the value set in __scribble_config()
/// @param [yscale]         The vertical scaling of the text. Defaults to the value set in __scribble_config()
/// @param [angle]          The rotation of the text. Defaults to the value set in __scribble_config()
///
/// All optional arguments accept <undefined> to indicate that the default value should be used.

var _json   = argument[0];
var _x      = 0;
var _y      = 0;
var _left   = 0;
var _top    = 0;
var _right  = 0;
var _bottom = 0;
var _xscale = SCRIBBLE_DEFAULT_XSCALE;
var _yscale = SCRIBBLE_DEFAULT_YSCALE;
var _angle  = SCRIBBLE_DEFAULT_ANGLE;

switch (argument_count){
    case 10:
        if ( argument[9] != undefined ) _angle = argument[9];
    case 9:
        if ( argument[8] != undefined ) _yscale = argument[8];
    case 8:
        if ( argument[7] != undefined ) _xscale = argument[7];
    case 7:
        if ( argument[6] != undefined ) _bottom = argument[6];
    case 6:
        if ( argument[5] != undefined ) _right = argument[5];
    case 5:
        if ( argument[4] != undefined ) _top = argument[4];
    case 4:
        if ( argument[3] != undefined ) _left = argument[3];
    case 3:
        if ( argument[2] != undefined ) _y = argument[2];
    case 2:
        if ( argument[1] != undefined ) _x = argument[1];
        break;
}

if ( !is_real( _json ) || !ds_exists( _json, ds_type_list ) ) {
    show_error( "Scribble data structure " + string( _json ) + " doesn't exist!", false );
    exit;
}

if ((_xscale == 1) && (_yscale == 1) && (_angle == 0)) {
    //Avoid using matrices if we can
    var _l = _x + _json[| __E_SCRIBBLE.LEFT   ] - _left;
    var _t = _y + _json[| __E_SCRIBBLE.TOP    ] - _top;
    var _r = _x + _json[| __E_SCRIBBLE.RIGHT  ] + _right;
    var _b = _y + _json[| __E_SCRIBBLE.BOTTOM ] + _bottom;
    
    return array_compose( _l, _t,
             _r, _t,
             _l, _b,
             _r, _b );
}

//var _matrix = matrix_build( _x,_y,0,   0,0,_angle,   _xscale,_yscale,1 );

var _l = _json[| __E_SCRIBBLE.LEFT   ] - _left;
var _t = _json[| __E_SCRIBBLE.TOP    ] - _top;
var _r = _json[| __E_SCRIBBLE.RIGHT  ] + _right;
var _b = _json[| __E_SCRIBBLE.BOTTOM ] + _bottom;

// gms1 makes us do this the hard way

d3d_transform_set_rotation_z( _angle );
d3d_transform_add_scaling( _xscale, _yscale, 1);
d3d_transform_add_translation( _x, _y, 0);

var _result = array_create(8);
var _vertex = d3d_transform_vertex( _l, _t, 0 ); _result[E_SCRIBBLE_BOX.X0] = _vertex[0]; _result[E_SCRIBBLE_BOX.Y0] = _vertex[1];
var _vertex = d3d_transform_vertex( _r, _t, 0 ); _result[E_SCRIBBLE_BOX.X1] = _vertex[0]; _result[E_SCRIBBLE_BOX.Y1] = _vertex[1];
var _vertex = d3d_transform_vertex( _l, _b, 0 ); _result[E_SCRIBBLE_BOX.X2] = _vertex[0]; _result[E_SCRIBBLE_BOX.Y2] = _vertex[1];
var _vertex = d3d_transform_vertex( _r, _b, 0 ); _result[E_SCRIBBLE_BOX.X3] = _vertex[0]; _result[E_SCRIBBLE_BOX.Y3] = _vertex[1];

d3d_transform_set_identity();

return _result;
