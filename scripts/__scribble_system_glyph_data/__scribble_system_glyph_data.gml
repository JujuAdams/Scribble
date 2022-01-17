function __scribble_system_glyph_data()
{
    global.__scribble_glyph_data = {
        __bidi_map   : ds_map_create(),
        __mirror_map : ds_map_create(),
        
        __arabic_isolated_map  : ds_map_create(),
        __arabic_initial_map   : ds_map_create(),
        __arabic_medial_map    : ds_map_create(),
        __arabic_final_map     : ds_map_create(),
        __arabic_join_prev_map : ds_map_create(),
        __arabic_join_next_map : ds_map_create(),
        
        __thai_base_map           : ds_map_create(),
        __thai_base_descender_map : ds_map_create(),
        __thai_base_ascender_map  : ds_map_create(),
        __thai_top_map            : ds_map_create(),
        __thai_lower_map          : ds_map_create(),
        __thai_upper_map          : ds_map_create(),
    }
    
    
    
    #region BiDi definitions
    
    enum __SCRIBBLE_BIDI
    {
        WHITESPACE = 0, //Must be 0 for the sake of __scribble_gen_6_finalize_bidi()
        SYMBOL     = 1, //Must be 1 for the sake of __scribble_gen_6_finalize_bidi()
        ISOLATED,       //More of a layout property - .ISOLATED words get converted to .L2R when building words
        L2R,
        R2L,
        R2L_ARABIC, //Cursive. Animation indexes are calculated per word
    }
    
    var _map = global.__scribble_glyph_data.__bidi_map;
    _map[? __SCRIBBLE_GLYPH_SPRITE ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? __SCRIBBLE_GLYPH_SURFACE] = __SCRIBBLE_BIDI.SYMBOL;
    for(var _i = 0x0000; _i <= 0x0009; _i++) _map[? _i] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? 0x000A] = __SCRIBBLE_BIDI.ISOLATED;
    _map[? 0x000B] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? 0x000C] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? 0x000D] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? 0x0020] = __SCRIBBLE_BIDI.WHITESPACE; //space
    
    //Symbols
    _map[? ord("!") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord("\"")] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord("&") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord("'") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord("(") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord(")") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord("*") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord(";") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord("<") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord("=") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord(">") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord("?") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord("@") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord("[") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord("\\")] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord("]") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord("^") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord("_") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord("`") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord("{") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord("|") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord("}") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord("~") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord(",") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord(".") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord("/") ] = __SCRIBBLE_BIDI.SYMBOL;
    _map[? ord(":") ] = __SCRIBBLE_BIDI.SYMBOL;
    
    //More control characters
    _map[? $2066] = __SCRIBBLE_BIDI.WHITESPACE;
    _map[? $2067] = __SCRIBBLE_BIDI.WHITESPACE;
    _map[? $2068] = __SCRIBBLE_BIDI.WHITESPACE;
    _map[? $2069] = __SCRIBBLE_BIDI.WHITESPACE;
    _map[? $202A] = __SCRIBBLE_BIDI.WHITESPACE;
    _map[? $202B] = __SCRIBBLE_BIDI.WHITESPACE;
    _map[? $202C] = __SCRIBBLE_BIDI.WHITESPACE;
    _map[? $202D] = __SCRIBBLE_BIDI.WHITESPACE;
    _map[? $202E] = __SCRIBBLE_BIDI.WHITESPACE;
    
    _map[? $00A0] = __SCRIBBLE_BIDI.SYMBOL; //Non-breaking space
    _map[? $060C] = __SCRIBBLE_BIDI.SYMBOL; //Arabic comma
    _map[? $066B] = __SCRIBBLE_BIDI.R2L; //Arabic decimal separator
    _map[? $066C] = __SCRIBBLE_BIDI.R2L; //Arabic thousands separator
    for(var _i = 0x0590; _i <= 0x05FF; _i++) _map[? _i] = __SCRIBBLE_BIDI.R2L; //Hebrew block
    for(var _i = 0x0600; _i <= 0x06FF; _i++) _map[? _i] = __SCRIBBLE_BIDI.R2L_ARABIC; //Arabic block
    for(var _i = 0xFB50; _i <= 0xFDFF; _i++) _map[? _i] = __SCRIBBLE_BIDI.R2L_ARABIC; //Arabic presentation forms A
    for(var _i = 0xFE70; _i <= 0xFEFF; _i++) _map[? _i] = __SCRIBBLE_BIDI.R2L_ARABIC; //Arabic presentation forms B
    
    
    
    //As per https://www.unicode.org/Public/UCD/latest/ucd/BidiMirroring.txt
    var _map = global.__scribble_glyph_data.__mirror_map;
    _map[? ord("(")] = ord(")");
    _map[? ord(")")] = ord("(");
    _map[? ord("<")] = ord(">");
    _map[? ord(">")] = ord("<");
    _map[? ord("[")] = ord("]");
    _map[? ord("]")] = ord("[");
    _map[? ord("{")] = ord("}");
    _map[? ord("}")] = ord("{");
    
    #endregion
    
    
    
    #region Arabic Presentation Forms
    
    var _map_i = global.__scribble_glyph_data.__arabic_isolated_map;
    var _map_a = global.__scribble_glyph_data.__arabic_initial_map;
    var _map_b = global.__scribble_glyph_data.__arabic_medial_map;
    var _map_c = global.__scribble_glyph_data.__arabic_final_map;
    
    //Alef with madda above
    _map_i[? 0x0622] = 0xFE81; //Isolated
    _map_c[? 0x0622] = 0xFE82; //Final
    _map_b[? 0x0622] = 0xFE82; //Medial
    _map_a[? 0x0622] = 0xFE81; //Initial
    
    //Alef with hamza above
    _map_i[? 0x0623] = 0xFE83; //Isolated
    _map_c[? 0x0623] = 0xFE84; //Final
    _map_b[? 0x0623] = 0xFE84; //Medial
    _map_a[? 0x0623] = 0xFE83; //Initial
    
    //Waw with hamza above
    _map_i[? 0x0624] = 0xFE85; //Isolated
    _map_c[? 0x0624] = 0xFE86; //Final
    _map_b[? 0x0624] = 0xFE86; //Medial
    _map_a[? 0x0624] = 0xFE85; //Initial
    
    //Alef with hamza above
    _map_i[? 0x0625] = 0xFE87; //Isolated
    _map_c[? 0x0625] = 0xFE88; //Final
    _map_b[? 0x0625] = 0xFE88; //Medial
    _map_a[? 0x0625] = 0xFE87; //Initial
    
    //Yeh with hamza above
    _map_i[? 0x0626] = 0xFE89; //Isolated
    _map_c[? 0x0626] = 0xFE8A; //Final
    _map_b[? 0x0626] = 0xFE8C; //Medial
    _map_a[? 0x0626] = 0xFE8B; //Initial
    
    //Alif
    _map_i[? 0x0627] = 0xFE8D; //Isolated
    _map_c[? 0x0627] = 0xFE8E; //Final
    _map_b[? 0x0627] = 0xFE8E; //Medial
    _map_a[? 0x0627] = 0xFE8D; //Initial
    
    //Beh
    _map_i[? 0x0628] = 0xFE8F; //Isolated
    _map_c[? 0x0628] = 0xFE90; //Final
    _map_b[? 0x0628] = 0xFE92; //Medial
    _map_a[? 0x0628] = 0xFE91; //Initial
    
    //Teh Marbuta
    _map_i[? 0x0629] = 0xFE93; //Isolated
    _map_c[? 0x0629] = 0xFE94; //Final
    _map_b[? 0x0629] = 0xFE94; //Medial
    _map_a[? 0x0629] = 0xFE93; //Initial
    
    //Teh
    _map_i[? 0x062A] = 0xFE95; //Isolated
    _map_c[? 0x062A] = 0xFE96; //Final
    _map_b[? 0x062A] = 0xFE98; //Medial
    _map_a[? 0x062A] = 0xFE97; //Initial
    
    //Theh
    _map_i[? 0x062B] = 0xFE99; //Isolated
    _map_c[? 0x062B] = 0xFE9A; //Final
    _map_b[? 0x062B] = 0xFE9C; //Medial
    _map_a[? 0x062B] = 0xFE9B; //Initial
    
    //Jeem
    _map_i[? 0x062C] = 0xFE9D; //Isolated
    _map_c[? 0x062C] = 0xFE9E; //Final
    _map_b[? 0x062C] = 0xFEA0; //Medial
    _map_a[? 0x062C] = 0xFE9F; //Initial
    
    //Hah
    _map_i[? 0x062D] = 0xFEA1; //Isolated
    _map_c[? 0x062D] = 0xFEA2; //Final
    _map_b[? 0x062D] = 0xFEA4; //Medial
    _map_a[? 0x062D] = 0xFEA3; //Initial
    
    //Khah
    _map_i[? 0x062E] = 0xFEA5; //Isolated
    _map_c[? 0x062E] = 0xFEA6; //Final
    _map_b[? 0x062E] = 0xFEA8; //Medial
    _map_a[? 0x062E] = 0xFEA7; //Initial
    
    //Dal
    _map_i[? 0x062F] = 0xFEA9; //Isolated
    _map_c[? 0x062F] = 0xFEAA; //Final
    _map_b[? 0x062F] = 0xFEAA; //Medial
    _map_a[? 0x062F] = 0xFEA9; //Initial
    
    //Thal
    _map_i[? 0x0630] = 0xFEAB; //Isolated
    _map_c[? 0x0630] = 0xFEAC; //Final
    _map_b[? 0x0630] = 0xFEAC; //Medial
    _map_a[? 0x0630] = 0xFEAB; //Initial
    
    //Reh
    _map_i[? 0x0631] = 0xFEAD; //Isolated
    _map_c[? 0x0631] = 0xFEAE; //Final
    _map_b[? 0x0631] = 0xFEAE; //Medial
    _map_a[? 0x0631] = 0xFEAD; //Initial
    
    //Zain
    _map_i[? 0x0632] = 0xFEAF; //Isolated
    _map_c[? 0x0632] = 0xFEB0; //Final
    _map_b[? 0x0632] = 0xFEB0; //Medial
    _map_a[? 0x0632] = 0xFEAF; //Initial
    
    //Seen
    _map_i[? 0x0633] = 0xFEB1; //Isolated
    _map_c[? 0x0633] = 0xFEB2; //Final
    _map_b[? 0x0633] = 0xFEB4; //Medial
    _map_a[? 0x0633] = 0xFEB3; //Initial
    
    //Sheen
    _map_i[? 0x0634] = 0xFEB5; //Isolated
    _map_c[? 0x0634] = 0xFEB6; //Final
    _map_b[? 0x0634] = 0xFEB8; //Medial
    _map_a[? 0x0634] = 0xFEB7; //Initial
    
    //Sad
    _map_i[? 0x0635] = 0xFEB9; //Isolated
    _map_c[? 0x0635] = 0xFEBA; //Final
    _map_b[? 0x0635] = 0xFEBC; //Medial
    _map_a[? 0x0635] = 0xFEBB; //Initial
    
    //Dad
    _map_i[? 0x0636] = 0xFEBD; //Isolated
    _map_c[? 0x0636] = 0xFEBE; //Final
    _map_b[? 0x0636] = 0xFEC0; //Medial
    _map_a[? 0x0636] = 0xFEBF; //Initial
    
    //Tah
    _map_i[? 0x0637] = 0xFEC1; //Isolated
    _map_c[? 0x0637] = 0xFEC2; //Final
    _map_b[? 0x0637] = 0xFEC4; //Medial
    _map_a[? 0x0637] = 0xFEC3; //Initial
    
    //Zah
    _map_i[? 0x0638] = 0xFEC5; //Isolated
    _map_c[? 0x0638] = 0xFEC6; //Final
    _map_b[? 0x0638] = 0xFEC8; //Medial
    _map_a[? 0x0638] = 0xFEC7; //Initial
    
    //Ain
    _map_i[? 0x0639] = 0xFEC9; //Isolated
    _map_c[? 0x0639] = 0xFECA; //Final
    _map_b[? 0x0639] = 0xFECC; //Medial
    _map_a[? 0x0639] = 0xFECB; //Initial
    
    //Ghain
    _map_i[? 0x063A] = 0xFECD; //Isolated
    _map_c[? 0x063A] = 0xFECE; //Final
    _map_b[? 0x063A] = 0xFED0; //Medial
    _map_a[? 0x063A] = 0xFECF; //Initial
    
    //Feh
    _map_i[? 0x0641] = 0xFED1; //Isolated
    _map_c[? 0x0641] = 0xFED2; //Final
    _map_b[? 0x0641] = 0xFED4; //Medial
    _map_a[? 0x0641] = 0xFED3; //Initial
    
    //Qaf
    _map_i[? 0x0642] = 0xFED5; //Isolated
    _map_c[? 0x0642] = 0xFED6; //Final
    _map_b[? 0x0642] = 0xFED8; //Medial
    _map_a[? 0x0642] = 0xFED7; //Initial
    
    //Kaf
    _map_i[? 0x0643] = 0xFED9; //Isolated
    _map_c[? 0x0643] = 0xFEDA; //Final
    _map_b[? 0x0643] = 0xFEDC; //Medial
    _map_a[? 0x0643] = 0xFEDB; //Initial
    
    //Lam
    _map_i[? 0x0644] = 0xFEDD; //Isolated
    _map_c[? 0x0644] = 0xFEDE; //Final
    _map_b[? 0x0644] = 0xFEE0; //Medial
    _map_a[? 0x0644] = 0xFEDF; //Initial
    
    //Meem
    _map_i[? 0x0645] = 0xFEE1; //Isolated
    _map_c[? 0x0645] = 0xFEE2; //Final
    _map_b[? 0x0645] = 0xFEE4; //Medial
    _map_a[? 0x0645] = 0xFEE3; //Initial
    
    //Noon
    _map_i[? 0x0646] = 0xFEE5; //Isolated
    _map_c[? 0x0646] = 0xFEE6; //Final
    _map_b[? 0x0646] = 0xFEE8; //Medial
    _map_a[? 0x0646] = 0xFEE7; //Initial
    
    //Heh
    _map_i[? 0x0647] = 0xFEE9; //Isolated
    _map_c[? 0x0647] = 0xFEEA; //Final
    _map_b[? 0x0647] = 0xFEEC; //Medial
    _map_a[? 0x0647] = 0xFEEB; //Initial
    
    //Waw
    _map_i[? 0x0648] = 0xFEED; //Isolated
    _map_c[? 0x0648] = 0xFEEE; //Final
    _map_b[? 0x0648] = 0xFEEE; //Medial
    _map_a[? 0x0648] = 0xFEED; //Initial
    
    //Alef Maksura
    _map_i[? 0x0649] = 0xFEEF; //Isolated
    _map_c[? 0x0649] = 0xFEF0; //Final
    _map_b[? 0x0649] = 0xFEF0; //Medial
    _map_a[? 0x0649] = 0xFEEF; //Initial
    
    //Yeh
    _map_i[? 0x064A] = 0xFEF1; //Isolated
    _map_c[? 0x064A] = 0xFEF2; //Final
    _map_b[? 0x064A] = 0xFEF4; //Medial
    _map_a[? 0x064A] = 0xFEF3; //Initial
    
    //Lam with Alef with madda above
    _map_i[? 0xFEF5] = 0xFEF5; //Isolated
    _map_c[? 0xFEF5] = 0xFEF6; //Final
    _map_b[? 0xFEF5] = 0xFEF6; //Medial
    _map_a[? 0xFEF5] = 0xFEF5; //Initial
    _map_i[? 0xFEF6] = 0xFEF5; //Isolated
    _map_c[? 0xFEF6] = 0xFEF6; //Final
    _map_b[? 0xFEF6] = 0xFEF6; //Medial
    _map_a[? 0xFEF6] = 0xFEF5; //Initial
    
    //Lam with Alef with hamza above
    _map_i[? 0xFEF7] = 0xFEF7; //Isolated
    _map_c[? 0xFEF7] = 0xFEF8; //Final
    _map_b[? 0xFEF7] = 0xFEF8; //Medial
    _map_a[? 0xFEF7] = 0xFEF7; //Initial
    _map_i[? 0xFEF7] = 0xFEF7; //Isolated
    _map_c[? 0xFEF7] = 0xFEF8; //Final
    _map_b[? 0xFEF7] = 0xFEF8; //Medial
    _map_a[? 0xFEF7] = 0xFEF7; //Initial
    
    //Lam with Alef with mada below
    _map_i[? 0xFEF9] = 0xFEF9; //Isolated
    _map_c[? 0xFEF9] = 0xFEFA; //Final
    _map_b[? 0xFEF9] = 0xFEFA; //Medial
    _map_a[? 0xFEF9] = 0xFEF9; //Initial
    _map_i[? 0xFEFA] = 0xFEF9; //Isolated
    _map_c[? 0xFEFA] = 0xFEFA; //Final
    _map_b[? 0xFEFA] = 0xFEFA; //Medial
    _map_a[? 0xFEFA] = 0xFEF9; //Initial
    
    //Lam with Alef with hamza below
    _map_i[? 0xFEFB] = 0xFEFB; //Isolated
    _map_c[? 0xFEFB] = 0xFEFC; //Final
    _map_b[? 0xFEFB] = 0xFEFC; //Medial
    _map_a[? 0xFEFB] = 0xFEFB; //Initial
    _map_i[? 0xFEFC] = 0xFEFB; //Isolated
    _map_c[? 0xFEFC] = 0xFEFC; //Final
    _map_b[? 0xFEFC] = 0xFEFC; //Medial
    _map_a[? 0xFEFC] = 0xFEFB; //Initial
    
    #endregion
    
    
    
    #region Arabic join direction
    
    var _map_prev = global.__scribble_glyph_data.__arabic_join_prev_map;
    var _map_next = global.__scribble_glyph_data.__arabic_join_next_map;
    var _map_i    = global.__scribble_glyph_data.__arabic_isolated_map;
    var _map_a    = global.__scribble_glyph_data.__arabic_initial_map;
    var _map_b    = global.__scribble_glyph_data.__arabic_medial_map;
    var _map_c    = global.__scribble_glyph_data.__arabic_final_map;
    
    var _arabic_array = ds_map_keys_to_array(_map_i);
    var _i = 0;
    repeat(array_length(_arabic_array))
    {
        var _glyph = _arabic_array[_i];
        
        //An Arabic glyph can join to the previous glyph if its initial and medial forms are different
        _map_prev[? _glyph] = (_map_a[? _glyph] != _map_b[? _glyph]);
        
        //An Arabic glyph can join to the next glyph if its initial and isolated forms are different
        _map_next[? _glyph] = (_map_a[? _glyph] != _map_i[? _glyph]);
        
        ++_i;
    }
    
    #endregion
    
    
    
    #region Thai
    
    var _map = global.__scribble_glyph_data.__thai_base_map;
    for(var _i = 0x0E01; _i <= 0x0E2F; _i++) _map[? _i] = true;
    _map[? 0x0E30] = true;
    _map[? 0x0E40] = true;
    _map[? 0x0E41] = true;
    
    var _map = global.__scribble_glyph_data.__thai_base_descender_map;
    _map[? 0x0E0E] = true;
    _map[? 0x0E0F] = true;
    
    var _map = global.__scribble_glyph_data.__thai_base_ascender_map;
    _map[? 0x0E1B] = true;
    _map[? 0x0E1D] = true;
    _map[? 0x0E1F] = true;
    _map[? 0x0E2C] = true;
    
    var _map = global.__scribble_glyph_data.__thai_top_map;
    _map[? 0x0E48] = true;
    _map[? 0x0E49] = true;
    _map[? 0x0E4A] = true;
    _map[? 0x0E4B] = true;
    _map[? 0x0E4C] = true;
    
    var _map = global.__scribble_glyph_data.__thai_lower_map;
    _map[? 0x0E38] = true;
    _map[? 0x0E39] = true;
    _map[? 0x0E3A] = true;
    
    var _map = global.__scribble_glyph_data.__thai_upper_map;
    _map[? 0x0E31] = true;
    _map[? 0x0E34] = true;
    _map[? 0x0E35] = true;
    _map[? 0x0E36] = true;
    _map[? 0x0E37] = true;
    _map[? 0x0E47] = true;
    _map[? 0x0E4D] = true;
    
    #endregion
}