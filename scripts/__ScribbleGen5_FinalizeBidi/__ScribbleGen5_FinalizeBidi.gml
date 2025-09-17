// Feather disable all
function __ScribbleGen5_FinalizeBidi()
{
    if (not __hasR2L) exit;
    
    static _generatorState = __ScribbleSystem().__generatorState;
    with(_generatorState)
    {
        var _wordGrid    = __wordGrid;
        var _wordCount   = __wordCount;
        var _overallBidi = __overallBidi;
    }
    
    //TODO - Optimise this by storing where symbolic bidi words are
    //       This saves iterating over the whole text element
    
    // Iterate over all words, assigning directionality to neutral words
    var _i = 0;
    repeat(_wordCount)
    {
        var _bidi = _wordGrid[# _i, __SCRIBBLE_GEN_WORD_BIDI_RAW];
        if (_bidi <= __SCRIBBLE_BIDI_SYMBOL) //symbol or whitespace
        {
            // Get the direction of adjacent words
            var _prevBidi = (_i > 0)?            _wordGrid[# _i-1, __SCRIBBLE_GEN_WORD_BIDI] : __SCRIBBLE_BIDI_SYMBOL;
            var _nextBidi = (_i < _wordCount-1)? _wordGrid[# _i+1, __SCRIBBLE_GEN_WORD_BIDI] : __SCRIBBLE_BIDI_SYMBOL;
            
            // If either adjacent word has no defined bidi (usually the case at the end of strings
            // or in a sequence of symbols) then use the direction of the other adjacent word
            if (_prevBidi <= __SCRIBBLE_BIDI_SYMBOL) _prevBidi = _nextBidi; //symbol or whitespace
            if (_nextBidi <= __SCRIBBLE_BIDI_SYMBOL) _nextBidi = _prevBidi; //symbol or whitespace
            
            //TODO - Handle this recursively
            
            // Prefer the overall direction if either adjacent word shares it
            var _newBidi = ((_prevBidi == _overallBidi) || (_nextBidi == _overallBidi))? _overallBidi : _prevBidi;
            
            // If we *still* can't decide on the direction, default to L2R
            if (_newBidi <= __SCRIBBLE_BIDI_SYMBOL) _newBidi = __SCRIBBLE_BIDI_L2R; //symbol or whitespace
            
            _wordGrid[# _i, __SCRIBBLE_GEN_WORD_BIDI] = _newBidi;
            
            _bidi = _newBidi;
        }
        
        ++_i;
    }
}
