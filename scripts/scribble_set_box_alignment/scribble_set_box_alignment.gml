/// Sets the relative position of the textbox for a Scribble data structure
///
/// Scribble text is drawn at a position inside an invisible box. By default, the relative position
/// of that box to the draw coordinate is such that the top-left corner of the box is at the
/// draw coordinate. This script allows you to change that behaviour e.g. drawing the box
/// centred on the draw coordinate.
///
/// @param json       The Scribble data structure to manipulate. See scribble_create()
/// @param [halign]   The horizontal alignment of the textbox. Defaults to the value set in __scribble_config()
/// @param [valign]   The vertical alignment of the textbox. Defaults to the value set in __scribble_config()
///
/// All optional arguments accept <undefined> to indicate that the default value should be used.

var _json   = argument[0];
var _halign = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : SCRIBBLE_DEFAULT_BOX_HALIGN;
var _valign = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : SCRIBBLE_DEFAULT_BOX_VALIGN;

if ( !is_real(_json) || !ds_exists(_json, ds_type_list) )
{
    show_error("Scribble data structure \"" + string(_json) + "\" doesn't exist!\n ", false);
    exit;
}

var _width  = _json[| __E_SCRIBBLE.WIDTH  ];
var _height = _json[| __E_SCRIBBLE.HEIGHT ];
_json[| __E_SCRIBBLE.HALIGN ] = _halign;
_json[| __E_SCRIBBLE.VALIGN ] = _valign;

//Horizontal justification
if (_halign == fa_left)
{
    _json[| __E_SCRIBBLE.LEFT  ] = 0;
    _json[| __E_SCRIBBLE.RIGHT ] = _width;
}
else if (_halign == fa_center)
{
    _json[| __E_SCRIBBLE.LEFT  ] = -_width div 2;
    _json[| __E_SCRIBBLE.RIGHT ] =  _width div 2;
}
else if (_halign == fa_right)
{
    _json[| __E_SCRIBBLE.LEFT  ] = -_width;
    _json[| __E_SCRIBBLE.RIGHT ] = 0;
}

//Vertical justification
if (_valign == fa_top)
{
    _json[| __E_SCRIBBLE.TOP    ] = 0;
    _json[| __E_SCRIBBLE.BOTTOM ] = _height;
}
else if (_valign == fa_middle)
{
    _json[| __E_SCRIBBLE.TOP    ] = -_height div 2;
    _json[| __E_SCRIBBLE.BOTTOM ] =  _height div 2;
}
else if (_valign == fa_bottom)
{
    _json[| __E_SCRIBBLE.TOP    ] = -_height;
    _json[| __E_SCRIBBLE.BOTTOM ] = 0;
}