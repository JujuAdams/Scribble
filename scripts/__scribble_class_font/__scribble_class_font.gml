/// @param assetName
/// @param friendlyName
/// @param glyphCount

function __scribble_class_font(_asset_name, _friendly_name, _glyph_count) constructor
{
    __asset_name = _asset_name;
    __name       = _friendly_name;
    __filename   = undefined;
    
    
    
    __scribble_font_check_name_conflicts(__name);
    static _font_data_map = __scribble_get_state().__font_data_map;
    _font_data_map[? __name] = self;
    
    
    
    __glyph_data_grid = ds_grid_create(_glyph_count, __SCRIBBLE_GLYPH.__SIZE); //We use a grid here to allow us to copy data more quickly during parsing
    __glyphs_map      = ds_map_create(); //We use a map here because our keys are numbers and I don't trust struct performance
    __kerning_map     = ds_map_create(); //We use a map here because our keys are numbers and I don't trust struct performance
    
    __is_krutidev = false;
    
    __material = new __scribble_class_material(__name);
    
    __type_standard  = false; //Native GameMaker font. As of 2023-04-07 these can never be SDF fonts but this may change in the future
    __type_sprite    = false; //Spritefont added via the native GameMaker function. Always a "runtime" font as well
    __type_sdf       = false; //SDF font. At the moment, this type can only be added by scribble_font_add()
    __type_font_add  = false; //Added by scribble_font_add(). Always a "runtime" font as well
    __type_runtime   = false; //Added during runtime - effectively all this means is "when the font is destroyed, do we have stuff to clean up?"
    __type_superfont = false; //Whether this font contains glyph cobbled together from multiple sources
    
    __baked_effect_sprite = undefined;
    
    __scale  = 1.0;
    __height = 0; //This is the effective height and *not* the raw height (i.e. this value is changed by scribble_font_scale())
    
    __style_regular     = undefined;
    __style_bold        = undefined;
    __style_italic      = undefined;
    __style_bold_italic = undefined;
    
    __font_add_cache_array = array_create(SCRIBBLE_FONT_GROUP.__SIZE, undefined);
    
    
    
    static toString = function()
    {
        return __asset_name;
    }
    
    static __set_sdf_thickness_offset = function(_offset, _relative, _weak)
    {
        if (__type_sdf)
        {
            __material.__set_sdf_thickness_offset(_offset, _relative);
        }
        else
        {
            if (!_weak) __scribble_trace("Cannot set SDF range offset for font \"", __asset_name, "\", it's not an SDF font");
        }
        
        return self;
    }
    
    static __get_sdf_thickness_offset = function()
    {
        return __material.__get_sdf_thickness_offset();
    }
    
    static __copy_to = function(_target, _copy_styles)
    {
        var _names = variable_struct_get_names(self);
        var _i = 0;
        repeat(array_length(_names))
        {
            var _name = _names[_i];
            if ((_name == "__glyphs_map")
            ||  (_name == "__kerning_map"))
            {
                ds_map_copy(_target.__glyphs_map, __glyphs_map);
            }
            else if (_name == "__glyph_data_grid")
            {
                ds_grid_copy(_target.__glyph_data_grid, __glyph_data_grid);
            }
            else if ((_name != "__asset_name")
                 &&  (_name != "__name")
                 &&  (_name != "__filename")
                 &&  (_name != "__material")
                 &&  (_copy_styles || ((_name != "__style_regular") && (_name != "__style_bold") && (_name != "__style_italic") && (_name != "__style_bold_italic"))))
            {
                _target[$ _name] = self[$ _name];
            }
            
            ++_i;
        }
    }
    
    static __calculate_font_height = function()
    {
        __height = __glyph_data_grid[# (__glyphs_map[? 32] ?? 0), __SCRIBBLE_GLYPH.__HEIGHT];
        return __height;
    }
    
    static __superfont_clear = function()
    {
        if (!__type_superfont) __scribble_error("Cannot clear non-superfont fonts");
        
        ds_map_clear(__glyphs_map);
        ds_map_clear(__kerning_map);
        
        __material = new __scribble_class_material(__name);
        
        __type_standard = false;
        __type_sprite   = false;
        __type_sdf      = false;
        
        __baked_effect_sprite = undefined;
        
        __scale  = 1.0;
        __height = 0; //This is the effective height and *not* the raw height (i.e. this value is changed by scribble_font_scale())
        
        __style_regular     = undefined;
        __style_bold        = undefined;
        __style_italic      = undefined;
        __style_bold_italic = undefined;
        
        __font_add_cache_array = undefined;
        
        __material.__sdf        = undefined;
        __material.__sdf_spread = undefined;
        
        __height = 0;
    }
    
    static __set_bilinear = function(_state)
    {
        if (_state == undefined)
        {
            if (__type_sdf)
            {
                _state = true;
            }
            else if (__type_sprite)
            {
                _state = SCRIBBLE_DEFAULT_SPRITEFONT_BILINEAR;
            }
            else
            {
                _state = SCRIBBLE_DEFAULT_STANDARD_BILINEAR;
            }
        }
        
        __material.__bilinear = _state;
    }
    
    static __destroy = function()
    {
        if (__SCRIBBLE_DEBUG) __scribble_trace("Destroying font \"", __name, "\"");
        
        ds_map_destroy(__glyphs_map);
        ds_map_destroy(__kerning_map);
        ds_grid_destroy(__glyph_data_grid);
        
        static _font_data_map           = __scribble_get_state().__font_data_map;
        static _font_original_name_dict = __scribble_get_state().__font_original_name_dict;
        
        ds_map_delete(_font_data_map, __name);
        variable_struct_remove(_font_original_name_dict, __asset_name);
        
        if (__baked_effect_sprite != undefined)
        {
            sprite_delete(__baked_effect_sprite);
            __baked_effect_sprite = undefined;
        }
        
        if (__font_add_cache_array != undefined)
        {
            //Destroy font_add caches
            var _i = 0;
            repeat(array_length(__font_add_cache_array))
            {
                var _font_add_cache = __font_add_cache_array[_i];
                if (_font_add_cache != undefined) _font_add_cache.__destroy();
                ++_i;
            }
            
            __font_add_cache_array = undefined;
        }
    }
}