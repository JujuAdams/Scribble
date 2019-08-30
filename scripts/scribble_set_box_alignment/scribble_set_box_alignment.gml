/// Sets the relative position of the textbox for a Scribble data structure
///
/// Scribble text is drawn at a position inside an invisible box. By default, the relative position
/// of that box to the draw coordinate is such that the top-left corner of the box is at the
/// draw coordinate. This script allows you to change that behaviour e.g. drawing the box
/// centred on the draw coordinate.
///
/// @param scribbleArray   The Scribble data structure to manipulate. See scribble_create()
/// @param [halign]        The horizontal alignment of the textbox. Defaults to the value set in __scribble_config()
/// @param [valign]        The vertical alignment of the textbox. Defaults to the value set in __scribble_config()
///
/// All optional arguments accept <undefined> to indicate that the default value should be used.

var _scribble_array = argument[0];
var _halign         = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : SCRIBBLE_DEFAULT_BOX_HALIGN;
var _valign         = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : SCRIBBLE_DEFAULT_BOX_VALIGN;

if (!scribble_exists(_scribble_array))
{
    show_error("Scribble:\nScribble data structure \"" + string(_scribble_array) + "\" doesn't exist!\n ", false);
    exit;
}

var _width  = _scribble_array[__SCRIBBLE.WIDTH ];
var _height = _scribble_array[__SCRIBBLE.HEIGHT];
_scribble_array[@ __SCRIBBLE.HALIGN] = _halign;
_scribble_array[@ __SCRIBBLE.VALIGN] = _valign;

//Horizontal justification
if (_halign == fa_left)
{
    _scribble_array[@ __SCRIBBLE.LEFT ] = 0;
    _scribble_array[@ __SCRIBBLE.RIGHT] = _width;
}
else if (_halign == fa_center)
{
    _scribble_array[@ __SCRIBBLE.LEFT ] = -_width div 2;
    _scribble_array[@ __SCRIBBLE.RIGHT] =  _width div 2;
}
else if (_halign == fa_right)
{
    _scribble_array[@ __SCRIBBLE.LEFT ] = -_width;
    _scribble_array[@ __SCRIBBLE.RIGHT] = 0;
}

//Vertical justification
if (_valign == fa_top)
{
    _scribble_array[@ __SCRIBBLE.TOP   ] = 0;
    _scribble_array[@ __SCRIBBLE.BOTTOM] = _height;
}
else if (_valign == fa_middle)
{
    _scribble_array[@ __SCRIBBLE.TOP   ] = -_height div 2;
    _scribble_array[@ __SCRIBBLE.BOTTOM] =  _height div 2;
}
else if (_valign == fa_bottom)
{
    _scribble_array[@ __SCRIBBLE.TOP   ] = -_height;
    _scribble_array[@ __SCRIBBLE.BOTTOM] = 0;
}