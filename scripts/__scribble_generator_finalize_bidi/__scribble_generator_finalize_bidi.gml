function __scribble_generator_finalize_bidi()
{
    var _word_grid = global.__scribble_word_grid;
    var _word_count = global.__scribble_generator_state.word_count;
    
    var _overall_bidi = global.__scribble_generator_state.overall_bidi;
    if (_overall_bidi == undefined)
    {
        // Presume that the first word in the string implies the overall text direction
        // If the first word has a neutral direction then keep searching until we find a
        // word with a well-defined direction
        var _i = 0;
        repeat(_word_count)
        {
            var _bidi = _word_grid[# _i, __SCRIBBLE_PARSER_WORD.BIDI_RAW];
            if (_bidi != __SCRIBBLE_BIDI.NEUTRAL)
            {
                _overall_bidi = _bidi;
                break;
            }
        
            ++_i;
        }
        
        // We didn't find a word with a direction, default to L2R
        if (_overall_bidi == undefined) _overall_bidi = __SCRIBBLE_BIDI.L2R;
    }
    
    // Iterate over all words, assigning directionality to neutral words
    var _i = 0;
    repeat(_word_count)
    {
        var _bidi = _word_grid[# _i, __SCRIBBLE_PARSER_WORD.BIDI_RAW];
        if (_bidi == __SCRIBBLE_BIDI.NEUTRAL)
        {
            // Get the direction of adjacent words
            var _prev_bidi = (_i > 0)?             _word_grid[# _i-1, __SCRIBBLE_PARSER_WORD.BIDI] : undefined;
            var _next_bidi = (_i < _word_count-1)? _word_grid[# _i+1, __SCRIBBLE_PARSER_WORD.BIDI] : undefined;
            
            // If either adjacent word has no defined bidi (usually the case at the end of strings
            // or in a sequence of symbols) then use the direction of the other adjacent word
            if (_prev_bidi == undefined) _prev_bidi = _next_bidi;
            if (_next_bidi == undefined) _next_bidi = _prev_bidi;
            
            //TODO - Handle this recursively
            
            // Prefer the overall direction if either adjacent word shares it
            var _new_bidi = ((_prev_bidi == _overall_bidi) || (_next_bidi == _overall_bidi))? _overall_bidi : _prev_bidi;
            
            // If we *still* can't decide on the direction, default to L2R
            if (_new_bidi == undefined) _new_bidi = __SCRIBBLE_BIDI.L2R;
            
            _word_grid[# _i, __SCRIBBLE_PARSER_WORD.BIDI] = _new_bidi;
        }
            
        ++_i;
    }
    
    global.__scribble_generator_state.overall_bidi = _overall_bidi;
}