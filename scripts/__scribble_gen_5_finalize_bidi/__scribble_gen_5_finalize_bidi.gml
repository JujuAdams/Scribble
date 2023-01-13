function __scribble_gen_5_finalize_bidi()
{
    if (!__has_r2l) exit;
    
    static _generator_state = __scribble_get_generator_state();
    with(_generator_state)
    {
        var _word_grid    = __word_grid;
        var _word_count   = __word_count;
        var _overall_bidi = __overall_bidi;
    }
    
    //TODO - Optimise this by storing where symbolic bidi words are
    //       This saves iterating over the whole text element
    
    // Iterate over all words, assigning directionality to neutral words
    var _i = 0;
    repeat(_word_count)
    {
        var _bidi = _word_grid[# _i, __SCRIBBLE_GEN_WORD.__BIDI_RAW];
        if (_bidi <= __SCRIBBLE_BIDI.SYMBOL) //symbol or whitespace
        {
            // Get the direction of adjacent words
            var _prev_bidi = (_i > 0)?             _word_grid[# _i-1, __SCRIBBLE_GEN_WORD.__BIDI] : __SCRIBBLE_BIDI.SYMBOL;
            var _next_bidi = (_i < _word_count-1)? _word_grid[# _i+1, __SCRIBBLE_GEN_WORD.__BIDI] : __SCRIBBLE_BIDI.SYMBOL;
            
            // If either adjacent word has no defined bidi (usually the case at the end of strings
            // or in a sequence of symbols) then use the direction of the other adjacent word
            if (_prev_bidi <= __SCRIBBLE_BIDI.SYMBOL) _prev_bidi = _next_bidi; //symbol or whitespace
            if (_next_bidi <= __SCRIBBLE_BIDI.SYMBOL) _next_bidi = _prev_bidi; //symbol or whitespace
            
            //TODO - Handle this recursively
            
            // Prefer the overall direction if either adjacent word shares it
            var _new_bidi = ((_prev_bidi == _overall_bidi) || (_next_bidi == _overall_bidi))? _overall_bidi : _prev_bidi;
            
            // If we *still* can't decide on the direction, default to L2R
            if (_new_bidi <= __SCRIBBLE_BIDI.SYMBOL) _new_bidi = __SCRIBBLE_BIDI.L2R; //symbol or whitespace
            
            _word_grid[# _i, __SCRIBBLE_GEN_WORD.__BIDI] = _new_bidi;
            
            _bidi = _new_bidi;
        }
        
        ++_i;
    }
}