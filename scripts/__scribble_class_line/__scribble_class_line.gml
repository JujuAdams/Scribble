// Feather disable all

/// @param x
/// @param wordStart
/// @param hAlign
/// @param forcedBreak

function __scribble_class_line(_x, _wordStart, _hAlign, _forcedBreak) constructor
{
    __x = _x;
    __y = 0;
    
    __width = 0;
    
    __wordStart = _wordStart;
    __wordEnd   = undefined;
    
    __hAlign = _hAlign;
    __disableJustify = false;
    __startsManualPage = false;
    __forceBreak = _forcedBreak;
}