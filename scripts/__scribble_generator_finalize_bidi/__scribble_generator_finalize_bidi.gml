function __scribble_generator_finalize_bidi()
{
    var _word_grid = global.__scribble_word_grid;
    var _word_count = global.__scribble_generator_state.word_count;
    
    //TODO - Allow overall bidi to be forced
    var _overall_bidi = __SCRIBBLE_BIDI.L2R;
    
    if (_word_count > 1)
    {
        var _i = 0;
        repeat(_word_count)
        {
            var _bidi = _word_grid[# _i, __SCRIBBLE_PARSER_WORD.BIDI_RAW];
            if (_bidi == __SCRIBBLE_BIDI.NEUTRAL)
            {
                var _prev_bidi = (_i > 0)?             _word_grid[# _i, __SCRIBBLE_PARSER_WORD.BIDI] : undefined;
                var _next_bidi = (_i < _word_count-1)? _word_grid[# _i, __SCRIBBLE_PARSER_WORD.BIDI] : undefined;
                
                if (_prev_bidi == undefined) _prev_bidi = _next_bidi;
                if (_next_bidi == undefined) _next_bidi = _prev_bidi;
                
                //TODO - Handle this recursively
                var _new_bidi = ((_prev_bidi == _overall_bidi) || (_next_bidi == _overall_bidi))? _next_bidi : _prev_bidi;
                _word_grid[# _i, __SCRIBBLE_PARSER_WORD.BIDI] = _new_bidi;
            }
            
            ++_i;
        }
    }
}