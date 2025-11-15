// Feather disable all
function __ScribbleGen11_PaddingAndClipping()
{
    static _generatorState = __ScribbleSystem().__generatorState;
    with(_generatorState)
    {
        var _usesHAlignLeft   = __usesHAlignLeft;
        var _usesHAlignCenter = __usesHAlignCenter;
        var _usesHAlignRight  = __usesHAlignRight;
    }
    
    //Figure out how to pad the bounding box based on what alignments have been used
    __padBboxT = false;
    __padBboxB = true;
    
    if (__vAlign == fa_top)
    {
        __padBboxT = false;
    }
    
    if (__vAlign == fa_bottom)
    {
        __padBboxB = false;
    }
    
    if (_usesHAlignCenter)
    {
        __padBboxL = true;
        __padBboxR = true;
    }
    else if (_usesHAlignLeft)
    {
        if (_usesHAlignRight)
        {
            __padBboxL = true;
            __padBboxR = true;
        }
        else
        {
            __padBboxL = false;
            __padBboxR = true;
        }
    }
    else if (_usesHAlignRight)
    {
        __padBboxL = true;
        __padBboxR = false;
    }
    else
    {
        __padBboxL = false;
        __padBboxR = true;
    }
    
    var _layoutMaxWidth  = __layoutMaxWidth;
    var _layoutMaxHeight = __layoutMaxHeight;
    
    var _hFactor = (__startingHAlign == fa_center)? 0.5 : ((__startingHAlign == fa_right )? 1 : 0);
    var _vFactor = (__startingVAlign == fa_middle)? 0.5 : ((__startingVAlign == fa_bottom)? 1 : 0);
    
    __clipLeft   = -_hFactor*_layoutMaxWidth;
    __clipTop    = -_vFactor*_layoutMaxHeight;
    __clipRight  = __clipLeft + _layoutMaxWidth;
    __clipBottom = __clipTop  + _layoutMaxHeight;
    
    var _i = 0;
    repeat(array_length(__pagesArray))
    {
        with(__pagesArray[_i])
        {
            __scrollMaxX = max(0, __width  - _layoutMaxWidth );
            __scrollMaxY = max(0, __height - _layoutMaxHeight);
            
            __scrollOffsetX = -_hFactor*__scrollMaxX;
            __scrollOffsetY = -_vFactor*__scrollMaxY;
        }
        
        ++_i;
    }
}
