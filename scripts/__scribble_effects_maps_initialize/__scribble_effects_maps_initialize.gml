function __scribble_effects_maps_initialize()
{
    var _map       = __scribble_get_effects_map();
    var _slash_map = __scribble_get_effects_slash_map();
    
    //Add bindings for default effect names
    //Effect index 0 is reversed for sprites
    _map[?       "wave"    ] = 1;
    _map[?       "shake"   ] = 2;
    _map[?       "rainbow" ] = 3;
    _map[?       "wobble"  ] = 4;
    _map[?       "pulse"   ] = 5;
    _map[?       "wheel"   ] = 6;
    _map[?       "cycle"   ] = 7;
    _map[?       "jitter"  ] = 8;
    _map[?       "blink"   ] = 9;
    _map[?       "slant"   ] = 10;
    _slash_map[? "/wave"   ] = 1;
    _slash_map[? "/shake"  ] = 2;
    _slash_map[? "/rainbow"] = 3;
    _slash_map[? "/wobble" ] = 4;
    _slash_map[? "/pulse"  ] = 5;
    _slash_map[? "/wheel"  ] = 6;
    _slash_map[? "/cycle"  ] = 7;
    _slash_map[? "/jitter" ] = 8;
    _slash_map[? "/blink"  ] = 9;
    _slash_map[? "/slant"  ] = 10;
    
    _map[?       "WAVE"    ] = 1;
    _map[?       "SHAKE"   ] = 2;
    _map[?       "RAINBOW" ] = 3;
    _map[?       "WOBBLE"  ] = 4;
    _map[?       "PULSE"   ] = 5;
    _map[?       "WHEEL"   ] = 6;
    _map[?       "CYCLE"   ] = 7;
    _map[?       "JITTER"  ] = 8;
    _map[?       "BLINK"   ] = 9;
    _map[?       "SLANT"   ] = 10;
    _slash_map[? "/WAVE"   ] = 1;
    _slash_map[? "/SHAKE"  ] = 2;
    _slash_map[? "/RAINBOW"] = 3;
    _slash_map[? "/WOBBLE" ] = 4;
    _slash_map[? "/PULSE"  ] = 5;
    _slash_map[? "/WHEEL"  ] = 6;
    _slash_map[? "/CYCLE"  ] = 7;
    _slash_map[? "/JITTER" ] = 8;
    _slash_map[? "/BLINK"  ] = 9;
    _slash_map[? "/SLANT"  ] = 10;
}