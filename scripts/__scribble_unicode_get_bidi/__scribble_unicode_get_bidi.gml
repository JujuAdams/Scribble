function __scribble_unicode_get_bidi(_unicode)
{
    static _global_glyph_bidi_map = __scribble_get_glyph_data().__bidi_map;
    
    if ((_unicode >= 0x3000) && (_unicode <= 0x303F)) //CJK Symbols and Punctuation
    {
        var _bidi = __SCRIBBLE_BIDI.SYMBOL;
    }
    else if ((_unicode >= 0x3040) && (_unicode <= 0x30FF)) //Hiragana and Katakana
    {
        var _bidi = __SCRIBBLE_BIDI.ISOLATED_CJK;
    }
    else if ((_unicode >= 0x4E00) && (_unicode <= 0x9FFF)) //CJK Unified ideographs block
    {
        var _bidi = __SCRIBBLE_BIDI.ISOLATED_CJK;
    }
    else if ((_unicode >= 0xFF00) && (_unicode <= 0xFF0F)) //Fullwidth symbols
    {
        var _bidi = __SCRIBBLE_BIDI.SYMBOL;
    }
    else if ((_unicode >= 0xFF1A) && (_unicode <= 0xFF1F)) //More fullwidth symbols
    {
        var _bidi = __SCRIBBLE_BIDI.SYMBOL;
    }
    else if ((_unicode >= 0xFF5B) && (_unicode <= 0xFF64)) //Yet more fullwidth symbols
    {
        var _bidi = __SCRIBBLE_BIDI.SYMBOL;
    }
    else
    {
        var _bidi = _global_glyph_bidi_map[? _unicode];
        if (_bidi == undefined) _bidi = __SCRIBBLE_BIDI.L2R;
    }
    
    return _bidi;
}