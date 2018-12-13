/// @param font_name_array

var _font_array = argument0;
var _font_count = array_length_1d( _font_array );



var _old_x = x;
var _old_y = y;
var _old_image_xscale = image_xscale;
var _old_image_yscale = image_yscale;
x = 0;
y = 0;
image_xscale = 1;
image_yscale = 1;



var _max_width  = 0;
var _max_height = 0;

for( var _font = 0; _font < _font_count; _font++ ) {
    
    var _name = _font_array[ _font ];
    if ( is_array( _name ) ) _name = _name[0];
    
    if ( asset_get_type( _name ) == asset_sprite ) {
        
        global.__scribble_image_map[? _name ] = asset_get_index( _name );
        
    } else {
        
        var _json_file  = SCRIBBLE_FONT_DIRECTORY + _name + ".yy";
        if ( !file_exists( _json_file ) ) {
            show_error( "Could not find \"" + _json_file + "\" in Included Files.\nPlease add this file to your project.\n ", false );
            continue;
        }
        
        var _font_asset = asset_get_index( _name );
        var _texture    = font_get_texture( _font );
        var _uvs        = font_get_uvs( _font );
        
        var _image_w = ( _uvs[2] - _uvs[0] ) / texture_get_texel_width(  _texture );
        var _image_h = ( _uvs[3] - _uvs[1] ) / texture_get_texel_height( _texture );
        
        _max_width += _image_w;
        _max_height = max( _max_height, _image_h );
        
        global.__scribble_image_map[?   _name ] = undefined;
        global.__scribble_image_x_map[? _name ] = 0;
        global.__scribble_image_y_map[? _name ] = 0;
        
    }
    
}



if ( _max_width > 0 ) && ( _max_height > 0 ) {
    
    var _x = 0;
    var _y = 0;
    
    var _surface = surface_create( _max_width, _max_height );
    surface_set_target( _surface );
        
        draw_clear_alpha( c_white, 0 );
        gpu_set_blendenable( false );
        
        for( var _font = 0; _font < _font_count; _font++ ) {
            
            var _name = _font_array[ _font ];
            if ( is_array( _name ) ) _name = _name[0];
            
            if ( asset_get_type( _name ) != asset_sprite ) {
                
                var _font_asset = asset_get_index( _name );
                var _texture    = font_get_texture( _font );
                var _uvs        = font_get_uvs( _font );
                
                var _image_w = (_uvs[2] - _uvs[0]) / texture_get_texel_width(  _texture );
                var _image_h = (_uvs[3] - _uvs[1]) / texture_get_texel_height( _texture );
                
                var _vbuff = vertex_create_buffer();
                vertex_begin( _vbuff, global.__scribble_vertex_format );
                vertex_position( _vbuff, _x         , _y          ); vertex_texcoord( _vbuff, _uvs[0], _uvs[1] ); vertex_color( _vbuff, c_white, 1 ); vertex_float4( _vbuff, 0,0,0,0 ); vertex_float3( _vbuff, 0,0,0 );
                vertex_position( _vbuff, _x+_image_w, _y          ); vertex_texcoord( _vbuff, _uvs[2], _uvs[1] ); vertex_color( _vbuff, c_white, 1 ); vertex_float4( _vbuff, 0,0,0,0 ); vertex_float3( _vbuff, 0,0,0 );
                vertex_position( _vbuff, _x         , _y+_image_h ); vertex_texcoord( _vbuff, _uvs[0], _uvs[3] ); vertex_color( _vbuff, c_white, 1 ); vertex_float4( _vbuff, 0,0,0,0 ); vertex_float3( _vbuff, 0,0,0 );
                vertex_position( _vbuff, _x+_image_w, _y+_image_h ); vertex_texcoord( _vbuff, _uvs[2], _uvs[3] ); vertex_color( _vbuff, c_white, 1 ); vertex_float4( _vbuff, 0,0,0,0 ); vertex_float3( _vbuff, 0,0,0 );
                vertex_end( _vbuff );
                vertex_submit( _vbuff, pr_trianglestrip, _texture );
                vertex_delete_buffer( _vbuff );
                
                global.__scribble_image_x_map[? _name ] = _x;
                global.__scribble_image_y_map[? _name ] = _y;
                _x += _image_w;
                
            }
            
        }
        
        gpu_set_blendenable( true );
        
    surface_reset_target();
    var _surface_sprite = sprite_create_from_surface( _surface,   0, 0, _max_width, _max_height,  false, false, 0, 0 );
    surface_save( _surface, "fonts.png" );
    
}





for( var _font = 0; _font < _font_count; _font++ ) {
    
    var _input_array = [];
    var _name = _font_array[ _font ];
    
    if ( is_array( _name ) ) {
        var _input_array = _name;
        _name = _input_array[0];
    }
    
    if ( asset_get_type( _name ) == asset_sprite ) {
        
        #region Sprites
        
        var _sprite = asset_get_index( _name );
        var _sprite_string  = ((array_length_1d( _input_array ) > 1) && (_input_array[1] != undefined))? _input_array[1] : SCRIBBLE_DEFAULT_SPRITEFONT_MAPSTRING;
        var _shift_constant = ((array_length_1d( _input_array ) > 2) && (_input_array[2] != undefined))? _input_array[2] : SCRIBBLE_DEFAULT_SPRITEFONT_SEPARATION;
        
        if ( SCRIBBLE_COMPATIBILITY_MODE ) global.__scribble_sprite_font_map[? _name ] = font_add_sprite_ext( _sprite, _sprite_string, true, _shift_constant );
        
        sprite_index = _sprite;
        //sprite_set_offset( _sprite, 0, 0 );
        
        var _font_glyphs_map = ds_map_create();
        ds_map_add_map( global.__scribble_glyphs_map, _name, _font_glyphs_map  );
        
        
        //Force a space into the glyph map
        var _array = array_create( __E_SCRIBBLE_GLYPH.__SIZE, 0 );
            
        _array[ __E_SCRIBBLE_GLYPH.CHAR ] = " ";
        _array[ __E_SCRIBBLE_GLYPH.ORD  ] = 32;
        _array[ __E_SCRIBBLE_GLYPH.X    ] = undefined;
        _array[ __E_SCRIBBLE_GLYPH.Y    ] = undefined;
        _array[ __E_SCRIBBLE_GLYPH.W    ] = 1 + bbox_right - bbox_left;
        _array[ __E_SCRIBBLE_GLYPH.H    ] = 1 + bbox_bottom - bbox_top;
        _array[ __E_SCRIBBLE_GLYPH.DX   ] = 0;
        _array[ __E_SCRIBBLE_GLYPH.DY   ] = 0;
        _array[ __E_SCRIBBLE_GLYPH.SHF  ] = 1 + bbox_right - bbox_left + _shift_constant;
        _array[ __E_SCRIBBLE_GLYPH.U0   ] = 0;
        _array[ __E_SCRIBBLE_GLYPH.V0   ] = 0;
        _array[ __E_SCRIBBLE_GLYPH.U1   ] = 0;
        _array[ __E_SCRIBBLE_GLYPH.V1   ] = 0;
            
        _font_glyphs_map[? " " ] = _array;
        
        
        
        //Strip out a map of of glyphs
        var _length = string_length( _sprite_string );
        for( var _i = 1; _i <= _length; _i++ ) {
    
            var _char = string_copy( _sprite_string, _i, 1 );
            if ( ds_map_exists( _font_glyphs_map, _char ) ) continue;
    
            image_index = _i - 1;
            var _uvs = sprite_get_uvs( _sprite, image_index );
        
            //Perform line sweeping to get accurate glyph data
            var _left   = -1;
            var _top    = -1;
            var _right  = bbox_right+1;
            var _bottom = bbox_bottom+1;
            
            while( !collision_line( _left , -1000  , _left , 1000   , id, true, false ) && ( _left < _right  ) ) _left++;
            while( !collision_line( -1000 , _top   , 1000  , _top   , id, true, false ) && ( _top  < _bottom ) ) _top++;
            while( !collision_line( _right, -1000  , _right, 1000   , id, true, false ) && ( _right  > _left ) ) _right--;
            while( !collision_line( -1000 , _bottom, 1000  , _bottom, id, true, false ) && ( _bottom > _top  ) ) _bottom--;
            _right++;
            _bottom++;
            
            var _array = array_create( __E_SCRIBBLE_GLYPH.__SIZE, 0 );
            
            _array[ __E_SCRIBBLE_GLYPH.CHAR ] = _char;                            // 0
            _array[ __E_SCRIBBLE_GLYPH.ORD  ] = ord( _char );                     // 1
            _array[ __E_SCRIBBLE_GLYPH.X    ] = undefined;                        // 2
            _array[ __E_SCRIBBLE_GLYPH.Y    ] = undefined;                        // 3
            _array[ __E_SCRIBBLE_GLYPH.W    ] = _right - _left;                   // 4
            _array[ __E_SCRIBBLE_GLYPH.H    ] = _bottom - _top;                   // 5
            _array[ __E_SCRIBBLE_GLYPH.DX   ] = _left;                            // 6
            _array[ __E_SCRIBBLE_GLYPH.DY   ] = _top;                             // 7
            _array[ __E_SCRIBBLE_GLYPH.SHF  ] = _right - _left + _shift_constant; // 8
            _array[ __E_SCRIBBLE_GLYPH.U0   ] = _uvs[0];                          // 9
            _array[ __E_SCRIBBLE_GLYPH.V0   ] = _uvs[1];                          //10
            _array[ __E_SCRIBBLE_GLYPH.U1   ] = _uvs[2];                          //11
            _array[ __E_SCRIBBLE_GLYPH.V1   ] = _uvs[3];                          //12
        
            _font_glyphs_map[? _char ] = _array;
    
        }
        
        sprite_index = -1;
        
        #endregion
        
    } else {
        
        #region Font
        
        var _texture = sprite_get_texture( _surface_sprite, 0 );
        var _texture_tw = texture_get_texel_width(  _texture );
        var _texture_th = texture_get_texel_height( _texture );
        
        global.__scribble_image_map[? _name ] = _surface_sprite;
        
        var _image_x_offset = global.__scribble_image_x_map[? _name ];
        var _image_y_offset = global.__scribble_image_y_map[? _name ];
        
        
        
        var _json_buffer = buffer_load( SCRIBBLE_FONT_DIRECTORY + _name + ".yy" );
        var _json_string = buffer_read( _json_buffer, buffer_text );
        buffer_delete( _json_buffer );
        var _json = json_decode( _json_string );
        
        
        
        var _font_glyphs_map = ds_map_create();
        ds_map_add_map( global.__scribble_glyphs_map, _name, _font_glyphs_map  );
        
        var _glyph_list = _json[? "glyphs" ];
        var _size = ds_list_size( _glyph_list );
        for( var _i = 0; _i < _size; _i++ ) {
        
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
        
        #endregion
        
    }
        
    show_debug_message( "Scribble: \"" + _name + "\" loaded" );
    
}



x = _old_x;
y = _old_y;
image_xscale = _old_image_xscale;
image_yscale = _old_image_yscale;