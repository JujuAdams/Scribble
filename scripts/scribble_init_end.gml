/// void scribble_init_end();
/// Completes initialisation for Scribble
/// This script should be called after scribble_init_start() and scribble_init_font() / scribble_init_spritefont()
///
/// This script achieves the following things:
/// 1) Works out if we need GMS2.2.1+ fixes
/// 2) Packs fonts onto surfaces so we can draw glyphs more easily and more efficiently
/// 3) Process glyph data from .yy files and store it in lots of data structures
///
/// Once this script has been run, Scribble is ready for use!

var _timer = get_timer();

if ( global.__scribble_init_complete == SCRIBBLE_INIT_START ) {
    show_error( "scribble_init_end() should be called after scribble_init_start()", false );
    exit;
}

show_debug_message( "Scribble: Font initialisation started" );

var _old_x = x;
var _old_y = y;
var _old_image_xscale = image_xscale;
var _old_image_yscale = image_yscale;
var _old_mask_index   = mask_index;
x = 0;
y = 0;
image_xscale = 1;
image_yscale = 1;

var _surface_array  = array_create(0);
var _priority_queue = ds_priority_create();

// the runtime version isn't available in GMS1 afaik so if you're not using 1.4.9999 ¯\_(ツ)_/¯

var _in_gms221 = true;

/*
 * Work out if we're in version 2.2.1 or later
 *
 * var _string = GM_runtime_version;
 *
 * var _major = string_copy( _string, 1, string_pos( ".", _string )-1 );
 * _string = string_delete( _string, 1, string_pos( ".", _string ) );
 *
 * var _minor = string_copy( _string, 1, string_pos( ".", _string )-1 );
 * _string = string_delete( _string, 1, string_pos( ".", _string ) );
 *
 * var _patch = string_copy( _string, 1, string_pos( ".", _string )-1 );
 *
 * //var _rev = string_delete( _string, 1, string_pos( ".", _string ) );
 *
 * var _in_gms221 = ( (real( _major ) >= 2) && (real( _minor ) >= 2) && (real( _patch ) >= 1) );
 * if ( _in_gms221 ) show_debug_message( "Scribble: Using legacy (GMS2.2.0 and prior) compatibility mode" );
 */

// Iterate over the font data global ds_map and prioritise fonts that we need to pack onto surfaces

var _font_count = ds_map_size( global.__scribble_font_data );
var _font_array = array_create( _font_count );

var _i = 0;
var _name = ds_map_find_first( global.__scribble_font_data );
repeat( _font_count ) {
    _font_array[ _i ] = _name;
    
    //If this is a standard font, grab the texture dimensions
    var _font_data = global.__scribble_font_data[? _name ];
    if ( _font_data[ __E_SCRIBBLE_FONT.TYPE ] == asset_sprite ) {
        show_debug_message( "Scribble: Found spritefont " + _name );
    } else if ( _font_data[ __E_SCRIBBLE_FONT.TYPE ] ) {
        var _asset = asset_get_index(  _name  );
        if ( _asset < 0 ) {
            show_error( "Font " + _name + " was not found in the project!", true );
            exit;
        }
        
        var _texture = font_get_texture( _asset );
        var _uvs     = font_get_uvs(     _asset );
        
        var _texture_w = (_uvs[2] - _uvs[0]) / texture_get_texel_width(  _texture );
        var _texture_h = (_uvs[3] - _uvs[1]) / texture_get_texel_height( _texture );
        _font_data[@ __E_SCRIBBLE_FONT.TEXTURE_WIDTH  ] = _texture_w;
        _font_data[@ __E_SCRIBBLE_FONT.TEXTURE_HEIGHT ] = _texture_h;
        
        var _json_file  = global.__scribble_font_directory + _name + ".yy";
        if ( !file_exists( _json_file ) ) {
            show_error( "Scribble: Could not find " + _json_file + " in Included Files. Please add this file to your project.", false );
            continue;
        }
        
        if ( _font_data[ __E_SCRIBBLE_FONT.TEXTURE_WIDTH  ] > global.__scribble_texture_page_size )
        || ( _font_data[ __E_SCRIBBLE_FONT.TEXTURE_HEIGHT ] > global.__scribble_texture_page_size ) {
            show_debug_message( "Scribble: WARNING! The texture for " + _name + " is larger than Scribble's maximum texture page size (" + string( _texture_w ) + "x" + string( _texture_h ) + " > " + string( global.__scribble_texture_page_size ) + "x" + string( global.__scribble_texture_page_size ) + ")" );
            var _bigger_size = power(2,ceil(ln(max( _texture_w, _texture_h ))/ln(2)));
            show_debug_message( "Scribble:          Please use a larger texture page size in Scribble and GameMaker (e.g. " + string( _bigger_size ) + "x" + string( _bigger_size ) + ") to avoid bugs and blurry text" );
        }
        
        var _priority = _texture_h*global.__scribble_texture_page_size + _texture_w;
        ds_priority_add( _priority_queue, _name, _priority );
        show_debug_message( "Scribble: Queuing " + _name + " for packing (size=" + string( _texture_w ) + "x" + string( _texture_h ) + ", weight=" + string( _priority ) + ")" );
    }
    
    _name = ds_map_find_next( global.__scribble_font_data, _name );
    _i++;
}

// Figure out where to place the fonts

show_debug_message( "Scribble: " + string( ds_priority_size( _priority_queue ) ) + " font(s) to pack" );

while( !ds_priority_empty( _priority_queue ) ) {
    var _name = ds_priority_delete_max( _priority_queue );
    var _font_data = global.__scribble_font_data[? _name ];
    var _texture_w = _font_data[ __E_SCRIBBLE_FONT.TEXTURE_WIDTH  ];
    var _texture_h = _font_data[ __E_SCRIBBLE_FONT.TEXTURE_HEIGHT ];
    
    show_debug_message( "Scribble: Packing " + _name + " (size=" + string( _texture_w ) + "," + string( _texture_h ) + ")" );
    
    var _found = false;
    var _surface_count = array_length_1d( _surface_array );
    for( var _s = 0; _s < _surface_count; _s++ ) {
        var _surface_data   = _surface_array[ _s ];
        var _surface_w      = _surface_data[ __E_SCRIBBLE_SURFACE.WIDTH  ];
        var _surface_h      = _surface_data[ __E_SCRIBBLE_SURFACE.HEIGHT ];
        var _surface_fonts  = _surface_data[ __E_SCRIBBLE_SURFACE.FONTS  ];
        var _surface_locked = _surface_data[ __E_SCRIBBLE_SURFACE.LOCKED ];
        
        if ( _surface_locked ) continue; //Ignore "locked" surfaces
        
        // Scan to the right of each font texture to try to find a free spot
        
        var _surface_fonts_count = array_length_1d( _surface_fonts );
        for( var _f = 0; _f < _surface_fonts_count; _f++ ) {
            var _target_name = _surface_fonts[_f];
            var _target_data = global.__scribble_font_data[? _target_name ];
            
            var _l = _target_data[ __E_SCRIBBLE_FONT.SPRITE_X ] + _target_data[ __E_SCRIBBLE_FONT.TEXTURE_WIDTH ];
            var _t = _target_data[ __E_SCRIBBLE_FONT.SPRITE_Y ];
            var _r = _l + _texture_w - 1;
            var _b = _t + _texture_h - 1;
                
            if (_r >= global.__scribble_texture_page_size) || (_b >= global.__scribble_texture_page_size) {
                _found = false;
                continue;
            }
            
            _found = true;
            for( var _g = 0; _g < _surface_fonts_count; _g++ ) {
                var _check_name = _surface_fonts[_g];
                var _check_data = global.__scribble_font_data[? _check_name ];
                
                var _check_l = _check_data[ __E_SCRIBBLE_FONT.SPRITE_X ];
                var _check_t = _check_data[ __E_SCRIBBLE_FONT.SPRITE_Y ];
                var _check_r = _check_l + _check_data[ __E_SCRIBBLE_FONT.TEXTURE_WIDTH  ] - 1;
                var _check_b = _check_t + _check_data[ __E_SCRIBBLE_FONT.TEXTURE_HEIGHT ] - 1;
                
                if ( rectangle_in_rectangle( _l, _t, _r, _b,   _check_l, _check_t, _check_r, _check_b ) ) {
                    _found = false;
                    break;
                }
            }
        }
        
        // If we've not found a free space yet, try scanning underneath each font texture
        
        var _surface_fonts_count = array_length_1d( _surface_fonts );
        if ( !_found ) {
            for( var _f = 0; _f < _surface_fonts_count; _f++ ) {
                var _target_name = _surface_fonts[_f];
                var _target_data = global.__scribble_font_data[? _target_name ];
                
                var _l = _target_data[ __E_SCRIBBLE_FONT.SPRITE_X ];
                var _t = _target_data[ __E_SCRIBBLE_FONT.SPRITE_Y ] + _target_data[ __E_SCRIBBLE_FONT.TEXTURE_HEIGHT ];
                var _r = _l + _texture_w - 1;
                var _b = _t + _texture_h - 1;
                
                if (_r >= global.__scribble_texture_page_size) || (_b >= global.__scribble_texture_page_size) {
                    _found = false;
                    continue;
                }
                
                _found = true;
                for( var _g = 0; _g < _surface_fonts_count; _g++ ) {
                    var _check_name = _surface_fonts[_g];
                    var _check_data = global.__scribble_font_data[? _check_name ];
                    
                    var _check_l = _check_data[ __E_SCRIBBLE_FONT.SPRITE_X ];
                    var _check_t = _check_data[ __E_SCRIBBLE_FONT.SPRITE_Y ];
                    var _check_r = _check_l + _check_data[ __E_SCRIBBLE_FONT.TEXTURE_WIDTH  ] - 1;
                    var _check_b = _check_t + _check_data[ __E_SCRIBBLE_FONT.TEXTURE_HEIGHT ] - 1;
                    
                    if ( rectangle_in_rectangle( _l, _t, _r, _b,   _check_l, _check_t, _check_r, _check_b ) ) {
                        _found = false;
                        break;
                    }
                }
            }
        }
        
        if ( _found ) {
            show_debug_message( "Scribble:         At " + string( _l ) + "," + string( _t ) + " on surface " + string( _s ) );
            _surface_fonts[@ array_length_1d( _surface_fonts ) ] = _name;
            _font_data[@ __E_SCRIBBLE_FONT.SPRITE_X ] = _l;
            _font_data[@ __E_SCRIBBLE_FONT.SPRITE_Y ] = _t;
            _surface_data[@ __E_SCRIBBLE_SURFACE.WIDTH  ] = max( _surface_w, _r+1 );
            _surface_data[@ __E_SCRIBBLE_SURFACE.HEIGHT ] = max( _surface_h, _b+1 );
            break;
        }
    }
    
    if ( !_found ) {
        show_debug_message( "Scribble:         No space found. Defining new surface (id=" + string( array_length_1d( _surface_array ) ) + ", " + string( _texture_w ) + "x" + string( _texture_h ) + ")" );
        
        _font_data[@ __E_SCRIBBLE_FONT.SPRITE_X ] = 0;
        _font_data[@ __E_SCRIBBLE_FONT.SPRITE_Y ] = 0;
        
        var _surface_data = array_create( __E_SCRIBBLE_SURFACE.__SIZE );
        _surface_data[ __E_SCRIBBLE_SURFACE.WIDTH  ] = _texture_w;
        _surface_data[ __E_SCRIBBLE_SURFACE.HEIGHT ] = _texture_h;
        _surface_data[ __E_SCRIBBLE_SURFACE.FONTS  ] = array_compose(_name);
        _surface_data[ __E_SCRIBBLE_SURFACE.LOCKED ] = false;
        
        _surface_array[@ array_length_1d( _surface_array ) ] = _surface_data;
    }
}

ds_priority_destroy( _priority_queue );

// Actually draw the fonts to surfaces

var _surface_count = array_length_1d( _surface_array );
show_debug_message( "Scribble: " + string( _surface_count ) + " surface(s) needed" );
for( var _s = 0; _s < _surface_count; _s++ ) {
    var _surface_data   = _surface_array[ _s ];
    var _surface_w      = _surface_data[ __E_SCRIBBLE_SURFACE.WIDTH  ];
    var _surface_h      = _surface_data[ __E_SCRIBBLE_SURFACE.HEIGHT ];
    var _surface_fonts  = _surface_data[ __E_SCRIBBLE_SURFACE.FONTS  ];
    var _surface_locked = _surface_data[ __E_SCRIBBLE_SURFACE.LOCKED ];
    show_debug_message( "Scribble: Drawing surface " + string( _s ) + ", " + string( _surface_w ) + " x " + string( _surface_h ) + ternary(_surface_locked, " (locked)", "") );
    
    var _surface = surface_create( _surface_w, _surface_h );
    surface_set_target( _surface );
    draw_clear_alpha( c_white, 0 );
    draw_enable_alphablend( false );
    
    var _surface_font_count = array_length_1d( _surface_fonts );
    for( var _f = 0; _f < _surface_font_count; _f++ ) {
        var _name = _surface_fonts[ _f ];
        
        var _font_data = global.__scribble_font_data[? _name ];
        var _texture_w = _font_data[ __E_SCRIBBLE_FONT.TEXTURE_WIDTH  ];
        var _texture_h = _font_data[ __E_SCRIBBLE_FONT.TEXTURE_HEIGHT ];
        var _x         = _font_data[ __E_SCRIBBLE_FONT.SPRITE_X       ];
        var _y         = _font_data[ __E_SCRIBBLE_FONT.SPRITE_Y       ];
        
        show_debug_message( "Scribble:         " + _name + " at " + string( _x ) + "," + string( _y ) + " (size=" + string( _texture_w ) + "x" + string( _texture_h ) + ")" );
        
        var _asset = asset_get_index(  _name  );
        var _uvs   = font_get_uvs(     _asset );
        
        var _vbuff = vertex_create_buffer();
        vertex_begin( _vbuff, global.__scribble_vertex_format );
        vertex_position( _vbuff, _x           , _y            ); vertex_normal( _vbuff, 0,0,0 ); vertex_colour( _vbuff, c_white, 1 ); vertex_texcoord( _vbuff, _uvs[0], _uvs[1] );
        vertex_position( _vbuff, _x+_texture_w, _y            ); vertex_normal( _vbuff, 0,0,0 ); vertex_colour( _vbuff, c_white, 1 ); vertex_texcoord( _vbuff, _uvs[2], _uvs[1] );
        vertex_position( _vbuff, _x           , _y+_texture_h ); vertex_normal( _vbuff, 0,0,0 ); vertex_colour( _vbuff, c_white, 1 ); vertex_texcoord( _vbuff, _uvs[0], _uvs[3] );
        vertex_position( _vbuff, _x+_texture_w, _y+_texture_h ); vertex_normal( _vbuff, 0,0,0 ); vertex_colour( _vbuff, c_white, 1 ); vertex_texcoord( _vbuff, _uvs[2], _uvs[3] );
        vertex_end( _vbuff );
        vertex_submit( _vbuff, pr_trianglestrip, _texture );
        vertex_delete_buffer( _vbuff );
    }
    
    draw_enable_alphablend( true );
    surface_reset_target();
    
    var _surface_sprite = sprite_create_from_surface( _surface,   0, 0, _surface_w, _surface_h,  false, false, 0, 0 );
    surface_free( _surface );
    
    ds_list_add( global.__scribble_sprites, _surface_sprite );
    
    for( var _f = 0; _f < _surface_font_count; _f++ )
    {
        var _name = _surface_fonts[ _f ];
        var _font_data = global.__scribble_font_data[? _name ];
        _font_data[@ __E_SCRIBBLE_FONT.SPRITE ] = _surface_sprite;
    }
}
    
show_debug_message( "Scribble: Surface rendering finished" );

// Process glyph data from .yy files

for( var _font = 0; _font < _font_count; _font++ ) {
    var _name = _font_array[ _font ];
    var _font_data = global.__scribble_font_data[? _name ];
    
    if ( _font_data[ __E_SCRIBBLE_FONT.TYPE ] == asset_sprite ) {
        show_debug_message( "Scribble: Processing characters for spritefont " + _name );
        
        // Spritefont
        
        var _sprite = asset_get_index( _name );
        if ( sprite_get_bbox_left(   _sprite ) == 0 )
        || ( sprite_get_bbox_top(    _sprite ) == 0 )
        || ( sprite_get_bbox_right(  _sprite ) == sprite_get_width(  _sprite )-1 )
        || ( sprite_get_bbox_bottom( _sprite ) == sprite_get_height( _sprite )-1 ) {
            show_debug_message( "WARNING! " + _name + " may be rendered incorrectly due to the bounding box overlapping the edge of the sprite. Please add at least a 1px border around your spritefont sprite. Please also update the bounding box if needed" );
        }
        
        var _sprite_string  = _font_data[ __E_SCRIBBLE_FONT.MAPSTRING   ];
        var _shift_constant = _font_data[ __E_SCRIBBLE_FONT.SEPARATION  ];
        var _space_width    = _font_data[ __E_SCRIBBLE_FONT.SPACE_WIDTH ];
        
        var _font_glyphs_map = ds_map_create();
        _font_data[@ __E_SCRIBBLE_FONT.GLYPHS_MAP ] = _font_glyphs_map;
        
        if ( SCRIBBLE_EMULATE_LEGACY_SPRITEFONT_SPACING && _in_gms221 ) _shift_constant -= 2;
        if ( SCRIBBLE_COMPATIBILITY_DRAW ) global.__scribble_spritefont_map[? _name ] = font_add_sprite_ext( _sprite, _sprite_string, true, _shift_constant );
        
        sprite_index = _sprite;
        mask_index   = _sprite;
        x = -sprite_get_xoffset( _sprite );
        y = -sprite_get_yoffset( _sprite );
        
        //Strip out a map of of glyphs
        var _length = string_length( _sprite_string );
        show_debug_message( "Scribble: " + _name + " has " + string( _length ) + " characters" );
        for( var _i = 0; _i < _length; _i++ ) {
            var _char = string_char_at( _sprite_string, _i+1 );
            if ( ds_map_exists( _font_glyphs_map, _char ) ) continue;
            if ( _char == " " ) show_debug_message( "WARNING! It is strongly recommended that you do *not* use a space character in your sprite font in GMS2.2.1 and above due to IDE bugs. Use scribble_font_char_set_*() to define a space character" );
            
            image_index = _i;
            var _uvs = sprite_get_uvs( _sprite, image_index );
            
            //Perform line sweeping to get accurate glyph data
            var _left   = bbox_left-1;
            var _top    = bbox_top-1;
            var _right  = bbox_right+1;
            var _bottom = bbox_bottom+1;
            
            while( !collision_line(       _left, bbox_top-1,        _left, bbox_bottom+1, id, true, false ) && ( _left < _right  ) ) ++_left;
            while( !collision_line( bbox_left-1,       _top, bbox_right+1,          _top, id, true, false ) && ( _top  < _bottom ) ) ++_top;
            while( !collision_line(      _right, bbox_top-1,       _right, bbox_bottom+1, id, true, false ) && ( _right  > _left ) ) --_right;
            while( !collision_line( bbox_left-1,    _bottom, bbox_right+1,       _bottom, id, true, false ) && ( _bottom > _top  ) ) --_bottom;
            
            //Build an array to store this glyph's properties
            var _array = array_create( __E_SCRIBBLE_GLYPH.__SIZE );
            array_clear(_array, 0);
            _array[ __E_SCRIBBLE_GLYPH.CHAR ] = _char;
            _array[ __E_SCRIBBLE_GLYPH.ORD  ] = ord( _char );
            _array[ __E_SCRIBBLE_GLYPH.X    ] = undefined;
            _array[ __E_SCRIBBLE_GLYPH.Y    ] = undefined;
            
            if ( _left == _right ) && ( _top == _bottom ) {
                show_debug_message( "WARNING! Character " + string( ord( _char ) ) + "(" + _char + ") for sprite font " + _name + " is empty" );
                
                _array[ __E_SCRIBBLE_GLYPH.W    ] = 1;
                _array[ __E_SCRIBBLE_GLYPH.H    ] = sprite_get_height( _sprite );
                _array[ __E_SCRIBBLE_GLYPH.DX   ] = 0;
                _array[ __E_SCRIBBLE_GLYPH.DY   ] = 0;
                _array[ __E_SCRIBBLE_GLYPH.SHF  ] = 1 + _shift_constant;
                _array[ __E_SCRIBBLE_GLYPH.U0   ] = 0;
                _array[ __E_SCRIBBLE_GLYPH.V0   ] = 0;
                _array[ __E_SCRIBBLE_GLYPH.U1   ] = 0;
                _array[ __E_SCRIBBLE_GLYPH.V1   ] = 0;
                _font_glyphs_map[? _char ] = _array;
            } else {
                if ( _in_gms221 ) {
                    //GMS2.2.1 does some weeeird things to sprite fonts
                    var _glyph_width  = 3 + _right - _left;
                    var _glyph_height = 3 + _bottom - _top;
                    _array[ __E_SCRIBBLE_GLYPH.W    ] = _glyph_width;
                    _array[ __E_SCRIBBLE_GLYPH.H    ] = _glyph_height;
                    _array[ __E_SCRIBBLE_GLYPH.DX   ] = _left - bbox_left;
                    _array[ __E_SCRIBBLE_GLYPH.DY   ] = _top-1;
                    _array[ __E_SCRIBBLE_GLYPH.SHF  ] = _glyph_width + _shift_constant;
                    _array[ __E_SCRIBBLE_GLYPH.U0   ] = _uvs[0];
                    _array[ __E_SCRIBBLE_GLYPH.V0   ] = _uvs[1];
                    _array[ __E_SCRIBBLE_GLYPH.U1   ] = _uvs[2];
                    _array[ __E_SCRIBBLE_GLYPH.V1   ] = _uvs[3];
                } else {
                    --_left;
                    ++_bottom;
                    var _glyph_width  = _right - _left;
                    var _glyph_height = _bottom - _top;
                    _array[ __E_SCRIBBLE_GLYPH.W    ] = _glyph_width;
                    _array[ __E_SCRIBBLE_GLYPH.H    ] = _glyph_height;
                    _array[ __E_SCRIBBLE_GLYPH.DX   ] = _left;
                    _array[ __E_SCRIBBLE_GLYPH.DY   ] = _top;
                    _array[ __E_SCRIBBLE_GLYPH.SHF  ] = _glyph_width + _shift_constant;
                    _array[ __E_SCRIBBLE_GLYPH.U0   ] = _uvs[0];
                    _array[ __E_SCRIBBLE_GLYPH.V0   ] = _uvs[1];
                    _array[ __E_SCRIBBLE_GLYPH.U1   ] = _uvs[2];
                    _array[ __E_SCRIBBLE_GLYPH.V1   ] = _uvs[3];
                }
                
                _font_glyphs_map[? _char ] = _array;
            }
        }
        
        if ( !ds_map_exists( _font_glyphs_map, " " ) ) {
            if ( _in_gms221 ) {
                var _glyph_width  = sprite_get_width(  _sprite );
                var _glyph_height = sprite_get_height( _sprite );
            } else {
                var _glyph_width  = sprite_get_width(  _sprite )-2;
                var _glyph_height = sprite_get_height( _sprite );
            }
            
            //Build an array to store this glyph's properties
            var _array = array_create( __E_SCRIBBLE_GLYPH.__SIZE);
            array_clear(_array, 0);
            _array[ __E_SCRIBBLE_GLYPH.CHAR ] = " ";
            _array[ __E_SCRIBBLE_GLYPH.ORD  ] = 32;
            _array[ __E_SCRIBBLE_GLYPH.X    ] = undefined;
            _array[ __E_SCRIBBLE_GLYPH.Y    ] = undefined;
            _array[ __E_SCRIBBLE_GLYPH.W    ] = _glyph_width;
            _array[ __E_SCRIBBLE_GLYPH.H    ] = _glyph_height;
            _array[ __E_SCRIBBLE_GLYPH.DX   ] = 0;
            _array[ __E_SCRIBBLE_GLYPH.DY   ] = 0;
            _array[ __E_SCRIBBLE_GLYPH.SHF  ] = _glyph_width + _shift_constant;
            _array[ __E_SCRIBBLE_GLYPH.U0   ] = 0;
            _array[ __E_SCRIBBLE_GLYPH.V0   ] = 0;
            _array[ __E_SCRIBBLE_GLYPH.U1   ] = 0;
            _array[ __E_SCRIBBLE_GLYPH.V1   ] = 0;
            _font_glyphs_map[? " " ] = _array;
        }
        
        if ( _space_width != undefined ) {
            var _array = _font_glyphs_map[? " " ];
            _array[@ __E_SCRIBBLE_GLYPH.W   ] = _space_width;
            _array[@ __E_SCRIBBLE_GLYPH.SHF ] = _space_width;
        }
        
        sprite_index = -1;
    } else {
        // Font
        
        show_debug_message( "Scribble: Processing characters for font " + _name );
        
        var _surface_sprite  = _font_data[ __E_SCRIBBLE_FONT.SPRITE     ];
        var _image_x_offset  = _font_data[ __E_SCRIBBLE_FONT.SPRITE_X   ];
        var _image_y_offset  = _font_data[ __E_SCRIBBLE_FONT.SPRITE_Y   ];
        var _font_glyphs_map = _font_data[ __E_SCRIBBLE_FONT.GLYPHS_MAP  ];
        
        var _texture = sprite_get_texture( _surface_sprite, 0 );
        var _texture_tw = texture_get_texel_width(  _texture );
        var _texture_th = texture_get_texel_height( _texture );
        
        
        
        var _json_buffer = buffer_load( global.__scribble_font_directory + _name + ".yy" );
        var _json_string = buffer_read( _json_buffer, buffer_text );
        buffer_delete( _json_buffer );
        var _json = json_decode( _json_string );
        
        
        
        var _yy_glyph_list = _json[? "glyphs" ];
        var _size = ds_list_size( _yy_glyph_list );
        show_debug_message( "Scribble: " + _name + " has " + string( _size ) + " characters" );
        
        var _ds_map_fallback = true;
        
        if (__SCRIBBLE_TRY_SEQUENTIAL_GLYPH_INDEX) {
            // Sequential glyph index
            
            show_debug_message( "Scribble: Trying sequential glyph index..." );
            
            var _glyph_map = ds_map_create();
            
            var _yy_glyph_map = _yy_glyph_list[| 0];
                _yy_glyph_map = _yy_glyph_map[? "Value" ];
            
            var _glyph_min = _yy_glyph_map[? "character" ];
            var _glyph_max = _glyph_min;
            _glyph_map[? _glyph_min ] = 0;
            
            for( var _i = 1; _i < _size; _i++ ) {
                var _yy_glyph_map = _yy_glyph_list[| _i ];
                    _yy_glyph_map = _yy_glyph_map[? "Value" ];
                var _index = _yy_glyph_map[? "character" ];
                
                _glyph_map[? _index ] = _i;
                _glyph_min = min( _glyph_min, _index );
                _glyph_max = max( _glyph_max, _index );
            }
            
            _font_data[@ __E_SCRIBBLE_FONT.GLYPH_MIN ] = _glyph_min;
            _font_data[@ __E_SCRIBBLE_FONT.GLYPH_MAX ] = _glyph_max;
            
            var _glyph_count = 1 + _glyph_max - _glyph_min;
            show_debug_message( "Scribble: Glyphs start at " + string( _glyph_min ) + " and end at " + string( _glyph_max ) + ". Range is " + string( _glyph_count-1 ) );
            
            if ( (_glyph_count-1) > SCRIBBLE_SEQUENTIAL_GLYPH_MAX_RANGE ) {
                show_debug_message( "Scribble: Glyph range exceeds maximum (" + string( SCRIBBLE_SEQUENTIAL_GLYPH_MAX_RANGE ) + ")!" );
            } else {
                var _holes = 0;
                for( var _i = _glyph_min; _i <= _glyph_max; _i++ ) if ( !ds_map_exists( _glyph_map, _i ) ) _holes++;
                ds_map_destroy( _glyph_map );
                var _fraction = _holes / _glyph_count;
                
                show_debug_message( "Scribble: There are " + string( _holes ) + " holes, " + string( _fraction*100 ) + "%" );
                
                if ( _fraction > SCRIBBLE_SEQUENTIAL_GLYPH_MAX_HOLES ) {
                    show_debug_message( "Scribble: Hole proportion exceeds maximum (" + string( SCRIBBLE_SEQUENTIAL_GLYPH_MAX_HOLES*100 ) + "%)!" );
                } else {
                    show_debug_message( "Scribble: Using an array to index glyphs" );
                    _ds_map_fallback = false;
                    
                    var _font_glyphs_array = array_create( _glyph_count);
                    array_clear(_font_glyphs_array, undefined);
                    _font_data[@ __E_SCRIBBLE_FONT.GLYPHS_ARRAY ] = _font_glyphs_array;
                    
                    for( var _i = 0; _i < _size; _i++ ) {
                        var _yy_glyph_map = _yy_glyph_list[| _i ];
                            _yy_glyph_map = _yy_glyph_map[? "Value" ];
                        
                        var _index = _yy_glyph_map[? "character" ];
                        var _char  = chr( _index );
                        var _x     = _yy_glyph_map[? "x" ];
                        var _y     = _yy_glyph_map[? "y" ];
                        var _w     = _yy_glyph_map[? "w" ];
                        var _h     = _yy_glyph_map[? "h" ];
                        
                        var _u0    = ( _x + _image_x_offset ) * _texture_tw;
                        var _v0    = ( _y + _image_y_offset ) * _texture_th;
                        var _u1    = _u0 + _w * _texture_tw;
                        var _v1    = _v0 + _h * _texture_th;
                        
                        var _array = array_create( __E_SCRIBBLE_GLYPH.__SIZE);
                        array_clear(_array, 0);
                        _array[ __E_SCRIBBLE_GLYPH.CHAR ] = _char;
                        _array[ __E_SCRIBBLE_GLYPH.ORD  ] = _index;
                        _array[ __E_SCRIBBLE_GLYPH.X    ] = _x + _image_x_offset;
                        _array[ __E_SCRIBBLE_GLYPH.Y    ] = _y + _image_y_offset;
                        _array[ __E_SCRIBBLE_GLYPH.W    ] = _w;
                        _array[ __E_SCRIBBLE_GLYPH.H    ] = _h;
                        _array[ __E_SCRIBBLE_GLYPH.DX   ] = _yy_glyph_map[? "offset" ];
                        _array[ __E_SCRIBBLE_GLYPH.DY   ] = 0;
                        _array[ __E_SCRIBBLE_GLYPH.SHF  ] = _yy_glyph_map[? "shift"  ];
                        _array[ __E_SCRIBBLE_GLYPH.U0   ] = _u0;
                        _array[ __E_SCRIBBLE_GLYPH.V0   ] = _v0;
                        _array[ __E_SCRIBBLE_GLYPH.U1   ] = _u1;
                        _array[ __E_SCRIBBLE_GLYPH.V1   ] = _v1;
                        
                        _font_glyphs_array[@ _index - _glyph_min ] = _array;
                    }
                }
            }
        }
        
        if ( _ds_map_fallback ) {
            show_debug_message( "Scribble: Using a ds_map to index glyphs" );
            
            var _font_glyphs_map = ds_map_create();
            _font_data[@ __E_SCRIBBLE_FONT.GLYPHS_MAP ] = _font_glyphs_map;
            
            for( var _i = 0; _i < _size; _i++ ) {
                var _yy_glyph_map = _yy_glyph_list[| _i ];
                    _yy_glyph_map = _yy_glyph_map[? "Value" ];
                
                var _index = _yy_glyph_map[? "character" ];
                var _char  = chr( _index );
                var _x     = _yy_glyph_map[? "x" ];
                var _y     = _yy_glyph_map[? "y" ];
                var _w     = _yy_glyph_map[? "w" ];
                var _h     = _yy_glyph_map[? "h" ];
                
                var _u0    = ( _x + _image_x_offset ) * _texture_tw;
                var _v0    = ( _y + _image_y_offset ) * _texture_th;
                var _u1    = _u0 + _w * _texture_tw;
                var _v1    = _v0 + _h * _texture_th;
                
                var _array = array_create( __E_SCRIBBLE_GLYPH.__SIZE);
                array_clear(_array, 0);
                _array[ __E_SCRIBBLE_GLYPH.CHAR ] = _char;
                _array[ __E_SCRIBBLE_GLYPH.ORD  ] = _index;
                _array[ __E_SCRIBBLE_GLYPH.X    ] = _x + _image_x_offset;
                _array[ __E_SCRIBBLE_GLYPH.Y    ] = _y + _image_y_offset;
                _array[ __E_SCRIBBLE_GLYPH.W    ] = _w;
                _array[ __E_SCRIBBLE_GLYPH.H    ] = _h;
                _array[ __E_SCRIBBLE_GLYPH.DX   ] = _yy_glyph_map[? "offset" ];
                _array[ __E_SCRIBBLE_GLYPH.DY   ] = 0;
                _array[ __E_SCRIBBLE_GLYPH.SHF  ] = _yy_glyph_map[? "shift"  ];
                _array[ __E_SCRIBBLE_GLYPH.U0   ] = _u0;
                _array[ __E_SCRIBBLE_GLYPH.V0   ] = _v0;
                _array[ __E_SCRIBBLE_GLYPH.U1   ] = _u1;
                _array[ __E_SCRIBBLE_GLYPH.V1   ] = _v1;
                
                _font_glyphs_map[? _char ] = _array;
            }
        }
        
        ds_map_destroy( _json );
    }
    
    show_debug_message( "Scribble: " + _name + " finished" );
}

x = _old_x;
y = _old_y;
image_xscale = _old_image_xscale;
image_yscale = _old_image_yscale;
mask_index = _old_mask_index;

show_debug_message( "Scribble: Font initialisation complete, took " + string( (get_timer() - _timer)/1000 ) + "ms" );
show_debug_message( "Scribble: Thanks for using Scribble! @jujuadams" );

global.__scribble_init_complete = SCRIBBLE_INIT_COMPLETE;
