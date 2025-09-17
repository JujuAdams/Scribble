// Feather disable all

/// @param name
/// @param rgbArray
/// @param [smooth=true]
/// @param [legacyBlend=false]

function scribble_cycle_add_from_array(_name, _rgbArray, _smooth = true, _legacyBlend = false)
{
    static _dataOpenArray = __ScribbleSystem().__cycleDataOpenArray;
    static _dataMap       = __ScribbleSystem().__cycleDataMap;
    
    if (ds_map_exists(_dataMap, _name))
    {
        var _data = _dataMap[? _name];
        var _index = _data.__index;
    }
    else
    {
        var _index = array_pop(_dataOpenArray);
        if (_index == undefined)
        {
            _index = ds_map_size(_dataMap);
        }
    }
    
    _dataMap[? _name] = {
        __index:       _index,
        __data:        _rgbArray,
        __image:       0,
        __smooth:      _smooth,
        __legacyBlend: _legacyBlend,
    };
    
    surface_set_target(__ScribbleEnsureCycleSurface());
    __ScribbleDrawCycle(_name);
    surface_reset_target();
}