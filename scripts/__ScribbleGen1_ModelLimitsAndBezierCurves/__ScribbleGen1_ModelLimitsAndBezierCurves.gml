// Feather disable all
function __ScribbleGen1_ModelLimitsAndBezierCurves()
{
    static _generatorState = __ScribbleSystem().__generatorState;
    
    var _modelMaxWidth = __layoutMaxWidth - (__paddingL + __paddingR);
    if (_modelMaxWidth < 0) _modelMaxWidth = infinity;
    
    var _modelMaxHeight = __layoutMaxHeight - (__paddingT + __paddingB);
    if (_modelMaxHeight < 0) _modelMaxHeight = infinity;
    
    //TODO - Cache Bezier curves
    
    //Make a copy of the Bezier array
    var _elementBezierArray = __bezierArray;
    var _bezierDo = ((_elementBezierArray[0] != _elementBezierArray[4]) || (_elementBezierArray[1] != _elementBezierArray[5]));
    if (_bezierDo)
    {
        var _bezierArray = array_create(6);
        array_copy(_bezierArray, 0, _elementBezierArray, 0, 6);
        
        var _bx2 = _bezierArray[0];
        var _by2 = _bezierArray[1];
        var _bx3 = _bezierArray[2];
        var _by3 = _bezierArray[3];
        var _bx4 = _bezierArray[4];
        var _by4 = _bezierArray[5];
        
        var _bezierLengths = array_create(SCRIBBLE_BEZIER_ACCURACY, 0.0);
        var _x1 = undefined;
        var _y1 = undefined;
        var _x2 = 0;
        var _y2 = 0;
        
        var _dist = 0;
        
        var _bezierParamIncrement = 1 / (SCRIBBLE_BEZIER_ACCURACY-1);
        var _t = _bezierParamIncrement;
        var _i = 1;
        repeat(SCRIBBLE_BEZIER_ACCURACY-1)
        {
            var _invT = 1 - _t;
            
            _x1 = _x2;
            _y1 = _y2;
            _x2 = 3.0*_invT*_invT*_t*_bx2 + 3.0*_invT*_t*_t*_bx3 + _t*_t*_t*_bx4;
            _y2 = 3.0*_invT*_invT*_t*_by2 + 3.0*_invT*_t*_t*_by3 + _t*_t*_t*_by4;
            
            var _dx = _x2 - _x1;
            var _dy = _y2 - _y1;
            _dist += sqrt(_dx*_dx + _dy*_dy);
            _bezierLengths[@ _i] = _dist;
            
            _t += _bezierParamIncrement;
            ++_i;
        }
        
        if ((_modelMaxWidth >= 0) && !is_infinity(_modelMaxWidth)) __ScribbleTrace("Warning! Maximum width (" + string(_modelMaxWidth) + ") has been replaced with Bezier curve length (" + string(_dist) + "). Use -1 as the maximum width to turn off this warning");
        _modelMaxWidth = _dist;
        
        _generatorState.__bezierLengthsArray = _bezierLengths;
    }
    
    with(_generatorState)
    {
        __modelMaxWidth  = _modelMaxWidth;
        __modelMaxHeight = _modelMaxHeight;
    }
}
