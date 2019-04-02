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

if ( !variable_global_exists("__scribble_init_complete" ) )
{
    show_error("Scribble:\n\nscribble_init_end() should be called after scribble_init_start()\n ", false);
    exit;
}

show_debug_message("\nScribble: Font initialisation started");



var _old_x = x;
var _old_y = y;
var _old_mask_index = mask_index;
x = 0;
y = 0;



#region Work out if we're in version 2.2.1 or later

var _string = GM_runtime_version;

var _major = string_copy(_string, 1, string_pos(".", _string)-1);
 _string = string_delete(_string, 1, string_pos(".", _string));

var _minor = string_copy(_string, 1, string_pos(".", _string)-1);
 _string = string_delete(_string, 1, string_pos(".", _string));

var _patch = string_copy(_string, 1, string_pos(".", _string)-1);

//var _rev = string_delete(_string, 1, string_pos(".", _string));

var _later_than_gms220 = (( (real(_major) > 2) || (real(_minor) > 2) ) || ( (real(_major) == 2) && (real(_minor) == 2) && (real(_patch) > 0) ));
if (_later_than_gms220)
{
    show_debug_message("Scribble:   Legacy (GMS2.2.0 and prior) spritefont emulation available");
    if (SCRIBBLE_EMULATE_LEGACY_SPRITEFONT_SPACING)
    {
        show_debug_message("Scribble:   Using legacy spritefont emulation");
    }
    else
    {
        show_debug_message("Scribble:   *Not* using legacy spritefont emulation");
    }
}

#endregion



var _font_count = ds_map_size(global.__scribble_font_data);
var _name = ds_map_find_first(global.__scribble_font_data);
repeat(_font_count)
{
    var _font_data = global.__scribble_font_data[? _name ];
    
    switch(_font_data[ __E_SCRIBBLE_FONT.TYPE ])
    {
        case __E_SCRIBBLE_FONT_TYPE.SPRITE:
        #region Spritefont
        
        show_debug_message("Scribble:   Processing spritefont \"" + _name + "\"");
        
        var _sprite = asset_get_index(_name);
        _font_data[@ __E_SCRIBBLE_FONT.TEXTURE ] = sprite_get_texture(_sprite, 0);
        
        if (sprite_get_bbox_left(  _sprite) == 0)
        || (sprite_get_bbox_top(   _sprite) == 0)
        || (sprite_get_bbox_right( _sprite) == sprite_get_width(_sprite)-1)
        || (sprite_get_bbox_bottom(_sprite) == sprite_get_height(_sprite)-1)
        {
            show_debug_message("Scribble:     WARNING! \"" + _name + "\" may be rendered incorrectly due to the bounding box overlapping the edge of the sprite. Please add at least a 1px border around your spritefont sprite. Please also update the bounding box if needed");
        }
        
        var _sprite_string  = _font_data[ __E_SCRIBBLE_FONT.MAPSTRING   ];
        var _shift_constant = _font_data[ __E_SCRIBBLE_FONT.SEPARATION  ];
        var _space_width    = _font_data[ __E_SCRIBBLE_FONT.SPACE_WIDTH ];
        
        var _font_glyphs_map = ds_map_create();
        _font_data[@ __E_SCRIBBLE_FONT.GLYPHS_MAP ] = _font_glyphs_map;
        
        if (SCRIBBLE_EMULATE_LEGACY_SPRITEFONT_SPACING && _later_than_gms220) _shift_constant -= 2;
        if (SCRIBBLE_COMPATIBILITY_DRAW) global.__scribble_spritefont_map[? _name ] = font_add_sprite_ext(_sprite, _sprite_string, true, _shift_constant);
        
        sprite_index = _sprite;
        mask_index   = _sprite;
        x = -sprite_get_xoffset(_sprite);
        y = -sprite_get_yoffset(_sprite);
        
        //Strip out a map of of glyphs
        var _length = string_length(_sprite_string);
        show_debug_message("Scribble:     \"" + _name + "\" has " + string(_length) + " characters");
        for(var _i = 0; _i < _length; _i++)
        {
            var _char = string_char_at(_sprite_string, _i+1);
            if ( ds_map_exists(_font_glyphs_map, _char) ) continue;
            if (_char == " ") show_debug_message("Scribble:     WARNING! It is strongly recommended that you do *not* use a space character in your sprite font in GMS2.2.1 and above due to IDE bugs. Use scribble_font_char_set_*() to define a space character");
            
            image_index = _i;
            var _uvs = sprite_get_uvs(_sprite, image_index);
            
            //Perform line sweeping to get accurate glyph data
            var _left   = bbox_left-1;
            var _top    = bbox_top-1;
            var _right  = bbox_right+1;
            var _bottom = bbox_bottom+1;
            
            while( !collision_line(      _left, bbox_top-1,        _left, bbox_bottom+1, id, true, false) && (_left < _right ) ) ++_left;
            while( !collision_line(bbox_left-1,       _top, bbox_right+1,          _top, id, true, false) && (_top  < _bottom) ) ++_top;
            while( !collision_line(     _right, bbox_top-1,       _right, bbox_bottom+1, id, true, false) && (_right  > _left) ) --_right;
            while( !collision_line(bbox_left-1,    _bottom, bbox_right+1,       _bottom, id, true, false) && (_bottom > _top ) ) --_bottom;
            
            //Build an array to store this glyph's properties
            var _array = array_create(__E_SCRIBBLE_GLYPH.__SIZE, 0);
            _array[ __E_SCRIBBLE_GLYPH.CHAR ] = _char;
            _array[ __E_SCRIBBLE_GLYPH.ORD  ] = ord(_char);
            
            if (_left == _right) && (_top == _bottom)
            {
                show_debug_message("Scribble:     WARNING! Character " + string(ord(_char)) + "(" + _char + ") for sprite font \"" + _name + "\" is empty");
                
                _array[ __E_SCRIBBLE_GLYPH.W   ] = 1;
                _array[ __E_SCRIBBLE_GLYPH.H   ] = sprite_get_height(_sprite);
                _array[ __E_SCRIBBLE_GLYPH.DX  ] = 0;
                _array[ __E_SCRIBBLE_GLYPH.DY  ] = 0;
                _array[ __E_SCRIBBLE_GLYPH.SHF ] = 1 + _shift_constant;
                _array[ __E_SCRIBBLE_GLYPH.U0  ] = 0;
                _array[ __E_SCRIBBLE_GLYPH.V0  ] = 0;
                _array[ __E_SCRIBBLE_GLYPH.U1  ] = 0;
                _array[ __E_SCRIBBLE_GLYPH.V1  ] = 0;
                _font_glyphs_map[? _char ] = _array;
            }
            else
            {
                if (_later_than_gms220)
                {
                    //GMS2.2.1 does some weeeird things to sprite fonts
                    var _glyph_width  = 3 + _right - _left;
                    var _glyph_height = 3 + _bottom - _top;
                    _array[ __E_SCRIBBLE_GLYPH.W   ] = _glyph_width;
                    _array[ __E_SCRIBBLE_GLYPH.H   ] = _glyph_height;
                    _array[ __E_SCRIBBLE_GLYPH.DX  ] = _left - bbox_left;
                    _array[ __E_SCRIBBLE_GLYPH.DY  ] = _top-1;
                    _array[ __E_SCRIBBLE_GLYPH.SHF ] = _glyph_width + _shift_constant;
                    _array[ __E_SCRIBBLE_GLYPH.U0  ] = _uvs[0];
                    _array[ __E_SCRIBBLE_GLYPH.V0  ] = _uvs[1];
                    _array[ __E_SCRIBBLE_GLYPH.U1  ] = _uvs[2];
                    _array[ __E_SCRIBBLE_GLYPH.V1  ] = _uvs[3];
                }
                else
                {
                    --_left;
                    ++_bottom;
                    var _glyph_width  = _right - _left;
                    var _glyph_height = _bottom - _top;
                    _array[ __E_SCRIBBLE_GLYPH.W   ] = _glyph_width;
                    _array[ __E_SCRIBBLE_GLYPH.H   ] = _glyph_height;
                    _array[ __E_SCRIBBLE_GLYPH.DX  ] = _left;
                    _array[ __E_SCRIBBLE_GLYPH.DY  ] = _top;
                    _array[ __E_SCRIBBLE_GLYPH.SHF ] = _glyph_width + _shift_constant;
                    _array[ __E_SCRIBBLE_GLYPH.U0  ] = _uvs[0];
                    _array[ __E_SCRIBBLE_GLYPH.V0  ] = _uvs[1];
                    _array[ __E_SCRIBBLE_GLYPH.U1  ] = _uvs[2];
                    _array[ __E_SCRIBBLE_GLYPH.V1  ] = _uvs[3];
                }
                
                _font_glyphs_map[? _char ] = _array;
            }
        }
        
        if ( !ds_map_exists(_font_glyphs_map, " ") )
        {
            if (_later_than_gms220)
            {
                var _glyph_width  = sprite_get_width(_sprite);
                var _glyph_height = sprite_get_height(_sprite);
            }
            else
            {
                var _glyph_width  = sprite_get_width(_sprite)-2;
                var _glyph_height = sprite_get_height(_sprite);
            }
            
            //Build an array to store this glyph's properties
            var _array = array_create(__E_SCRIBBLE_GLYPH.__SIZE, 0);
            _array[ __E_SCRIBBLE_GLYPH.CHAR ] = " ";
            _array[ __E_SCRIBBLE_GLYPH.ORD  ] = 32;
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
        
        if (_space_width != undefined)
        {
            var _array = _font_glyphs_map[? " " ];
            _array[@ __E_SCRIBBLE_GLYPH.W   ] = _space_width;
            _array[@ __E_SCRIBBLE_GLYPH.SHF ] = _space_width;
        }
        
        sprite_index = -1;
        
        #endregion
        break;
        
        case __E_SCRIBBLE_FONT_TYPE.FONT:
        #region Font
        
        show_debug_message("Scribble:   Processing font \"" + _name + "\"");
        
        var _asset = asset_get_index(_name);
        if (_asset < 0)
        {
            show_error("Scribble:\n\nFont \"" + _name + "\" was not found in the project!\n ", true);
            exit;
        }
        
        var _json_file  = global.__scribble_font_directory + _name + ".yy";
        if ( !file_exists(_json_file) )
        {
            show_error("Scribble:\n\nCould not find \"" + _json_file + "\" in Included Files.\nPlease add this file to your project.\n ", true);
            exit;
        }
        
        var _texture     = font_get_texture(_asset);
        var _texture_uvs = font_get_uvs(_asset);
        var _texture_tw  = texture_get_texel_width(_texture);
        var _texture_th  = texture_get_texel_height(_texture);
        var _texture_w   = texture_get_width(_texture);
        var _texture_h   = texture_get_height(_texture);
        _font_data[@ __E_SCRIBBLE_FONT.TEXTURE ] = _texture;
        
        show_debug_message("Scribble:     \"" + _name +"\""
                         + ", texture= " + string(_texture)
                         + ", size= " + string(_texture_w) + " x " + string(_texture_h)
                         + ", texel= " + string_format(_texture_tw, 1, 10) + " x " + string_format(_texture_th, 1, 10)
                         + ", uvs= " + string_format(_texture_uvs[0], 1, 10) + "," + string_format(_texture_uvs[1], 1, 10)
                         + " -> " + string_format(_texture_uvs[2], 1, 10) + "," + string_format(_texture_uvs[3], 1, 10));
        
        
        
        var _json_buffer = buffer_load(global.__scribble_font_directory + _name + ".yy");
        var _json_string = buffer_read(_json_buffer, buffer_text);
        buffer_delete(_json_buffer);
        var _json = json_decode(_json_string);
        
        
        
        var _yy_glyph_list = _json[? "glyphs" ];
        var _size = ds_list_size(_yy_glyph_list);
        show_debug_message("Scribble:     \"" + _name + "\" has " + string(_size) + " characters");
        
        
        
        var _ds_map_fallback = true;
        
        if (__SCRIBBLE_TRY_SEQUENTIAL_GLYPH_INDEX)
        {
            #region Sequential glyph index
            
            show_debug_message("Scribble:     Trying sequential glyph index...");
            
            var _glyph_map = ds_map_create();
            
            var _yy_glyph_map = _yy_glyph_list[| 0];
                _yy_glyph_map = _yy_glyph_map[? "Value" ];
            
            var _glyph_min = _yy_glyph_map[? "character" ];
            var _glyph_max = _glyph_min;
            _glyph_map[? _glyph_min ] = 0;
            
            for(var _i = 1; _i < _size; _i++)
            {
                var _yy_glyph_map = _yy_glyph_list[| _i ];
                    _yy_glyph_map = _yy_glyph_map[? "Value" ];
                var _index = _yy_glyph_map[? "character" ];
                
                _glyph_map[? _index ] = _i;
                _glyph_min = min(_glyph_min, _index);
                _glyph_max = max(_glyph_max, _index);
            }
            
            _font_data[@ __E_SCRIBBLE_FONT.GLYPH_MIN ] = _glyph_min;
            _font_data[@ __E_SCRIBBLE_FONT.GLYPH_MAX ] = _glyph_max;
            
            var _glyph_count = 1 + _glyph_max - _glyph_min;
            show_debug_message("Scribble:     Glyphs start at " + string(_glyph_min) + " and end at " + string(_glyph_max) + ". Range is " + string(_glyph_count-1));
            
            if ((_glyph_count-1) > SCRIBBLE_SEQUENTIAL_GLYPH_MAX_RANGE)
            {
                show_debug_message("Scribble:     Glyph range exceeds maximum (" + string(SCRIBBLE_SEQUENTIAL_GLYPH_MAX_RANGE) + ")!");
            }
            else
            {
                var _holes = 0;
                for(var _i = _glyph_min; _i <= _glyph_max; _i++) if ( !ds_map_exists(_glyph_map, _i) ) _holes++;
                ds_map_destroy(_glyph_map);
                var _fraction = _holes / _glyph_count;
                
                show_debug_message("Scribble:     There are " + string(_holes) + " holes, " + string(_fraction*100) + "%");
                
                if (_fraction > SCRIBBLE_SEQUENTIAL_GLYPH_MAX_HOLES)
                {
                    show_debug_message("Scribble: Hole proportion exceeds maximum (" + string(SCRIBBLE_SEQUENTIAL_GLYPH_MAX_HOLES*100) + "%)!");
                }
                else
                {
                    show_debug_message("Scribble:     Using an array to index glyphs");
                    _ds_map_fallback = false;
                    
                    var _font_glyphs_array = array_create(_glyph_count, undefined);
                    _font_data[@ __E_SCRIBBLE_FONT.GLYPHS_ARRAY ] = _font_glyphs_array;
                    
                    for(var _i = 0; _i < _size; _i++)
                    {
                        var _yy_glyph_map = _yy_glyph_list[| _i ];
                            _yy_glyph_map = _yy_glyph_map[? "Value" ];
                        
                        var _index = _yy_glyph_map[? "character" ];
                        var _char  = chr(_index);
                        var _x     = _yy_glyph_map[? "x" ];
                        var _y     = _yy_glyph_map[? "y" ];
                        var _w     = _yy_glyph_map[? "w" ];
                        var _h     = _yy_glyph_map[? "h" ];
                        
                        var _u0    = _x*_texture_tw + _texture_uvs[0];
                        var _v0    = _y*_texture_th + _texture_uvs[1];
                        var _u1    = _u0 + _w * _texture_tw;
                        var _v1    = _v0 + _h * _texture_th;
                        
                        var _array = array_create(__E_SCRIBBLE_GLYPH.__SIZE, 0);
                        _array[ __E_SCRIBBLE_GLYPH.CHAR ] = _char;
                        _array[ __E_SCRIBBLE_GLYPH.ORD  ] = _index;
                        _array[ __E_SCRIBBLE_GLYPH.W    ] = _w;
                        _array[ __E_SCRIBBLE_GLYPH.H    ] = _h;
                        _array[ __E_SCRIBBLE_GLYPH.DX   ] = _yy_glyph_map[? "offset" ];
                        _array[ __E_SCRIBBLE_GLYPH.DY   ] = 0;
                        _array[ __E_SCRIBBLE_GLYPH.SHF  ] = _yy_glyph_map[? "shift" ];
                        _array[ __E_SCRIBBLE_GLYPH.U0   ] = _u0;
                        _array[ __E_SCRIBBLE_GLYPH.V0   ] = _v0;
                        _array[ __E_SCRIBBLE_GLYPH.U1   ] = _u1;
                        _array[ __E_SCRIBBLE_GLYPH.V1   ] = _v1;
                        
                        _font_glyphs_array[@ _index - _glyph_min ] = _array;
                    }
                }
            }
            
            #endregion
        }
        
        if (_ds_map_fallback)
        {
            show_debug_message("Scribble:     Using a ds_map to index glyphs");
            
            var _font_glyphs_map = ds_map_create();
            _font_data[@ __E_SCRIBBLE_FONT.GLYPHS_MAP ] = _font_glyphs_map;
            
            for(var _i = 0; _i < _size; _i++)
            {
                var _yy_glyph_map = _yy_glyph_list[| _i ];
                    _yy_glyph_map = _yy_glyph_map[? "Value" ];
                
                var _index = _yy_glyph_map[? "character" ];
                var _char  = chr(_index);
                var _x     = _yy_glyph_map[? "x" ];
                var _y     = _yy_glyph_map[? "y" ];
                var _w     = _yy_glyph_map[? "w" ];
                var _h     = _yy_glyph_map[? "h" ];
                
                var _u0    = _x*_texture_tw + _texture_uvs[0];
                var _v0    = _y*_texture_th + _texture_uvs[1];
                var _u1    = _u0 + _w*_texture_tw;
                var _v1    = _v0 + _h*_texture_th;
                
                var _array = array_create(__E_SCRIBBLE_GLYPH.__SIZE, 0);
                _array[ __E_SCRIBBLE_GLYPH.CHAR ] = _char;
                _array[ __E_SCRIBBLE_GLYPH.ORD  ] = _index;
                _array[ __E_SCRIBBLE_GLYPH.W    ] = _w;
                _array[ __E_SCRIBBLE_GLYPH.H    ] = _h;
                _array[ __E_SCRIBBLE_GLYPH.DX   ] = _yy_glyph_map[? "offset" ];
                _array[ __E_SCRIBBLE_GLYPH.DY   ] = 0;
                _array[ __E_SCRIBBLE_GLYPH.SHF  ] = _yy_glyph_map[? "shift" ];
                _array[ __E_SCRIBBLE_GLYPH.U0   ] = _u0;
                _array[ __E_SCRIBBLE_GLYPH.V0   ] = _v0;
                _array[ __E_SCRIBBLE_GLYPH.U1   ] = _u1;
                _array[ __E_SCRIBBLE_GLYPH.V1   ] = _v1;
                
                _font_glyphs_map[? _char ] = _array;
            }
        }
        
        ds_map_destroy(_json);
        
        #endregion
        break;
    }
    
    //show_debug_message("Scribble: \"" + _name + "\" finished");
    
    _name = ds_map_find_next(global.__scribble_font_data, _name);
}



x = _old_x;
y = _old_y;
mask_index = _old_mask_index;



show_debug_message("Scribble:   Font initialisation complete, took " + string((get_timer() - _timer)/1000) + "ms");
show_debug_message("Scribble: Thanks for using Scribble!\n");

global.__scribble_init_complete = true;