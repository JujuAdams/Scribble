// Feather disable all

function __ScribbleGen1_ModelLimitsAndPaths()
{
    static _generatorState = __ScribbleSystem().__generatorState;
    
    var _modelMaxWidth = __layoutMaxWidth - (__paddingL + __paddingR);
    if (_modelMaxWidth < 0) _modelMaxWidth = infinity;
    
    var _modelMaxHeight = __layoutMaxHeight - (__paddingT + __paddingB);
    if (_modelMaxHeight < 0) _modelMaxHeight = infinity;
    
    if (__path != undefined)
    {
        if ((__pathStart == 0) && (__pathEnd == 1))
        {
            _generatorState.__pathLength = abs(__pathScale)*path_get_length(__path);
        }
        else
        {
            //TODO - Consider caching this information
            
            var _path = __path;
            var _length = 0;
            
            var _incr = (__pathEnd - __pathStart) / __SCRIBBLE_PATH_LENGTH_ACCURACY;
            
            var _t = __pathStart;
            var _x2 = path_get_x(_path, _t);
            var _y2 = path_get_y(_path, _t);
            
            repeat(__SCRIBBLE_PATH_LENGTH_ACCURACY)
            {
                var _x = _x2;
                var _y = _y2;
                
                _t += _incr;
                _x2 = path_get_x(_path, _t);
                _y2 = path_get_y(_path, _t);
                
                _length += point_distance(_x, _y, _x2, _y2);
            }
            
            _generatorState.__pathLength = abs(__pathScale)*_length;
        }
    }
    
    with(_generatorState)
    {
        __modelMaxWidth  = _modelMaxWidth;
        __modelMaxHeight = _modelMaxHeight;
    }
}
