function __scribble_get_typewriter_events_map()
{
    static _map = ds_map_create();
    return _map;
}

function __scribble_typewrite_events_map_initialize()
{
    var _map = __scribble_get_typewriter_events_map();
    _map[? "pause" ] = undefined;
    _map[? "delay" ] = undefined;
    _map[? "sync"  ] = undefined;
    _map[? "speed" ] = undefined;
    _map[? "/speed"] = undefined;
}