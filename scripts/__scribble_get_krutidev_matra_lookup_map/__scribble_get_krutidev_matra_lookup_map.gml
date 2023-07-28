// Feather disable all
function __scribble_get_krutidev_matra_lookup_map()
{
    static _map = ds_map_create();
    return _map;
}

function __scribble_krutidev_matra_lookup_map_initialize()
{
    //TODO - Convert these to hex and add comments
    var _map = __scribble_get_krutidev_matra_lookup_map();
    _map[?   58] = true;
    _map[? 2305] = true;
    _map[? 2306] = true;
    _map[? 2366] = true;
    _map[? 2367] = true;
    _map[? 2368] = true;
    _map[? 2369] = true;
    _map[? 2370] = true;
    _map[? 2371] = true;
    _map[? 2373] = true;
    _map[? 2375] = true;
    _map[? 2376] = true;
    _map[? 2379] = true;
    _map[? 2380] = true;
}
