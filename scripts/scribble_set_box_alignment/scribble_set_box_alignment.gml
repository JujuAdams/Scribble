/// @description Sets the alignment of a Scribble JSON
///              Pass in no additional arguments to reset the Scribble alignment to left+top
/// @param json
/// @param [halign]
/// @param [valign]

var _json   = argument[0];
var _halign = ((argument_count<2) || (argument[1]==undefined))? fa_left : argument[1];
var _valign = ((argument_count<3) || (argument[2]==undefined))? fa_top  : argument[2];

if ( !is_real( _json ) || !ds_exists( _json, ds_type_list ) )
{
    show_error( "Scribble data structure \"" + string( _json ) + "\" doesn't exist!\n ", false );
    exit;
}

var _width  = _json[| __E_SCRIBBLE.WIDTH  ];
var _height = _json[| __E_SCRIBBLE.HEIGHT ];
_json[| __E_SCRIBBLE.HALIGN ] = _halign;
_json[| __E_SCRIBBLE.VALIGN ] = _valign;

//Horizontal justification
if ( _halign == fa_left )
{
    _json[| __E_SCRIBBLE.LEFT  ] = 0;
    _json[| __E_SCRIBBLE.RIGHT ] = _width;
}
else if ( _halign == fa_center )
{
    _json[| __E_SCRIBBLE.LEFT  ] = -_width div 2;
    _json[| __E_SCRIBBLE.RIGHT ] =  _width div 2;
}
else if ( _halign == fa_right )
{
    _json[| __E_SCRIBBLE.LEFT  ] = -_width;
    _json[| __E_SCRIBBLE.RIGHT ] = 0;
}

//Vertical justification
if ( _valign == fa_top )
{
    _json[| __E_SCRIBBLE.TOP    ] = 0;
    _json[| __E_SCRIBBLE.BOTTOM ] = _height;
}
else if ( _valign == fa_middle )
{
    _json[| __E_SCRIBBLE.TOP    ] = -_height div 2;
    _json[| __E_SCRIBBLE.BOTTOM ] =  _height div 2;
}
else if ( _valign == fa_bottom )
{
    _json[| __E_SCRIBBLE.TOP    ] = -_height;
    _json[| __E_SCRIBBLE.BOTTOM ] = 0;
}