/// @description SCRIBBLE service initialisation

/*
    Edit this array to add more fonts to the Scribble font renderer.
*/
if ( !SCRIBBLE_AUTO_FONT_INIT ) {
    var _font_array = [ fnt_default, fnt_consolas,
                        fnt_verdana_32, fnt_verdana_32_bold,
                        fnt_tnr_41, fnt_tnr_41_italics ];
}

//------------------------------------------------------------------


vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_texcoord();
vertex_format_add_colour();
vertex_format_add_normal();
global.scribble_font_vertex_format = vertex_format_end();

draw_set_halign( fa_left );
draw_set_valign( fa_top );

var _old_x = x;
var _old_y = y;
var _old_sprite_index = sprite_index;
x = 0;
y = 0;

global.scribble_font_json = ds_map_create();

var _surface = surface_create( SCRIBBLE_SURFACE_SIZE, SCRIBBLE_SURFACE_SIZE );
var _char_surface = surface_create( SCRIBBLE_CHARACTER_SURFACE_SIZE, SCRIBBLE_CHARACTER_SURFACE_SIZE );

surface_set_target( _surface );
    draw_clear_alpha( c_white, 0 );
    gpu_set_blendenable( false );
    draw_set_colour( c_white );
    draw_rectangle( 0, 0, 1, 1, false );
    draw_set_alpha( 1 );
    gpu_set_blendenable( true );
surface_reset_target();

var _surf_x           = 2 + SCRIBBLE_CHAR_PADDING;
var _surf_y           = 0;
var _surf_line_height = 2 + SCRIBBLE_CHAR_PADDING;

var _char_max_w = 0;
var _char_max_h = 0;

if ( SCRIBBLE_AUTO_FONT_INIT ) {
    trace( "Automatically scanning for fonts" );
    _font_array = undefined;
    var _size = 0;
    for( var _i = 0; _i < 1000; _i++ ) if ( font_exists( _i ) ) _font_array[ _size++ ] = _i;
}
  
var _font_count = array_length_1d( _font_array );
for( var _i = 0; _i < _font_count; _i++ ) {
    
    var _font = _font_array[_i];
    var _font_map = ds_map_create();
    ds_map_add_map( global.scribble_font_json, _font, _font_map );
    _font_map[? "name" ] = font_get_name( _font );
        
    var _uvs = undefined;
    // 0 = bbox left relative to draw position
    // 1 = bbox top relative to draw position
    // 2 = bbox right relative to draw position
    // 3 = bbox bottom relative to draw position
    // 4 = bbox width
    // 5 = bbox height
    // 6 = x on texture page
    // 7 = y on texture page
    // 8 = string_width of character
    // 9 = string_height of character
    
    draw_set_font( _font );
    
    for( var _index = 0; _index < SCRIBBLE_FONT_CHAR_SIZE; _index++ ) {
        
        var _ord = _index + SCRIBBLE_FONT_CHAR_MIN;
        var _char = chr( _ord );
        
        var _char_w = string_width( _char );
        var _char_h = string_height( _char );
        
        surface_set_target( _char_surface );
            gpu_set_blendenable( false );
            draw_clear_alpha( c_white, 0 );
            draw_text( SCRIBBLE_CHAR_PADDING, SCRIBBLE_CHAR_PADDING, _char );
            gpu_set_blendenable( true );
        surface_reset_target();
        
        sprite_index = sprite_create_from_surface( _char_surface, 0, 0, SCRIBBLE_CHARACTER_SURFACE_SIZE, SCRIBBLE_CHARACTER_SURFACE_SIZE, false, false, SCRIBBLE_CHAR_PADDING, SCRIBBLE_CHAR_PADDING );
        sprite_collision_mask( sprite_index, false,   0, 0,0,0,0,   0, 2 );
        
        var _l = bbox_left;
        var _t = bbox_top;
        var _r = bbox_right;
        var _b = bbox_bottom;
        if ( _l < 0 ) && ( _t < 0 ) && ( _b < 0 ) && ( _t < 0 ) {
            _l = SCRIBBLE_CHAR_PADDING + _char_w;
            _t = SCRIBBLE_CHAR_PADDING + _char_h;
            _r = _l;
            _b = _t;
        }
        _r++;
        _b++;
        
        var _w = _r - _l;
        var _h = _b - _t;
        _char_max_w = max( _char_max_w, _w );
        _char_max_h = max( _char_max_h, _h );
        
        _uvs[ _index, E_SCRIBBLE.L ] = _l;
        _uvs[ _index, E_SCRIBBLE.T ] = _t;
        _uvs[ _index, E_SCRIBBLE.R ] = _r;
        _uvs[ _index, E_SCRIBBLE.B ] = _b;
        _uvs[ _index, E_SCRIBBLE.W ] = _w;
        _uvs[ _index, E_SCRIBBLE.H ] = _h;
        
        if ( _surf_x + _w + SCRIBBLE_CHAR_PADDING >= SCRIBBLE_SURFACE_SIZE ) {
            _surf_x = 0;
            _surf_y += _surf_line_height;
            _surf_line_height = 0;
        }
        
        _uvs[ _index, E_SCRIBBLE.X ] = _surf_x;
        _uvs[ _index, E_SCRIBBLE.Y ] = _surf_y;
        _uvs[ _index, E_SCRIBBLE.KERN_W ] = _char_w;
        _uvs[ _index, E_SCRIBBLE.KERN_H ] = _char_h;
        
        surface_set_target( _surface );
            gpu_set_blendenable( false );
            draw_set_colour( c_white );
            draw_sprite_part( sprite_index, 0,
                              SCRIBBLE_CHAR_PADDING + _l, SCRIBBLE_CHAR_PADDING + _t,
                              SCRIBBLE_CHAR_PADDING + _r, SCRIBBLE_CHAR_PADDING + _b,
                              _surf_x, _surf_y );
            draw_set_alpha( 1 );
            gpu_set_blendenable( true );
        surface_reset_target();
        
        sprite_delete( sprite_index );
        
        _surf_x += _w + SCRIBBLE_CHAR_PADDING;
        _surf_line_height = max( _surf_line_height, _h + SCRIBBLE_CHAR_PADDING );
        
    }
    
    _font_map[? "uvs" ] = _uvs;
    
    if ( SCRIBBLE_OUTPUT_MAXIMUM_CHAR_SIZE ) trace( QU, font_get_name( _font ), QU, " max char size=", _char_max_w, "x", _char_max_h );
    
}

global.scribble_sprite  = sprite_create_from_surface( _surface, 0, 0, SCRIBBLE_SURFACE_SIZE, SCRIBBLE_SURFACE_SIZE, false, false, 0, 0 );
global.scribble_texture = sprite_get_texture( global.scribble_sprite, 0 );

surface_free( _surface );
surface_free( _char_surface );

x = _old_x;
y = _old_y;
sprite_index = _old_sprite_index;

draw_reset();