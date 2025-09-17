// Feather disable all

/// @param x
/// @param height
/// @param wordStart
/// @param hAlign
/// @param forcedBreak

function __ScribbleClassLine(_x, _height, _wordStart, _hAlign, _forcedBreak) constructor
{
    x = _x;
    y = 0;
    
    width  = 0;
    height = _height;
    
    wordStart = _wordStart;
    wordEnd   = undefined;
    
    hAlign           = _hAlign;
    disableJustify   = false;
    startsManualPage = false;
    forcedBreak      = _forcedBreak;
    
    glyphStart  = undefined;
    glyphEnd    = undefined;
    glyphCount  = undefined;
}