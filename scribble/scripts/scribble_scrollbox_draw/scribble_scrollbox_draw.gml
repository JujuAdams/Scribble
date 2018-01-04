/// @param  x
/// @param  y
/// @param  scrollbox json
/// @param  text json 
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

var _old_colour = draw_get_colour();

var _width            = _scroll_json[? "width"            ];
var _height           = _scroll_json[? "height"           ];
var _scrollbar_width  = _scroll_json[? "scrollbar width"  ];
var _scrollbar_height = _scroll_json[? "scrollbar height" ];
var _surface          = _scroll_json[? "surface"          ];
var _colour           = _scroll_json[? "colour"           ];

var _scrollbar_left   = _scroll_json[? "scrollbar left"   ];
var _scrollbar_top    = _scroll_json[? "scrollbar top"    ];
var _scrollbar_right  = _scroll_json[? "scrollbar right"  ];
var _scrollbar_bottom = _scroll_json[? "scrollbar bottom" ];
var _scrollbar_t      = _scroll_json[? "scrollbar t"      ];
var _scrollbar_down   = _scroll_json[? "scrollbar down"   ];

if ( _text_json >= 0 ) {
    var _scroll_distance = max( 0, _text_json[? "height" ] - _height );
    if ( _scroll_distance > 0 ) _scroll_distance += 10;
}

if ( !surface_exists( _surface ) ) {
    _surface = tr_surface_create( _width, _height );
    _scroll_json[? "surface" ] = _surface;
}

if ( !surface_exists( _surface ) ) exit;

surface_set_target( _surface );
    
    draw_set_colour( _colour );
    draw_rectangle( 0, 0, _width, _height, false );
    
    draw_set_colour( c_white );
    gpu_set_colourwriteenable( true, true, true, false );
    if ( _text_json >= 0 ) scribble_draw( -_text_json[? "left" ], -_text_json[? "top" ] - _scrollbar_t * _scroll_distance, _text_json, DEFAULT, DEFAULT );
    gpu_set_colourwriteenable( true, true, true, true );
    
    draw_set_colour( c_red );
    draw_rectangle( _width - _scrollbar_width, 0, _width, _height, false );
    
    if ( _scroll_json[? "scrollbar down" ] ) draw_set_colour( merge_colour( c_yellow, c_white, 0.5 ) ) else draw_set_colour( c_yellow );
    var _scrollbar_y = 0;
    var _scrollbar_max_y = _height - _scrollbar_height;
    _scrollbar_y = lerp( 0, _scrollbar_max_y, _scrollbar_t );
    
    draw_rectangle( _scrollbar_left, _scrollbar_top, _scrollbar_right, _scrollbar_bottom, false );
    
surface_reset_target();

draw_surface( _surface, _x, _y );
draw_set_colour( _old_colour );
