/// @param font_name_array

var _font_array = argument0;

var _warning_count = 0;
var _timer = get_timer();
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



var _in_gms221 = __scribble_in_gms221();
if ( _in_gms221 ) show_debug_message( "Scribble: Using legacy (GMS2.2.0 and prior) compatibility mode" );



var _surface_array = [];
var _priority_queue = ds_priority_create();

var _font_count = array_length_1d( _font_array );
show_debug_message( "Scribble: " + string( _font_count ) + " font(s) defined" );
for( var _f = 0; _f < _font_count; _f++ )
{
    var _name = _font_array[_f];
    if ( is_array( _name ) ) _name = _name[0];
    
    if ( ds_map_exists( global.__scribble_image_map, _name ) )
    {
        show_error( "Scribble:\n\nFont \"" + _name + "\" has already been defined.\n ", true );
        exit;
    }
    
    if ( asset_get_type( _name ) == asset_sprite )
    {
        global.__scribble_image_map[? _name ] = asset_get_index( _name );
        show_debug_message( "Scribble: Found spritefont \"" + _name + "\"" );
    }
    else
    {
        var _json_file  = SCRIBBLE_FONT_DIRECTORY + _name + ".yy";
        if ( !file_exists( _json_file ) )
        {
            show_error( "Scribble:\n\nCould not find \"" + _json_file + "\" in Included Files.\nPlease add this file to your project.\n ", false );
            continue;
        }
        
        global.__scribble_image_map[?   _name ] = undefined;
        global.__scribble_image_x_map[? _name ] = 0;
        global.__scribble_image_y_map[? _name ] = 0;
        
        var _size = __scribble_get_font_texture_size( _name );
        if ( _size[0] > global.__scribble_texture_page_size ) || ( _size[1] > global.__scribble_texture_page_size )
        {
            _warning_count++;
            show_debug_message( "Scribble: WARNING! The texture for \"" + _name + "\" is larger than Scribble's maximum texture page size (" + string( _size[0] ) + "x" + string( _size[1] ) + " > " + string( global.__scribble_texture_page_size ) + "x" + string( global.__scribble_texture_page_size ) + ")" );
            var _bigger_size = power(2,ceil(ln(max( _size[0], _size[1] ))/ln(2)));
            show_debug_message( "Scribble: WARNING! Please use a larger texture page size in Scribble and GameMaker (e.g. " + string( _bigger_size ) + "x" + string( _bigger_size ) + ") to avoid bugs and blurry text" );
        }
        
        var _priority = _size[1]*global.__scribble_texture_page_size + _size[0];
        ds_priority_add( _priority_queue, _name, _priority );
        show_debug_message( "Scribble: Queuing \"" + _name + "\" for packing (size=" + string( _size[0] ) + "x" + string( _size[1] ) + ", weight=" + string( _priority ) + ")" );
    }
}



show_debug_message( "Scribble: " + string( ds_priority_size( _priority_queue ) ) + " font(s) to pack" );

while( !ds_priority_empty( _priority_queue ) )
{
    var _name = ds_priority_delete_max( _priority_queue );
    var _size = __scribble_get_font_texture_size( _name );
    show_debug_message( "Scribble: Packing \"" + _name + "\" (size=" + string( _size[0] ) + "," + string( _size[1] ) + ")..." );
    
    var _found = false;
    var _surface_count = array_length_1d( _surface_array );
    for( var _s = 0; _s < _surface_count; _s++ )
    {
        var _surface_data = _surface_array[_s];
        var _surface_w      = _surface_data[0];
        var _surface_h      = _surface_data[1];
        var _surface_fonts  = _surface_data[2];
        var _surface_locked = _surface_data[3];
        
        if ( _surface_locked ) continue; //Ignore "locked" surfaces
        
        //Scan to the right of each font texture to try to find a free spot
        var _surface_fonts_count = array_length_1d( _surface_fonts );
        for( var _f = 0; _f < _surface_fonts_count; _f++ )
        {
            var _target_name = _surface_fonts[_f];
            var _target_size = __scribble_get_font_texture_size( _target_name );
            
            var _l = global.__scribble_image_x_map[? _target_name ] + _target_size[0];
            var _t = global.__scribble_image_y_map[? _target_name ];
            var _r = _l + _size[0] - 1;
            var _b = _t + _size[1] - 1;
            
            _found = true;
            for( var _g = 0; _g < _surface_fonts_count; _g++ )
            {
                var _check_name = _surface_fonts[_g];
                var _check_size = __scribble_get_font_texture_size( _check_name );
                
                var _check_l = global.__scribble_image_x_map[? _check_name ];
                var _check_t = global.__scribble_image_y_map[? _check_name ];
                var _check_r = _check_l + _check_size[0] - 1;
                var _check_b = _check_t + _check_size[1] - 1;
                
                if ( rectangle_in_rectangle( _l, _t, _r, _b,   _check_l, _check_t, _check_r, _check_b ) )
                || ( _r > global.__scribble_texture_page_size )
                || ( _b > global.__scribble_texture_page_size )
                {
                    _found = false;
                    break;
                }
            }
        }
        
        //If we've not found a free space yet, try scanning underneath each font texture
        var _surface_fonts_count = array_length_1d( _surface_fonts );
        if ( !_found )
        {
            for( var _f = 0; _f < _surface_fonts_count; _f++ )
            {
                var _target_name = _surface_fonts[_f];
                var _target_size = __scribble_get_font_texture_size( _target_name );
                
                var _l = global.__scribble_image_x_map[? _target_name ];
                var _t = global.__scribble_image_y_map[? _target_name ] + _target_size[1];
                var _r = _l + _size[0] - 1;
                var _b = _t + _size[1] - 1;
                
                _found = true;
                for( var _g = 0; _g < _surface_fonts_count; _g++ )
                {
                    var _check_name = _surface_fonts[_g];
                    var _check_size = __scribble_get_font_texture_size( _check_name );
                    
                    var _check_l = global.__scribble_image_x_map[? _check_name ];
                    var _check_t = global.__scribble_image_y_map[? _check_name ];
                    var _check_r = _check_l + _check_size[0] - 1;
                    var _check_b = _check_t + _check_size[1] - 1;
                    
                    if ( rectangle_in_rectangle( _l, _t, _r, _b,   _check_l, _check_t, _check_r, _check_b ) )
                    || ( _r > global.__scribble_texture_page_size )
                    || ( _b > global.__scribble_texture_page_size )
                    {
                        _found = false;
                        break;
                    }
                }
            }
        }
        
        if ( _found )
        {
            show_debug_message( "Scribble: ...at " + string( _l ) + "," + string( _t ) + " on surface " + string( _s ) );
            _surface_fonts[@ array_length_1d( _surface_fonts ) ] = _name;
            global.__scribble_image_x_map[? _name ] = _l;
            global.__scribble_image_y_map[? _name ] = _t;
            _surface_data[@ 0] = max( _surface_w, _r+1 );
            _surface_data[@ 1] = max( _surface_h, _b+1 );
            break;
        }
    }
    
    if ( !_found )
    {
        show_debug_message( "Scribble: ...no space found. Defining new surface (" + string( array_length_1d( _surface_array ) ) + ")" );
        var _surface_data = [ _size[0], _size[1], [ _name ], false ];
        _surface_array[@ array_length_1d( _surface_array ) ] = _surface_data;
    }
}

ds_priority_destroy( _priority_queue );



var _surface_count = array_length_1d( _surface_array );
show_debug_message( "Scribble: " + string( _surface_count ) + " surface(s) needed" );
for( var _s = 0; _s < _surface_count; _s++ )
{
    var _surface_data   = _surface_array[_s];
    var _surface_w      = _surface_data[0];
    var _surface_h      = _surface_data[1];
    var _surface_fonts  = _surface_data[2];
    var _surface_locked = _surface_data[3];
    show_debug_message( "Scribble: Drawing surface " + string( _s ) + ", " + string( _surface_w ) + " x " + string( _surface_h ) + (_surface_locked? " (locked)" : "") );
    
    var _surface = surface_create( _surface_w, _surface_h );
    surface_set_target( _surface );
    draw_clear_alpha( c_white, 0 );
    gpu_set_blendenable( false );
    
    var _surface_font_count = array_length_1d( _surface_fonts );
    show_debug_message( "Scribble: Surface has " + string( _surface_font_count ) + " font(s)" );
    for( var _f = 0; _f < _surface_font_count; _f++ )
    {
        var _name = _surface_fonts[_f];
        __scribble_draw_font_texture( _name, global.__scribble_image_x_map[? _name ], global.__scribble_image_y_map[? _name ] );
    }
    
    gpu_set_blendenable( true );
    surface_reset_target();
    
    var _surface_sprite = sprite_create_from_surface( _surface,   0, 0, _surface_w, _surface_h,  false, false, 0, 0 );
    surface_free( _surface );
    
    ds_list_add( global.__scribble_sprites, _surface_sprite );
    
    for( var _f = 0; _f < _surface_font_count; _f++ ) global.__scribble_image_map[? _surface_fonts[_f] ] = _surface_sprite;
    
    show_debug_message( "Scribble: Surface " + string( _s ) + " finished" );
}



for( var _font = 0; _font < _font_count; _font++ )
{
    var _input_array = [];
    var _name = _font_array[ _font ];
    
    if ( is_array( _name ) )
    {
        var _input_array = _name;
        _name = _input_array[0];
    }
    
    if ( asset_get_type( _name ) == asset_sprite )
    {
        show_debug_message( "Scribble: Processing characters for spritefont \"" + _name + "\"" );
        
        #region Sprites
        
        var _sprite = asset_get_index( _name );
        if ( sprite_get_bbox_left(   _sprite ) == 0 )
        || ( sprite_get_bbox_top(    _sprite ) == 0 )
        || ( sprite_get_bbox_right(  _sprite ) == sprite_get_width(  _sprite )-1 )
        || ( sprite_get_bbox_bottom( _sprite ) == sprite_get_height( _sprite )-1 )
        {
            show_debug_message( "WARNING! \"" + _name + "\" may be rendered incorrectly due to the bounding box overlapping the edge of the sprite. Please add at least a 1px border around your spritefont sprite. Please also update the bounding box if needed" );
        }
        
        var _sprite_string  = ((array_length_1d( _input_array ) > 1) && (_input_array[1] != undefined))? _input_array[1] : SCRIBBLE_DEFAULT_SPRITEFONT_MAPSTRING;
        var _shift_constant = ((array_length_1d( _input_array ) > 2) && (_input_array[2] != undefined))? _input_array[2] : SCRIBBLE_DEFAULT_SPRITEFONT_SEPARATION;
        if ( SCRIBBLE_LEGACY_GMS220_SPRITEFONT_SPACING && _in_gms221 ) _shift_constant -= 2;
        
        if ( SCRIBBLE_COMPATIBILITY_MODE ) global.__scribble_sprite_font_map[? _name ] = font_add_sprite_ext( _sprite, _sprite_string, true, _shift_constant );
        
        sprite_index = _sprite;
        mask_index   = _sprite;
        x = -sprite_get_xoffset( _sprite );
        y = -sprite_get_yoffset( _sprite );
        
        var _font_glyphs_map = ds_map_create();
        ds_map_add_map( global.__scribble_glyphs_map, _name, _font_glyphs_map  );
        
        //Strip out a map of of glyphs
        var _length = string_length( _sprite_string );
        show_debug_message( "Scribble: \"" + _name + "\" has " + string( _length ) + " characters" );
        for( var _i = 0; _i < _length; _i++ )
        {
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
            var _array = array_create( __E_SCRIBBLE_GLYPH.__SIZE, 0 );
            _array[ __E_SCRIBBLE_GLYPH.CHAR ] = _char;
            _array[ __E_SCRIBBLE_GLYPH.ORD  ] = ord( _char );
            _array[ __E_SCRIBBLE_GLYPH.X    ] = undefined;
            _array[ __E_SCRIBBLE_GLYPH.Y    ] = undefined;
            
            if ( _left == _right ) && ( _top == _bottom )
            {
                show_debug_message( "WARNING! Character " + string( ord( _char ) ) + "(" + _char + ") for sprite font \"" + _name + "\" is empty" );
                
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
            }
            else
            {
                if ( _in_gms221 )
                {
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
                }
                else
                {
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
        
        if ( !ds_map_exists( _font_glyphs_map, " " ) )
        {
            if ( _in_gms221 )
            {
                var _glyph_width  = sprite_get_width(  _sprite );
                var _glyph_height = sprite_get_height( _sprite );
            }
            else
            {
                var _glyph_width  = sprite_get_width(  _sprite )-2;
                var _glyph_height = sprite_get_height( _sprite );
            }
            
            //Build an array to store this glyph's properties
            var _array = array_create( __E_SCRIBBLE_GLYPH.__SIZE, 0 );
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
        
        sprite_index = -1;
        show_debug_message( "Scribble: \"" + _name + "\" characters parsed" );
        
        #endregion
    }
    else
    {
        #region Font
        
        show_debug_message( "Scribble: Processing characters for font \"" + _name + "\"" );
        
        var _surface_sprite = global.__scribble_image_map[? _name ];
        var _image_x_offset = global.__scribble_image_x_map[? _name ];
        var _image_y_offset = global.__scribble_image_y_map[? _name ];
        
        var _texture = sprite_get_texture( _surface_sprite, 0 );
        var _texture_tw = texture_get_texel_width(  _texture );
        var _texture_th = texture_get_texel_height( _texture );
        
        
        
        var _json_buffer = buffer_load( SCRIBBLE_FONT_DIRECTORY + _name + ".yy" );
        var _json_string = buffer_read( _json_buffer, buffer_text );
        buffer_delete( _json_buffer );
        var _json = json_decode( _json_string );
        
        
        
        var _font_glyphs_map = ds_map_create();
        ds_map_add_map( global.__scribble_glyphs_map, _name, _font_glyphs_map  );
        
        var _glyph_list = _json[? "glyphs" ];
        var _size = ds_list_size( _glyph_list );
        show_debug_message( "Scribble: \"" + _name + "\" has " + string( _size ) + " characters" );
        for( var _i = 0; _i < _size; _i++ )
        {
            var _glyph_map = _glyph_list[| _i ];
            _glyph_map = _glyph_map[? "Value" ];
    
            var _index = _glyph_map[? "character" ];
            var _char  = chr( _index );
            var _x     = _glyph_map[? "x" ];
            var _y     = _glyph_map[? "y" ];
            var _w     = _glyph_map[? "w" ];
            var _h     = _glyph_map[? "h" ];
        
            var _u0    = ( _x + _image_x_offset ) * _texture_tw;
            var _v0    = ( _y + _image_y_offset ) * _texture_th;
            var _u1    = _u0 + _w * _texture_tw;
            var _v1    = _v0 + _h * _texture_th;
            
            var _array = array_create( __E_SCRIBBLE_GLYPH.__SIZE, 0 );
            
            _array[ __E_SCRIBBLE_GLYPH.CHAR ] = _char;
            _array[ __E_SCRIBBLE_GLYPH.ORD  ] = _index;
            _array[ __E_SCRIBBLE_GLYPH.X    ] = _x + _image_x_offset;
            _array[ __E_SCRIBBLE_GLYPH.Y    ] = _y + _image_y_offset;
            _array[ __E_SCRIBBLE_GLYPH.W    ] = _w;
            _array[ __E_SCRIBBLE_GLYPH.H    ] = _h;
            _array[ __E_SCRIBBLE_GLYPH.DX   ] = _glyph_map[? "offset" ];
            _array[ __E_SCRIBBLE_GLYPH.DY   ] = 0;
            _array[ __E_SCRIBBLE_GLYPH.SHF  ] = _glyph_map[? "shift"  ];
            _array[ __E_SCRIBBLE_GLYPH.U0   ] = _u0;
            _array[ __E_SCRIBBLE_GLYPH.V0   ] = _v0;
            _array[ __E_SCRIBBLE_GLYPH.U1   ] = _u1;
            _array[ __E_SCRIBBLE_GLYPH.V1   ] = _v1;
            
            _font_glyphs_map[? _char ] = _array;
        }
        
        ds_map_destroy( _json );
        show_debug_message( "Scribble: \"" + _name + "\" characters parsed" );
        
        #endregion
    }
}



x = _old_x;
y = _old_y;
image_xscale = _old_image_xscale;
image_yscale = _old_image_yscale;
mask_index = _old_mask_index;

show_debug_message( "Scribble: " + string( _warning_count ) + " warning(s) generated" );
show_debug_message( "Scribble: Font initialisation complete, took " + string( (get_timer() - _timer)/1000 ) + "ms" );