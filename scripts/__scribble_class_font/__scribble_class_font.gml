// Feather disable all

/// @param fontName
/// @param glyphCount
/// @param renderType
/// @param fromBundle
/// @param texelsValid

function __scribble_class_font(_name, _glyph_count, _render_type, _from_bundle, _texels_valid) constructor
{
    //The name of the font. This is the alias used to reference the font elsewhere
    __name = _name;
    
    //One of the `__SCRIBBLE_RENDER_*` macros. Largely used to determine which shader path to use
    __render_type = _render_type; //FIXME: Why is this camelCase, Juju?
    
    //Whether the source texture data exists in the asset bundle. If set to `false`, the source
    //texture data was added at runtime (probably with `sprite_add()`). This value can be `undefined`
    //if the origin is not known (typically spritefonts).
    __from_bundle = _from_bundle;
    
    //Whether the source texture is ready - loaded into RAM and fetched into VRAM
    __texels_valid = _texels_valid;
    
    static _font_data_map = __scribble_system().__font_data_map;
    _font_data_map[? _name] = self;
    
    __glyph_data_grid = ds_grid_create(_glyph_count, SCRIBBLE_GLYPH.__SIZE);
    __glyphs_map      = ds_map_create();
    __kerning_map     = ds_map_create();
    
    __is_krutidev = false;
    __bilinear    = (__render_type == __SCRIBBLE_RENDER_SDF)? true : undefined;
    
    __superfont     = false;
    __runtime       = false;
    __source_sprite = undefined;
    __remap         = undefined;
    
    __scale           = 1.0;
    __height          = 0; //*Not* the raw height. This value is changed by scribble_font_scale()
    __ascender        = 0;
    __ascender_offset = 0;
    
    __halign_offset_array = [0, 0, 0,   0, 0, 0, 0];
    __valign_offset_array = [0, 0, 0,   0, 0, 0];
    
    __style_regular     = undefined;
    __style_bold        = undefined;
    __style_italic      = undefined;
    __style_bold_italic = undefined;
    
    
    
    
    
    static __copy_to = function(_target, _copy_styles)
    {
        var _names = variable_struct_get_names(self);
        var _i = 0;
        repeat(array_length(_names))
        {
            var _name = _names[_i];
            if (_name == "__glyphs_map")
            {
                ds_map_copy(_target.__glyphs_map, __glyphs_map);
            }
            else if (_name == "__glyph_data_grid")
            {
                ds_grid_copy(_target.__glyph_data_grid, __glyph_data_grid);
            }
            else if ((_name != "__name")
                  && (_name != "__from_bundle")
                  && (_copy_styles || ((_name != "__style_regular") && (_name != "__style_bold") && (_name != "__style_italic") && (_name != "__style_bold_italic"))))
            {
                variable_struct_set(_target, _name, variable_struct_get(self, _name));
            }
            
            ++_i;
        }
    }
    
    static __clear = function()
    {
        if (!__superfont) __scribble_error("Cannot clear non-superfont fonts");
        
        ds_map_clear(__glyphs_map);
        
        __height = 0;
        __texels_valid = false;
    }
    
    static __ensure_material_textures_fetched = function()
    {
        //N.B. This is an expensive function! Use sparingly
        
        var _glyph_data_grid = __glyph_data_grid;
        var _glyph_count = ds_grid_width(_glyph_data_grid);
        
        //TODO - Use some kind of cool optimization if the font is a standard font and every glyph has the same material
        
        var _i = 0;
        repeat(_glyph_count)
        {
            var _material = _glyph_data_grid[# _i, SCRIBBLE_GLYPH.MATERIAL];
            var _texture_index = _material.__texture;
            if (_texture_index != undefined)
            {
                texture_prefetch(_texture_index);
            }
            
            ++_i;
        }
    }
    
    static __ensure_texel_data = function()
    {
        if (__texels_valid) return;
        
        var _glyph_data_grid = __glyph_data_grid;
        var _glyph_count = ds_grid_width(_glyph_data_grid);
        
        if (not ds_grid_value_exists(_glyph_data_grid, 0, SCRIBBLE_GLYPH.TEXELS_VALID, _glyph_count-1, SCRIBBLE_GLYPH.TEXELS_VALID, false))
        {
            //Don't do any extra work if every texel is valid
            __texels_valid = true;
            return;
        }
        
        //TODO - Use some kind of cool optimization if the font is a standard font and every glyph has the same material
        
        var _all_ready = true;
        var _i = 0;
        repeat(_glyph_count)
        {
            if (not _glyph_data_grid[# _i, SCRIBBLE_GLYPH.TEXELS_VALID])
            {
                var _material = _glyph_data_grid[# _i, SCRIBBLE_GLYPH.MATERIAL];
                
                var _texture_index = _material.__texture;
                if ((_texture_index != undefined) && texture_is_ready(_texture_index))
                {
                    _glyph_data_grid[# _i, SCRIBBLE_GLYPH.TEXELS_VALID] = true;
                    
                    var _texel_w = texture_get_texel_width(_texture_index);
                    var _texel_h = texture_get_texel_height(_texture_index);
                    
                    _glyph_data_grid[# _i, SCRIBBLE_GLYPH.U0] *= _texel_w;
                    _glyph_data_grid[# _i, SCRIBBLE_GLYPH.V0] *= _texel_h;
                    _glyph_data_grid[# _i, SCRIBBLE_GLYPH.U1] *= _texel_w;
                    _glyph_data_grid[# _i, SCRIBBLE_GLYPH.V1] *= _texel_h;
                }
                else
                {
                    _all_ready = false;
                }
            }
            
            ++_i;
        }
        
        if (_all_ready)
        {
            __texels_valid = true;
        }
    }
    
    static __destroy = function()
    {
        if (__SCRIBBLE_DEBUG) __scribble_trace("Destroying font \"", __name, "\"");
        
        ds_map_destroy(__glyphs_map);
        ds_grid_destroy(__glyph_data_grid);
        
        ds_map_delete(_font_data_map, __name);
        
        if (__source_sprite != undefined)
        {
            sprite_delete(__source_sprite);
            __source_sprite = undefined;
        }
    }
}
