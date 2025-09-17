// Feather disable all

//This causes a failure to compile in YYC in IDE v2024.11.0.179 / Runtime v2024.11.0.227
//gml_pragma("MarkTagAsUsed", "scribble");



if (SCRIBBLE_INITIALIZE_ON_BOOT)
{
    __ScribbleSystem();
}

function __ScribbleSystem(_calledFromInitialize = false)
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    if (not SCRIBBLE_INITIALIZE_ON_BOOT)
    {
        if (not _calledFromInitialize)
        {
            __ScribbleError("Scribble is not initialized. You must either:\n- Call `scribble_initialize()` first\n- Set `SCRIBBLE_INITIALIZE_ON_BOOT` to `true`");
            return;
        }
    }
    
    _system = {};
    with(_system)
    {
        __ScribbleTrace("Welcome to Scribble Deluxe by Juju Adams! This is version " + SCRIBBLE_VERSION + ", " + SCRIBBLE_DATE, " (GM version ", GM_runtime_version, ")");
        
        //Safety data structures. Theses exist at (hopefully) index 0 so that users can't accidentally
        //delete important parts of Scribble if they're sloppy with destroy functions.
        __protection_buffer = buffer_create(1, buffer_fixed, 1);
        __protection_map    = ds_map_create();
        __protection_grid   = ds_grid_create(1, 1);
        
        if (SCRIBBLE_VERBOSE)
        {
            __ScribbleTrace("Verbose mode is on");
        }
        else
        {
            if (SCRIBBLE_RUNNING_FROM_IDE)
            {
                __ScribbleTrace("Verbose mode is off, set SCRIBBLE_VERBOSE to <true> to see more information");
            }
        }
        
        if (not shader_is_compiled(__shdScribble))
        {
            __ScribbleError("Shader failed to compile. Please check your version of GameMaker is compatible\nPlease report this error if it persists");
        }
        
        if (SCRIBBLE_DETECT_MISSING_ASSETS)
        {
            if (not sprite_exists(asset_get_index("__ScribbleSacrificialAsset")))
            {
                __ScribbleError("Some assets have been detected as missing.\nThis probably means GameMaker has stripped assets during compile.\n \nThere are two solutions available:\n1. Add the \"scribble\" tag to every asset (font, sprite, sound, etc.) you want to use in Scribble\n    then set `SCRIBBLE_DETECT_MISSING_ASSETS` to `false` to turn off this warning;\n \n2. Or untick \"Automatically remove unused assets when compiling\" in Game Options");
            }
        }
        
        var _fontInfo = font_get_info(asset_get_index("fntScribbleFallback"));
        if (_fontInfo[$ "sdfEnabled"] == undefined)
        {
            __ScribbleError("Versions of GameMaker without SDF font support are not supported");
        }
        
        try
        {
            time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function()
            {
                if (__userTickSize == undefined)
                {
                    __tickSize = clamp(delta_time / 16667, 1/5, 5);
                }
                
                __frames++;
                
                static _elementIndex = 0;
                var _elementWeakArray = __elementWeakArray;
                
                var _elementCount = array_length(_elementWeakArray);
                repeat(ceil(sqrt(_elementCount)))
                {
                    //Safety catch
                    if (array_length(_elementWeakArray) <= 0)
                    {
                        break;
                    }
                    
                    _elementIndex = (_elementIndex + 1) mod array_length(_elementWeakArray);
                    if (not weak_ref_alive(_elementWeakArray[_elementIndex]))
                    {
                        array_delete(_elementWeakArray, _elementIndex, 1);
                    }
                }
                
                //If there's been a change in os_is_paused() state then force a refresh of shader uniforms
                static _osIsPaused = undefined;
                if (os_is_paused() != _osIsPaused)
                {
                    _osIsPaused = os_is_paused();
                    
                    with(__state)
                    {
                        __shader_anim_desync            = true;
                        __shader_anim_desync_to_default = true;
                    }
                }
            }, [], -1));
        }
        catch(_error)
        {
            __ScribbleError("Versions of GameMaker without time sources are not supported");
        }
        
        try
        {
            handle_parse(string(__ScribbleSystem));
        }
        catch(_error)
        {
            __ScribbleError("Versions of GameMaker without handle_parse() are not supported");
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
            __ScribbleTrace("Warning! Failed to obtain runtime version");
        }
        
        __gmMightRemoveUnusedAssets = (__gmVersionMajor >= 2025) || ((__gmVersionMajor == 2024) && ((__gmVersionMinor >= 1100) || (__gmVersionMinor == 11)));
        
        __defaultPreprocessorFunc = __ScribbleNoPreProcessing;
        
        //Main lookup for fonts
        __fontDataMap = ds_map_create();
        
        //Other caching maps
        __spriteTextureIndexMap    = ds_map_create();
        __spriteTextureMaterialMap = ds_map_create();
        __material_map                = ds_map_create();
        
        //Multi-use buffers
        __bufferA = buffer_create(1024, buffer_grow, 1);
        __bufferB = buffer_create(1024, buffer_grow, 1);
        
        //Contains animation parameters. See scribble_anim_reset()
        __anim_properties = array_create(__SCRIBBLE_ANIM_SIZE, undefined);
        
        __frames = 0;
        __userTickSize = undefined;
        __tickSize = 1;
        
        //Contains global state information that is shared between various features
        __state = {
            __defaultFont: "fntScribbleFallback",
            
            __shader_anim_desync:            false,
            __shader_anim_desync_to_default: false,
            __shader_anim_default:           false,
            __shader_anim_disabled:          false,
            
            __sdfThicknessOffset: 0,
            
            __markdown_styles_struct: {},
            
            __sprite_whitelist_map: ds_map_create(),
            __soundWhitelistMap:  ds_map_create(),
        };
        
        __elementWeakArray = [];
        __elementCacheMap  = ds_map_create(); //Contains strong references
        
        __generatorState = new __ScribbleClassGeneratorState();
        
        //Contains Unicode data, necessary for extended language support
        __glyphData                = __ScribbleGlyphDataInitialize();
        __krutidevLookupMap       = __ScribbleKrutidevLookupMapInitialize();
        __krutidevMatraLookupMap = __ScribbleKrutidevMatraLookupMapInitialize();
        
        //External sound reference storage
        __external_sprite_map = ds_map_create();
        __externalSoundMap  = ds_map_create();
        
        __tagDict = {};
        
        //Pre-populated typist events
        __ScribbleAddTag(__SCRIBBLE_PAUSE_COMMAND_TAG,   __SCRIBBLE_TAG_EVENT, undefined, true);
        __ScribbleAddTag(__SCRIBBLE_DELAY_COMMAND_TAG,   __SCRIBBLE_TAG_EVENT, undefined, true);
        __ScribbleAddTag(__SCRIBBLE_SYNC_COMMAND_TAG,    __SCRIBBLE_TAG_EVENT, undefined, true);
        __ScribbleAddTag(__SCRIBBLE_SPEED_COMMAND_TAG,   __SCRIBBLE_TAG_EVENT, undefined, true);
        __ScribbleAddTag(__SCRIBBLE_UNSPEED_COMMAND_TAG, __SCRIBBLE_TAG_EVENT, undefined, true);
        
        __ScribbleAddTag("wave",   __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_WAVE,   true);
        __ScribbleAddTag("shake",  __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_SHAKE,  true);
        __ScribbleAddTag("wobble", __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_WOBBLE, true);
        __ScribbleAddTag("pulse",  __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_PULSE,  true);
        __ScribbleAddTag("wheel",  __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_WHEEL,  true);
        __ScribbleAddTag("cycle",  __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_CYCLE,  true);
        __ScribbleAddTag("jitter", __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_JITTER, true);
        __ScribbleAddTag("slant",  __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_SLANT,  true);
        
        __ScribbleAddTag("WAVE",   __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_WAVE,   true);
        __ScribbleAddTag("SHAKE",  __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_SHAKE,  true);
        __ScribbleAddTag("WOBBLE", __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_WOBBLE, true);
        __ScribbleAddTag("PULSE",  __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_PULSE,  true);
        __ScribbleAddTag("WHEEL",  __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_WHEEL,  true);
        __ScribbleAddTag("CYCLE",  __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_CYCLE,  true);
        __ScribbleAddTag("JITTER", __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_JITTER, true);
        __ScribbleAddTag("SLANT",  __SCRIBBLE_TAG_EFFECT, __SCRIBBLE_FLAG_SLANT,  true);
        
        __ScribbleAddTag("/wave",   __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_WAVE,   true);
        __ScribbleAddTag("/shake",  __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_SHAKE,  true);
        __ScribbleAddTag("/wobble", __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_WOBBLE, true);
        __ScribbleAddTag("/pulse",  __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_PULSE,  true);
        __ScribbleAddTag("/wheel",  __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_WHEEL,  true);
        __ScribbleAddTag("/cycle",  __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_CYCLE,  true);
        __ScribbleAddTag("/jitter", __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_JITTER, true);
        __ScribbleAddTag("/slant",  __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_SLANT,  true);
        
        __ScribbleAddTag("/WAVE",   __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_WAVE,   true);
        __ScribbleAddTag("/SHAKE",  __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_SHAKE,  true);
        __ScribbleAddTag("/WOBBLE", __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_WOBBLE, true);
        __ScribbleAddTag("/PULSE",  __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_PULSE,  true);
        __ScribbleAddTag("/WHEEL",  __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_WHEEL,  true);
        __ScribbleAddTag("/CYCLE",  __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_CYCLE,  true);
        __ScribbleAddTag("/JITTER", __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_JITTER, true);
        __ScribbleAddTag("/SLANT",  __SCRIBBLE_TAG_EFFECT_UNSET, __SCRIBBLE_FLAG_SLANT,  true);
        
        var _colorStruct = __scribble_config_colours();
        var _namesArray = variable_struct_get_names(_colorStruct);
        var _i = 0;
        repeat(array_length(_namesArray))
        {
            var _name = _namesArray[_i];
            __ScribbleAddTag(_name, __SCRIBBLE_TAG_COLOR, _colorStruct[$ _name], false);
            ++_i;
        }
        
        __cycleSurface = -1;
        __cycle_data_open_array = [];
        __cycleDataMap = ds_map_create();
        scribble_cycle_add_from_array(SCRIBBLE_RAINBOW_CYCLE, [c_red, c_yellow, c_lime, c_aqua, c_blue, c_fuchsia], true, false);
        
        //Unpack texture group data into an easy-to-use dictionary. This should, of course, just be a native
        //feature of GameMaker. I, in fact, suggested such a feature (including sprites (and backgrounds!))
        //back in 2018 when working on The Swords Of Ditto in GameMaker Studio 1.4.
        __fontToTextureGroupMap = ds_map_create();
        
        var _tg_name_array = texturegroup_get_names();
        var _i = 0;
        repeat(array_length(_tg_name_array))
        {
            var _tg_name = _tg_name_array[_i];
            var _font_index_array = texturegroup_get_fonts(_tg_name);
            
            var _j = 0;
            repeat(array_length(_font_index_array))
            {
                __fontToTextureGroupMap[? _font_index_array[_j]] = _tg_name;
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
    __ScribbleFontAddAllFromBundle();
    
    return _system;
}