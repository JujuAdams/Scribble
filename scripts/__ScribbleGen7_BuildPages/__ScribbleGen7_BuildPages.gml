// Feather disable all

function __ScribbleGen7_BuildPages()
{
    static _generatorState = __ScribbleSystem().__generatorState;
    
    with(_generatorState)
    {
        var _modelMaxHeight = __modelMaxHeight;
        var _lineArray      = __lineArray;
    }
    
    var _layoutMaxHeight     = __layoutMaxHeight;
    var _lineHeight          = __lineHeight;
    var _lineSpacingAdd      = __lineSpacingAdd;
    var _lineSpacingMultiply = __lineSpacingMultiply;
    
    if (is_infinity(_layoutMaxHeight))
    {
        _layoutMaxHeight = 0;
    }
    
    var _paginate = (__layoutType == SCRIBBLE_LAYOUT_PAGINATE);
    var _trimText = (__layoutType == SCRIBBLE_LAYOUT_TRIM);
    var _skippingLines = false;
    
    var _simulated_model_height = (__layoutType == SCRIBBLE_LAYOUT_FIT)? infinity : (_modelMaxHeight / __fitScale);
    
    var _pageData = __AddPage(0);
    var _firstLine = true;
    var _lineY = 0;
    var _width = 0;
    
    var _line = 0;
    repeat(array_length(_lineArray))
    {
        var _lineStruct = _lineArray[_line];
        
        if (not _skippingLines)
        {
            _width = max(_width, _lineStruct.width);
        }
        
        var _startsManualPage = _lineStruct.startsManualPage;
        var _overflow = _paginate && (_lineY + _lineHeight > _simulated_model_height);
        
        if (_startsManualPage || (_overflow && (not _firstLine) && (not _skippingLines)))
        {
            if (not _skippingLines)
            {
                _pageData.__Finalize(_line-1);
            }
            
            _firstLine = true;
            _lineStruct.y = 0;
            _lineY = _lineSpacingAdd + _lineHeight*_lineSpacingMultiply;
            
            if (_startsManualPage)
            {
                _skippingLines = false;
            }
            else if (_overflow && _trimText)
            {
                _skippingLines = true;
            }
            
            if (not _skippingLines)
            {
                _pageData = __AddPage(_line);
            }
        }
        else
        {
            _firstLine = false;
            _lineStruct.y = _lineY;
            _lineY += _lineSpacingAdd + _lineHeight*_lineSpacingMultiply;
        }
        
        ++_line;
    }
    
    if (not _skippingLines)
    {
        _pageData.__Finalize(_line-1);
    }
    
    //We refine this in the next phase
    __width = _width;
}
