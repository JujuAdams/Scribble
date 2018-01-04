/// @param  width
/// @param  height
/// @param  scrollbar width
/// @param  scrollbar height
/// @param  colour 
//
//  April 2017
//  Juju Adams
//  julian.adams@email.com
//  @jujuadams
//
//  This code and engine are provided under the Creative Commons "Attribution - NonCommerical - ShareAlike" international license.
//  https://creativecommons.org/licenses/by-nc-sa/4.0/

var _width            = argument0;
var _height           = argument1;
var _scrollbar_width  = argument2;
var _scrollbar_height = argument3;
var _colour           = argument4;

var _scrollbox = ds_map_create();
_scrollbox[? "width"            ] = _width;
_scrollbox[? "height"           ] = _height;
_scrollbox[? "scrollbar width"  ] = _scrollbar_width;
_scrollbox[? "scrollbar height" ] = _scrollbar_height;
_scrollbox[? "colour"           ] = _colour;
_scrollbox[? "surface"          ] = noone;
_scrollbox[? "scroll offset y"  ] = 0;

_scrollbox[? "scrollbar left"   ] = _width - _scrollbar_width;
_scrollbox[? "scrollbar top"    ] = 0;
_scrollbox[? "scrollbar right"  ] = _width;
_scrollbox[? "scrollbar bottom" ] = _scrollbar_height;
_scrollbox[? "scrollbar t"      ] = 0;
_scrollbox[? "scrollbar over"   ] = false;
_scrollbox[? "scrollbar down"   ] = false;
_scrollbox[? "scrollbar down y" ] = 0;

return _scrollbox;
