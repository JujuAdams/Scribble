/// @param  x
/// @param  y
/// @param  scrollbox json
/// @param  text json
/// @param  mouse x
/// @param  mouse y
/// @param  destroy if invisible 
//
//  April 2017
//  Juju Adams
//  julian.adams@email.com
//  @jujuadams
//
//  This code and engine are provided under the Creative Commons "Attribution - NonCommerical - ShareAlike" international license.
//  https://creativecommons.org/licenses/by-nc-sa/4.0/

var _x           = argument0;
var _y           = argument1;
var _scroll_json = argument2;
var _text_json   = argument3;
var _mouse_x     = argument4;
var _mouse_y     = argument5;
var _destroy     = argument6;

var _width            = _scroll_json[? "width"            ];
var _height           = _scroll_json[? "height"           ];
var _scrollbar_width  = _scroll_json[? "scrollbar width"  ];
var _scrollbar_height = _scroll_json[? "scrollbar height" ];
var _surface          = _scroll_json[? "surface"          ];

var _scrollbar_left   = _scroll_json[? "scrollbar left"   ] + _x;
var _scrollbar_top    = _scroll_json[? "scrollbar top"    ] + _y;
var _scrollbar_right  = _scroll_json[? "scrollbar right"  ] + _x;
var _scrollbar_bottom = _scroll_json[? "scrollbar bottom" ] + _y;
var _scrollbar_t      = _scroll_json[? "scrollbar t"      ];
var _scrollbar_down   = _scroll_json[? "scrollbar down"   ];
var _scrollbar_down_y = _scroll_json[? "scrollbar down y" ];

var _scrollbar_over = point_in_rectangle( _mouse_x, _mouse_y,   _scrollbar_left, _scrollbar_top, _scrollbar_right, _scrollbar_bottom );
_scroll_json[? "scrollbar over" ] = _scrollbar_over;

if ( _scrollbar_over ) {
    if ( mouse_check_button( mb_left ) && !_scrollbar_down ) {
        _scrollbar_down = true;
        _scrollbar_down_y = _mouse_y - _scrollbar_top;
        _scroll_json[? "scrollbar down y" ] = _scrollbar_down_y;
    } else if ( !mouse_check_button( mb_left ) ) {
        _scrollbar_down = false;
    }
}

if ( !mouse_check_button( mb_left ) ) _scrollbar_down = false;
_scroll_json[? "scrollbar down" ] = _scrollbar_down;

if ( _scrollbar_down ) {
    var _scrollbar_y = clamp( _mouse_y - _scrollbar_down_y - _y, 0, _height - _scrollbar_height );
    _scroll_json[? "scrollbar top"    ] = _scrollbar_y;
    _scroll_json[? "scrollbar bottom" ] = _scrollbar_y + _scrollbar_height;
    _scroll_json[? "scrollbar t"      ] = clamp( _scrollbar_y / ( _height - _scrollbar_height ), 0, 1 );
}

if ( _text_json >= 0 ) {
    
    var _scroll_distance = _scroll_json[? "scrollbar t" ] * max( 0, _text_json[? "height" ] - _height );
    if ( !point_in_rectangle( _mouse_x, _mouse_y,    _x, _y, _x + _width, _y + _height ) ) {
        _mouse_x = -99999999;
        _mouse_u = -99999999;
    }
    
    _text_json = scribble_step( _x - _text_json[? "left" ], _y - _text_json[? "top" ] - _scroll_distance, _text_json, _mouse_x, _mouse_y, _destroy );
    
}

if ( _text_json < 0 ) {
    _scroll_json[? "scrollbar top"    ] = 0;
    _scroll_json[? "scrollbar bottom" ] = _scrollbar_height;
    _scroll_json[? "scrollbar t"      ] = 0;
    return noone;
}

return _text_json;