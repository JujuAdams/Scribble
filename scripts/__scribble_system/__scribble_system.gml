// Feather disable all

#macro __SCRIBBLE_DEBUG       false
#macro __SCRIBBLE_VERBOSE_GC  false

#macro __SCRIBBLE_FONT_GLYPH_STRIDE    (6*4*4)
#macro __SCRIBBLE_GEN_GLYPH_STRIDE     (6*4*7)
#macro __SCRIBBLE_FORMAT_GLYPH_STRIDE  (6*4*11)

#macro __SCRIBBLE_EASE_COUNT  12

#macro __SCRIBBLE_FLAG_GRAPHIC      0
#macro __SCRIBBLE_FLAG_ANIM_SPRITE  1
#macro __SCRIBBLE_FLAG_WAVE         2
#macro __SCRIBBLE_FLAG_SHAKE        3
#macro __SCRIBBLE_FLAG_WOBBLE       4
#macro __SCRIBBLE_FLAG_PULSE        5
#macro __SCRIBBLE_FLAG_WHEEL        6
#macro __SCRIBBLE_FLAG_CYCLE        7
#macro __SCRIBBLE_FLAG_JITTER       8
#macro __SCRIBBLE_FLAG_SLANT        9

#macro __SCRIBBLE_GLYPH_PROPR_CHARACTER      0
#macro __SCRIBBLE_GLYPH_PROPR_UNICODE        1
#macro __SCRIBBLE_GLYPH_PROPR_BIDI           2
#macro __SCRIBBLE_GLYPH_PROPR_X_OFFSET       3
#macro __SCRIBBLE_GLYPH_PROPR_Y_OFFSET       4
#macro __SCRIBBLE_GLYPH_PROPR_WIDTH          5
#macro __SCRIBBLE_GLYPH_PROPR_HEIGHT         6
#macro __SCRIBBLE_GLYPH_PROPR_FONT_HEIGHT    7
#macro __SCRIBBLE_GLYPH_PROPR_SEPARATION     8
#macro __SCRIBBLE_GLYPH_PROPR_LEFT_OFFSET    9
#macro __SCRIBBLE_GLYPH_PROPR_FONT_SCALE    10
#macro __SCRIBBLE_GLYPH_PROPR_MATERIAL      11
#macro __SCRIBBLE_GLYPH_PROPR_U0            12
#macro __SCRIBBLE_GLYPH_PROPR_U1            13
#macro __SCRIBBLE_GLYPH_PROPR_V0            14
#macro __SCRIBBLE_GLYPH_PROPR_V1            15
#macro __SCRIBBLE_GLYPH_PROPR_TEXELS_VALID  16

#macro __SCRIBBLE_GLYPH_PROPR_COUNT  17

#macro __SCRIBBLE_TAG_COLOR         0
#macro __SCRIBBLE_TAG_EFFECT        1
#macro __SCRIBBLE_TAG_EFFECT_UNSET  2
#macro __SCRIBBLE_TAG_EVENT         3
#macro __SCRIBBLE_TAG_MACRO         4

//This causes a failure to compile in YYC in IDE v2024.11.0.179 / Runtime v2024.11.0.227
//gml_pragma("MarkTagAsUsed", "scribble");



if (SCRIBBLE_INITIALIZE_ON_BOOT)
{
    __scribble_system();
}

function __scribble_system(_calledFromInitialize = false)
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    if (not SCRIBBLE_INITIALIZE_ON_BOOT)
    {
        if (not _calledFromInitialize)
        {
            __scribble_error("Scribble is not initialized. You must either:\n- Call `scribble_initialize()` first\n- Set `SCRIBBLE_INITIALIZE_ON_BOOT` to `true`");
            return;
        }
    }
    
    _system = {};
    with(_system)
    {
        __scribble_trace("Welcome to Scribble Deluxe by Juju Adams! This is version " + SCRIBBLE_VERSION + ", " + SCRIBBLE_DATE, " (GM version ", GM_runtime_version, ")");
        
        //Safety data structures. Theses exist at (hopefully) index 0 so that users can't accidentally
        //delete important parts of Scribble if they're sloppy with destroy functions.
        __protection_buffer = buffer_create(1, buffer_fixed, 1);
        __protection_map    = ds_map_create();
        __protection_grid   = ds_grid_create(1, 1);
        
        if (SCRIBBLE_VERBOSE)
        {
            __scribble_trace("Verbose mode is on");
        }
        else
        {
            if (SCRIBBLE_RUNNING_FROM_IDE)
            {
                __scribble_trace("Verbose mode is off, set SCRIBBLE_VERBOSE to <true> to see more information");
            }
        }
        
        if (not shader_is_compiled(__shd_scribble))
        {
            __scribble_error("Shader failed to compile. Please check your version of GameMaker is compatible\nPlease report this error if it persists");
        }
        
        if (SCRIBBLE_DETECT_MISSING_ASSETS)
        {
            if (not sprite_exists(asset_get_index("__scribble_sacrificial_asset")))
            {
                __scribble_error("Some assets have been detected as missing.\nThis probably means GameMaker has stripped assets during compile.\n \nThere are two solutions available:\n1. Add the \"scribble\" tag to every asset (font, sprite, sound, etc.) you want to use in Scribble\n    then set `SCRIBBLE_DETECT_MISSING_ASSETS` to `false` to turn off this warning;\n \n2. Or untick \"Automatically remove unused assets when compiling\" in Game Options");
            }
        }
        
        var _fontInfo = font_get_info(asset_get_index("scribble_fallback_font"));
        if (_fontInfo[$ "sdfEnabled"] == undefined)
        {
            __scribble_error("Versions of GameMaker without SDF font support are not supported");
        }
        
        try
        {
            time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function()
            {
                //We use an anonymous function here because directly calling __scribble_tick() fails on HTML5
                __scribble_tick();
            }, [], -1));
        }
        catch(_error)
        {
            __scribble_error("Versions of GameMaker without time sources are not supported");
        }
        
        try
        {
            handle_parse(string(__scribble_system));
        }
        catch(_error)
        {
            __scribble_error("Versions of GameMaker without handle_parse() are not supported");
        }
        
        __gmMightRemoveUnusedAssets = true;
        __gmVersionMajor = 0;
        __gmVersionMinor = 0;
        __gmVersionPatch = 0;
        __gmVersionBuild = 0;
        
        try
        {
            var _workString = GM_runtime_version;
            var _pos = string_pos(".", _workString);
            __gmVersionMajor = real(string_copy(_workString, 1, _pos-1));
            _workString = string_delete(_workString, 1, _pos);
            var _pos = string_pos(".", _workString);
            __gmVersionMinor = real(string_copy(_workString, 1, _pos-1));
            _workString = string_delete(_workString, 1, _pos);
            var _pos = string_pos(".", _workString);
            __gmVersionPatch = real(string_copy(_workString, 1, _pos-1));
            __gmVersionBuild = real(string_delete(_workString, 1, _pos));
        }
        catch(_error)
        {
            __scribble_trace("Warning! Failed to obtain runtime version");
        }
        
        __gmMightRemoveUnusedAssets = (__gmVersionMajor >= 2025) || ((__gmVersionMajor == 2024) && ((__gmVersionMinor >= 1100) || (__gmVersionMinor == 11)));
        
        __defaultPreprocessorFunc = __scribble_no_preprocessing;
        
        //Main lookup for fonts
        __font_data_map = ds_map_create();
        
        //Other caching maps
        __sprite_texture_index_map    = ds_map_create();
        __sprite_texture_material_map = ds_map_create();
        __material_map                = ds_map_create();
        
        //Multi-use buffers
        __buffer_a = buffer_create(1024, buffer_grow, 1);
        __buffer_b = buffer_create(1024, buffer_grow, 1);
        
        //Contains animation parameters. See scribble_anim_reset()
        __anim_properties = array_create(__SCRIBBLE_ANIM_SIZE, undefined);
        
        //Contains global state information that is shared between various features
        __state = {
            __frames: 0,
            
            __default_font: "scribble_fallback_font",
            
            __shader_anim_desync:            false,
            __shader_anim_desync_to_default: false,
            __shader_anim_default:           false,
            __shader_anim_disabled:          false,
            
            __sdf_thickness_offset: 0,
            
            __markdown_styles_struct: {},
            
            __sprite_whitelist_map: ds_map_create(),
            __sound_whitelist_map:  ds_map_create(),
        };
        
        //Contains state information for the Scribble cache
        __cache_state = {
            __mcache_dict:       {},
            __mcache_name_array: [],
            
            __ecache_dict:       {},
            __ecache_array:      [],
            __ecache_weak_array: [],
            __ecache_name_array: [],
            
            __gc_vbuff_refs: [],
            __gc_vbuff_ids:  [],
            
            __gc_grid_refs: [],
            __gc_grid_ids:  [],
        };
        
        //
        __generator_state = new __scribble_class_generator_state();
        
        //Contains Unicode data, necessary for extended language support
        __glyph_data                = __scribble_glyph_data_initialize();
        __krutidev_lookup_map       = __scribble_krutidev_lookup_map_initialize();
        __krutidev_matra_lookup_map = __scribble_krutidev_matra_lookup_map_initialize();
        
        //External sound reference storage
        __external_sprite_map = ds_map_create();
        __external_sound_map  = ds_map_create();
        
        __tagDict = {};
        
        //Pre-populated typist events
        __scribble_add_tag("pause",  __SCRIBBLE_TAG_EVENT, undefined, true);
        __scribble_add_tag("delay",  __SCRIBBLE_TAG_EVENT, undefined, true);
        __scribble_add_tag("sync",   __SCRIBBLE_TAG_EVENT, undefined, true);
        __scribble_add_tag("speed",  __SCRIBBLE_TAG_EVENT, undefined, true);
        __scribble_add_tag("/speed", __SCRIBBLE_TAG_EVENT, undefined, true);
        
        __scribble_add_tag("PAUSE",  __SCRIBBLE_TAG_EVENT, undefined, true);
        __scribble_add_tag("DELAY",  __SCRIBBLE_TAG_EVENT, undefined, true);
        __scribble_add_tag("SYNC",   __SCRIBBLE_TAG_EVENT, undefined, true);
        __scribble_add_tag("SPEED",  __SCRIBBLE_TAG_EVENT, undefined, true);
        __scribble_add_tag("/SPEED", __SCRIBBLE_TAG_EVENT, undefined, true);
        
        __scribble_add_tag("wave",   __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_WAVE,   true);
        __scribble_add_tag("shake",  __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_SHAKE,  true);
        __scribble_add_tag("wobble", __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_WOBBLE, true);
        __scribble_add_tag("pulse",  __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_PULSE,  true);
        __scribble_add_tag("wheel",  __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_WHEEL,  true);
        __scribble_add_tag("cycle",  __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_CYCLE,  true);
        __scribble_add_tag("jitter", __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_JITTER, true);
        __scribble_add_tag("slant",  __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_SLANT,  true);
        
        __scribble_add_tag("WAVE",   __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_WAVE,   true);
        __scribble_add_tag("SHAKE",  __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_SHAKE,  true);
        __scribble_add_tag("WOBBLE", __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_WOBBLE, true);
        __scribble_add_tag("PULSE",  __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_PULSE,  true);
        __scribble_add_tag("WHEEL",  __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_WHEEL,  true);
        __scribble_add_tag("CYCLE",  __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_CYCLE,  true);
        __scribble_add_tag("JITTER", __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_JITTER, true);
        __scribble_add_tag("SLANT",  __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_SLANT,  true);
        
        __scribble_add_tag("/wave",   __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_WAVE,   true);
        __scribble_add_tag("/shake",  __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_SHAKE,  true);
        __scribble_add_tag("/wobble", __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_WOBBLE, true);
        __scribble_add_tag("/pulse",  __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_PULSE,  true);
        __scribble_add_tag("/wheel",  __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_WHEEL,  true);
        __scribble_add_tag("/cycle",  __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_CYCLE,  true);
        __scribble_add_tag("/jitter", __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_JITTER, true);
        __scribble_add_tag("/slant",  __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_SLANT,  true);
        
        __scribble_add_tag("/WAVE",   __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_WAVE,   true);
        __scribble_add_tag("/SHAKE",  __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_SHAKE,  true);
        __scribble_add_tag("/WOBBLE", __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_WOBBLE, true);
        __scribble_add_tag("/PULSE",  __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_PULSE,  true);
        __scribble_add_tag("/WHEEL",  __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_WHEEL,  true);
        __scribble_add_tag("/CYCLE",  __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_CYCLE,  true);
        __scribble_add_tag("/JITTER", __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_JITTER, true);
        __scribble_add_tag("/SLANT",  __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_SLANT,  true);
        
        var _colorStruct = __scribble_config_colours();
        var _namesArray = variable_struct_get_names(_colorStruct);
        var _i = 0;
        repeat(array_length(_namesArray))
        {
            var _name = _namesArray[_i];
            __scribble_add_tag(_name, __SCRIBBLE_TAG_COLOR, _colorStruct[$ _name], false);
            ++_i;
        }
        
        __cycle_surface = -1;
        __cycle_data_open_array = [];
        __cycle_data_map = ds_map_create();
        scribble_cycle_add_from_array(SCRIBBLE_RAINBOW_CYCLE, [c_red, c_yellow, c_lime, c_aqua, c_blue, c_fuchsia], true, false);
        
        //Unpack texture group data into an easy-to-use dictionary. This should, of course, just be a native
        //feature of GameMaker. I, in fact, suggested such a feature (including sprites (and backgrounds!))
        //back in 2018 when working on The Swords Of Ditto in GameMaker Studio 1.4.
        __font_to_texture_group_map = ds_map_create();
        
        var _tg_name_array = texturegroup_get_names();
        var _i = 0;
        repeat(array_length(_tg_name_array))
        {
            var _tg_name = _tg_name_array[_i];
            var _font_index_array = texturegroup_get_fonts(_tg_name);
            
            var _j = 0;
            repeat(array_length(_font_index_array))
            {
                __font_to_texture_group_map[? _font_index_array[_j]] = _tg_name;
                ++_j;
            }
            
            ++_i;
        }
    }
    
    if (GM_build_type == "run")
    {
        global.__Scribble = _system;
    }
    
    scribble_anim_reset();
    __scribble_font_add_all_from_bundle();
    
    return _system;
}