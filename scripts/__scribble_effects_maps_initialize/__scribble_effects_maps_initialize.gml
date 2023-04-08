function __scribble_effects_maps_initialize()
{
    var _scribble_state = __scribble_get_state();
    var _effects_dict       = _scribble_state.__effects_dict;
    var _effects_slash_dict = _scribble_state.__effects_slash_dict;
    
    //Add bindings for default effect names
    //Effect index 0 is reversed for sprites
    _effects_dict[$       "wave"    ] = 1;
    _effects_dict[$       "shake"   ] = 2;
    _effects_dict[$       "rainbow" ] = 3;
    _effects_dict[$       "wobble"  ] = 4;
    _effects_dict[$       "pulse"   ] = 5;
    _effects_dict[$       "wheel"   ] = 6;
    _effects_dict[$       "jitter"  ] = 7;
    _effects_dict[$       "blink"   ] = 8;
    _effects_dict[$       "slant"   ] = 9;
    _effects_slash_dict[$ "/wave"   ] = 1;
    _effects_slash_dict[$ "/shake"  ] = 2;
    _effects_slash_dict[$ "/rainbow"] = 3;
    _effects_slash_dict[$ "/wobble" ] = 4;
    _effects_slash_dict[$ "/pulse"  ] = 5;
    _effects_slash_dict[$ "/wheel"  ] = 6;
    _effects_slash_dict[$ "/jitter" ] = 7;
    _effects_slash_dict[$ "/blink"  ] = 8;
    _effects_slash_dict[$ "/slant"  ] = 9;
    
    _effects_dict[$       "WAVE"    ] = 1;
    _effects_dict[$       "SHAKE"   ] = 2;
    _effects_dict[$       "RAINBOW" ] = 3;
    _effects_dict[$       "WOBBLE"  ] = 4;
    _effects_dict[$       "PULSE"   ] = 5;
    _effects_dict[$       "WHEEL"   ] = 6;
    _effects_dict[$       "JITTER"  ] = 7;
    _effects_dict[$       "BLINK"   ] = 8;
    _effects_dict[$       "SLANT"   ] = 9;
    _effects_slash_dict[$ "/WAVE"   ] = 1;
    _effects_slash_dict[$ "/SHAKE"  ] = 2;
    _effects_slash_dict[$ "/RAINBOW"] = 3;
    _effects_slash_dict[$ "/WOBBLE" ] = 4;
    _effects_slash_dict[$ "/PULSE"  ] = 5;
    _effects_slash_dict[$ "/WHEEL"  ] = 6;
    _effects_slash_dict[$ "/JITTER" ] = 7;
    _effects_slash_dict[$ "/BLINK"  ] = 8;
    _effects_slash_dict[$ "/SLANT"  ] = 9;
}