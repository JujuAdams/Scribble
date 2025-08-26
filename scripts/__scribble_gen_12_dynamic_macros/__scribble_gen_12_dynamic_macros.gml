// Feather disable all

function __scribble_gen_12_dynamic_macros()
{
    if (array_length(__dynamicMacroArray) <= 0)
    {
        return;
    }
    
    var _scope = {
        __weakRef: weak_ref_create(self),
        __timeSource: undefined,
    };
    
    _scope.__timeSource = time_source_create(time_source_global, 1, time_source_units_frames, method(_scope,
    function()
    {
        if (not weak_ref_alive(__weakRef))
        {
            time_source_destroy(__timeSource);
            return;
        }
        
        var _array = __weakRef.ref.__dynamicMacroArray;
        var _i = 0;
        repeat(array_length(_array))
        {
            var _data = _array[_i];
            var _newResult = method_call(_data.__function, _data.__parameters);
            if (_newResult != _data.__result)
            {
                _data.__result = _newResult;
                __weakRef.ref.__rebuild();
                break;
            }
            
            ++_i;
        }
    }
    ), [], -1);
    
    time_source_start(_scope.__timeSource);
}