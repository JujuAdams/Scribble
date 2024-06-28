function GlyphData()
{
    static _result = undefined;
    if (_result != undefined) return _result;
    
    _result = {};
    with(_result)
    {
        bidiMap   = ds_map_create();
        mirrorMap = ds_map_create();
        
        arabicJoinPrevMap = ds_map_create();
        arabicJoinNextMap = ds_map_create();
        arabicInitialMap  = ds_map_create();
        arabicMedialMap   = ds_map_create();
        arabicFinalMap    = ds_map_create();
        arabicIsolatedMap = ds_map_create();
        
        thaiBaseMap          = ds_map_create();
        thaiBaseDescenderMap = ds_map_create();
        thaiBaseAscenderMap  = ds_map_create();
        thaiTopMap           = ds_map_create();
        thaiLowerMap         = ds_map_create();
        thaiUpperMap         = ds_map_create();
        
        devanagariLookupMap = ds_map_create();
        devanagariMatraMap  = ds_map_create();
        
        #region BiDi definitions
        
        enum BIDI
        {
            WHITESPACE = 0, //Must be 0 for the sake of __scribble_gen_6_finalize_bidi()
            SYMBOL     = 1, //Must be 1 for the sake of __scribble_gen_6_finalize_bidi()
            ISOLATED,       //More of a layout property - .ISOLATED words get converted to .L2R when building words
            ISOLATED_CJK,
            L2R,
            L2R_DEVANAGARI,
            R2L,
            R2L_ARABIC, //Cursive. Animation indexes are calculated per word
        }
        
        var _map = bidiMap;
        _map[? __SCRIBBLE_GLYPH_SPRITE ] = BIDI.SYMBOL;
        _map[? __SCRIBBLE_GLYPH_SURFACE] = BIDI.SYMBOL;
        for(var _i = 0x0000; _i <= 0x0009; _i++) _map[? _i] = BIDI.SYMBOL;
        _map[? 0x000A] = BIDI.ISOLATED;
        _map[? 0x000B] = BIDI.SYMBOL;
        _map[? 0x000C] = BIDI.SYMBOL;
        _map[? 0x000D] = BIDI.SYMBOL;
        _map[? 0x0020] = BIDI.WHITESPACE; //space
        
        //Symbols
        _map[? ord("!") ] = BIDI.SYMBOL;
        _map[? ord("\"")] = BIDI.SYMBOL;
        _map[? ord("&") ] = BIDI.SYMBOL;
        _map[? ord("'") ] = BIDI.SYMBOL;
        _map[? ord("(") ] = BIDI.SYMBOL;
        _map[? ord(")") ] = BIDI.SYMBOL;
        _map[? ord("*") ] = BIDI.SYMBOL;
        _map[? ord(";") ] = BIDI.SYMBOL;
        _map[? ord("<") ] = BIDI.SYMBOL;
        _map[? ord("=") ] = BIDI.SYMBOL;
        _map[? ord(">") ] = BIDI.SYMBOL;
        _map[? ord("?") ] = BIDI.SYMBOL;
        _map[? ord("@") ] = BIDI.SYMBOL;
        _map[? ord("[") ] = BIDI.SYMBOL;
        _map[? ord("\\")] = BIDI.SYMBOL;
        _map[? ord("]") ] = BIDI.SYMBOL;
        _map[? ord("^") ] = BIDI.SYMBOL;
        _map[? ord("_") ] = BIDI.SYMBOL;
        _map[? ord("`") ] = BIDI.SYMBOL;
        _map[? ord("{") ] = BIDI.SYMBOL;
        _map[? ord("|") ] = BIDI.SYMBOL;
        _map[? ord("}") ] = BIDI.SYMBOL;
        _map[? ord("~") ] = BIDI.SYMBOL;
        _map[? ord(",") ] = BIDI.SYMBOL;
        _map[? ord(".") ] = BIDI.SYMBOL;
        _map[? ord("/") ] = BIDI.SYMBOL;
        _map[? ord(":") ] = BIDI.SYMBOL;
        _map[? ord("-") ] = BIDI.SYMBOL;
        
        //More control characters
        _map[? $200E] = BIDI.L2R; //Left-to-right mark
        _map[? $200F] = BIDI.R2L; //Right-to-left mark
        _map[? $2066] = BIDI.WHITESPACE;
        _map[? $2067] = BIDI.WHITESPACE;
        _map[? $2068] = BIDI.WHITESPACE;
        _map[? $2069] = BIDI.WHITESPACE;
        _map[? $202A] = BIDI.WHITESPACE;
        _map[? $202B] = BIDI.WHITESPACE;
        _map[? $202C] = BIDI.WHITESPACE;
        _map[? $202D] = BIDI.WHITESPACE;
        _map[? $202E] = BIDI.WHITESPACE;
        
        _map[? $00A0] = BIDI.SYMBOL; //Non-breaking space
        _map[? $060C] = BIDI.SYMBOL; //Arabic comma
        _map[? $066B] = BIDI.R2L; //Arabic decimal separator
        _map[? $066C] = BIDI.R2L; //Arabic thousands separator
        for(var _i = 0x0590; _i <= 0x05FF; _i++) _map[? _i] = BIDI.R2L; //Hebrew block
        for(var _i = 0x0600; _i <= 0x06FF; _i++) _map[? _i] = BIDI.R2L_ARABIC; //Arabic block
        for(var _i = 0x0900; _i <= 0x097F; _i++) _map[? _i] = BIDI.L2R_DEVANAGARI; //Hindi block
        for(var _i = 0xFB50; _i <= 0xFDFF; _i++) _map[? _i] = BIDI.R2L_ARABIC; //Arabic presentation forms A
        for(var _i = 0xFE70; _i <= 0xFEFF; _i++) _map[? _i] = BIDI.R2L_ARABIC; //Arabic presentation forms B
        
        //As per https://www.unicode.org/Public/UCD/latest/ucd/BidiMirroring.txt
        var _map = mirrorMap;
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
        
        //Arabic Presentation Forms
        var _mapIso = arabicIsolatedMap;
        var _mapIni = arabicInitialMap;
        var _mapMed = arabicMedialMap;
        var _mapFin = arabicFinalMap;
        var _mapPre = arabicJoinPrevMap;
        var _mapNex = arabicJoinNextMap;
        
        //Hamza
        _mapIso[? 0x0621] = 0xFE80; //Isolated
        _mapFin[? 0x0621] = 0xFE80; //Final
        _mapMed[? 0x0621] = 0xFE80; //Medial
        _mapIni[? 0x0621] = 0xFE80; //Initial
        
        //Alef with madda above
        _mapIso[? 0x0622] = 0xFE81; //Isolated
        _mapFin[? 0x0622] = 0xFE82; //Final
        _mapMed[? 0x0622] = 0xFE82; //Medial
        _mapIni[? 0x0622] = 0xFE81; //Initial
        
        //Alef with hamza above
        _mapIso[? 0x0623] = 0xFE83; //Isolated
        _mapFin[? 0x0623] = 0xFE84; //Final
        _mapMed[? 0x0623] = 0xFE84; //Medial
        _mapIni[? 0x0623] = 0xFE83; //Initial
        
        //Waw with hamza above
        _mapIso[? 0x0624] = 0xFE85; //Isolated
        _mapFin[? 0x0624] = 0xFE86; //Final
        _mapMed[? 0x0624] = 0xFE86; //Medial
        _mapIni[? 0x0624] = 0xFE85; //Initial
        
        //Alef with hamza above
        _mapIso[? 0x0625] = 0xFE87; //Isolated
        _mapFin[? 0x0625] = 0xFE88; //Final
        _mapMed[? 0x0625] = 0xFE88; //Medial
        _mapIni[? 0x0625] = 0xFE87; //Initial
        
        //Yeh with hamza above
        _mapIso[? 0x0626] = 0xFE89; //Isolated
        _mapFin[? 0x0626] = 0xFE8A; //Final
        _mapMed[? 0x0626] = 0xFE8C; //Medial
        _mapIni[? 0x0626] = 0xFE8B; //Initial
        
        //Alif
        _mapIso[? 0x0627] = 0xFE8D; //Isolated
        _mapFin[? 0x0627] = 0xFE8E; //Final
        _mapMed[? 0x0627] = 0xFE8E; //Medial
        _mapIni[? 0x0627] = 0xFE8D; //Initial
        
        //Beh
        _mapIso[? 0x0628] = 0xFE8F; //Isolated
        _mapFin[? 0x0628] = 0xFE90; //Final
        _mapMed[? 0x0628] = 0xFE92; //Medial
        _mapIni[? 0x0628] = 0xFE91; //Initial
        
        //Teh Marbuta
        _mapIso[? 0x0629] = 0xFE93; //Isolated
        _mapFin[? 0x0629] = 0xFE94; //Final
        _mapMed[? 0x0629] = 0xFE94; //Medial
        _mapIni[? 0x0629] = 0xFE93; //Initial
        
        //Teh
        _mapIso[? 0x062A] = 0xFE95; //Isolated
        _mapFin[? 0x062A] = 0xFE96; //Final
        _mapMed[? 0x062A] = 0xFE98; //Medial
        _mapIni[? 0x062A] = 0xFE97; //Initial
        
        //Theh
        _mapIso[? 0x062B] = 0xFE99; //Isolated
        _mapFin[? 0x062B] = 0xFE9A; //Final
        _mapMed[? 0x062B] = 0xFE9C; //Medial
        _mapIni[? 0x062B] = 0xFE9B; //Initial
        
        //Jeem
        _mapIso[? 0x062C] = 0xFE9D; //Isolated
        _mapFin[? 0x062C] = 0xFE9E; //Final
        _mapMed[? 0x062C] = 0xFEA0; //Medial
        _mapIni[? 0x062C] = 0xFE9F; //Initial
        
        //Hah
        _mapIso[? 0x062D] = 0xFEA1; //Isolated
        _mapFin[? 0x062D] = 0xFEA2; //Final
        _mapMed[? 0x062D] = 0xFEA4; //Medial
        _mapIni[? 0x062D] = 0xFEA3; //Initial
        
        //Khah
        _mapIso[? 0x062E] = 0xFEA5; //Isolated
        _mapFin[? 0x062E] = 0xFEA6; //Final
        _mapMed[? 0x062E] = 0xFEA8; //Medial
        _mapIni[? 0x062E] = 0xFEA7; //Initial
        
        //Dal
        _mapIso[? 0x062F] = 0xFEA9; //Isolated
        _mapFin[? 0x062F] = 0xFEAA; //Final
        _mapMed[? 0x062F] = 0xFEAA; //Medial
        _mapIni[? 0x062F] = 0xFEA9; //Initial
        
        //Thal
        _mapIso[? 0x0630] = 0xFEAB; //Isolated
        _mapFin[? 0x0630] = 0xFEAC; //Final
        _mapMed[? 0x0630] = 0xFEAC; //Medial
        _mapIni[? 0x0630] = 0xFEAB; //Initial
        
        //Reh
        _mapIso[? 0x0631] = 0xFEAD; //Isolated
        _mapFin[? 0x0631] = 0xFEAE; //Final
        _mapMed[? 0x0631] = 0xFEAE; //Medial
        _mapIni[? 0x0631] = 0xFEAD; //Initial
        
        //Zain
        _mapIso[? 0x0632] = 0xFEAF; //Isolated
        _mapFin[? 0x0632] = 0xFEB0; //Final
        _mapMed[? 0x0632] = 0xFEB0; //Medial
        _mapIni[? 0x0632] = 0xFEAF; //Initial
        
        //Seen
        _mapIso[? 0x0633] = 0xFEB1; //Isolated
        _mapFin[? 0x0633] = 0xFEB2; //Final
        _mapMed[? 0x0633] = 0xFEB4; //Medial
        _mapIni[? 0x0633] = 0xFEB3; //Initial
        
        //Sheen
        _mapIso[? 0x0634] = 0xFEB5; //Isolated
        _mapFin[? 0x0634] = 0xFEB6; //Final
        _mapMed[? 0x0634] = 0xFEB8; //Medial
        _mapIni[? 0x0634] = 0xFEB7; //Initial
        
        //Sad
        _mapIso[? 0x0635] = 0xFEB9; //Isolated
        _mapFin[? 0x0635] = 0xFEBA; //Final
        _mapMed[? 0x0635] = 0xFEBC; //Medial
        _mapIni[? 0x0635] = 0xFEBB; //Initial
        
        //Dad
        _mapIso[? 0x0636] = 0xFEBD; //Isolated
        _mapFin[? 0x0636] = 0xFEBE; //Final
        _mapMed[? 0x0636] = 0xFEC0; //Medial
        _mapIni[? 0x0636] = 0xFEBF; //Initial
        
        //Tah
        _mapIso[? 0x0637] = 0xFEC1; //Isolated
        _mapFin[? 0x0637] = 0xFEC2; //Final
        _mapMed[? 0x0637] = 0xFEC4; //Medial
        _mapIni[? 0x0637] = 0xFEC3; //Initial
        
        //Zah
        _mapIso[? 0x0638] = 0xFEC5; //Isolated
        _mapFin[? 0x0638] = 0xFEC6; //Final
        _mapMed[? 0x0638] = 0xFEC8; //Medial
        _mapIni[? 0x0638] = 0xFEC7; //Initial
        
        //Ain
        _mapIso[? 0x0639] = 0xFEC9; //Isolated
        _mapFin[? 0x0639] = 0xFECA; //Final
        _mapMed[? 0x0639] = 0xFECC; //Medial
        _mapIni[? 0x0639] = 0xFECB; //Initial
        
        //Ghain
        _mapIso[? 0x063A] = 0xFECD; //Isolated
        _mapFin[? 0x063A] = 0xFECE; //Final
        _mapMed[? 0x063A] = 0xFED0; //Medial
        _mapIni[? 0x063A] = 0xFECF; //Initial
        
        //Tatweel - Elongation symbol
        _mapIso[? 0x0640] = 0x0640; //Isolated
        _mapFin[? 0x0640] = 0x0640; //Final
        _mapMed[? 0x0640] = 0x0640; //Medial
        _mapIni[? 0x0640] = 0x0640; //Initial
        
        //Feh
        _mapIso[? 0x0641] = 0xFED1; //Isolated
        _mapFin[? 0x0641] = 0xFED2; //Final
        _mapMed[? 0x0641] = 0xFED4; //Medial
        _mapIni[? 0x0641] = 0xFED3; //Initial
        
        //Qaf
        _mapIso[? 0x0642] = 0xFED5; //Isolated
        _mapFin[? 0x0642] = 0xFED6; //Final
        _mapMed[? 0x0642] = 0xFED8; //Medial
        _mapIni[? 0x0642] = 0xFED7; //Initial
        
        //Kaf
        _mapIso[? 0x0643] = 0xFED9; //Isolated
        _mapFin[? 0x0643] = 0xFEDA; //Final
        _mapMed[? 0x0643] = 0xFEDC; //Medial
        _mapIni[? 0x0643] = 0xFEDB; //Initial
        
        //Lam
        _mapIso[? 0x0644] = 0xFEDD; //Isolated
        _mapFin[? 0x0644] = 0xFEDE; //Final
        _mapMed[? 0x0644] = 0xFEE0; //Medial
        _mapIni[? 0x0644] = 0xFEDF; //Initial
        
        //Meem
        _mapIso[? 0x0645] = 0xFEE1; //Isolated
        _mapFin[? 0x0645] = 0xFEE2; //Final
        _mapMed[? 0x0645] = 0xFEE4; //Medial
        _mapIni[? 0x0645] = 0xFEE3; //Initial
        
        //Noon
        _mapIso[? 0x0646] = 0xFEE5; //Isolated
        _mapFin[? 0x0646] = 0xFEE6; //Final
        _mapMed[? 0x0646] = 0xFEE8; //Medial
        _mapIni[? 0x0646] = 0xFEE7; //Initial
        
        //Heh
        _mapIso[? 0x0647] = 0xFEE9; //Isolated
        _mapFin[? 0x0647] = 0xFEEA; //Final
        _mapMed[? 0x0647] = 0xFEEC; //Medial
        _mapIni[? 0x0647] = 0xFEEB; //Initial
        
        //Waw
        _mapIso[? 0x0648] = 0xFEED; //Isolated
        _mapFin[? 0x0648] = 0xFEEE; //Final
        _mapMed[? 0x0648] = 0xFEEE; //Medial
        _mapIni[? 0x0648] = 0xFEED; //Initial
        
        //Alef Maksura
        _mapIso[? 0x0649] = 0xFEEF; //Isolated
        _mapFin[? 0x0649] = 0xFEF0; //Final
        _mapMed[? 0x0649] = 0xFEF0; //Medial
        _mapIni[? 0x0649] = 0xFEEF; //Initial
        
        //Yeh
        _mapIso[? 0x064A] = 0xFEF1; //Isolated
        _mapFin[? 0x064A] = 0xFEF2; //Final
        _mapMed[? 0x064A] = 0xFEF4; //Medial
        _mapIni[? 0x064A] = 0xFEF3; //Initial
        
        //Lam with Alef with madda above
        _mapIso[? 0xFEF5] = 0xFEF5; //Isolated
        _mapFin[? 0xFEF5] = 0xFEF6; //Final
        _mapMed[? 0xFEF5] = 0xFEF6; //Medial
        _mapIni[? 0xFEF5] = 0xFEF5; //Initial
        _mapIso[? 0xFEF6] = 0xFEF5; //Isolated
        _mapFin[? 0xFEF6] = 0xFEF6; //Final
        _mapMed[? 0xFEF6] = 0xFEF6; //Medial
        _mapIni[? 0xFEF6] = 0xFEF5; //Initial
        
        //Lam with Alef with hamza above
        _mapIso[? 0xFEF7] = 0xFEF7; //Isolated
        _mapFin[? 0xFEF7] = 0xFEF8; //Final
        _mapMed[? 0xFEF7] = 0xFEF8; //Medial
        _mapIni[? 0xFEF7] = 0xFEF7; //Initial
        _mapIso[? 0xFEF7] = 0xFEF7; //Isolated
        _mapFin[? 0xFEF7] = 0xFEF8; //Final
        _mapMed[? 0xFEF7] = 0xFEF8; //Medial
        _mapIni[? 0xFEF7] = 0xFEF7; //Initial
        
        //Lam with Alef with mada below
        _mapIso[? 0xFEF9] = 0xFEF9; //Isolated
        _mapFin[? 0xFEF9] = 0xFEFA; //Final
        _mapMed[? 0xFEF9] = 0xFEFA; //Medial
        _mapIni[? 0xFEF9] = 0xFEF9; //Initial
        _mapIso[? 0xFEFA] = 0xFEF9; //Isolated
        _mapFin[? 0xFEFA] = 0xFEFA; //Final
        _mapMed[? 0xFEFA] = 0xFEFA; //Medial
        _mapIni[? 0xFEFA] = 0xFEF9; //Initial
        
        //Lam with Alef with hamza below
        _mapIso[? 0xFEFB] = 0xFEFB; //Isolated
        _mapFin[? 0xFEFB] = 0xFEFC; //Final
        _mapMed[? 0xFEFB] = 0xFEFC; //Medial
        _mapIni[? 0xFEFB] = 0xFEFB; //Initial
        _mapIso[? 0xFEFC] = 0xFEFB; //Isolated
        _mapFin[? 0xFEFC] = 0xFEFC; //Final
        _mapMed[? 0xFEFC] = 0xFEFC; //Medial
        _mapIni[? 0xFEFC] = 0xFEFB; //Initial
        
        #endregion
        
        #region Arabic join direction
        
        var _arabicArray = ds_map_keys_to_array(_mapIso);
        var _i = 0;
        repeat(array_length(_arabicArray))
        {
            var _glyph = _arabicArray[_i];
            
            //An Arabic glyph can join to the previous glyph if its initial and medial forms are different
            _mapPre[? _glyph] = (_mapIni[? _glyph] != _mapMed[? _glyph]);
            
            //An Arabic glyph can join to the next glyph if its initial and isolated forms are different
            _mapNex[? _glyph] = (_mapIni[? _glyph] != _mapIso[? _glyph]);
            
            ++_i;
        }
        
        //Tatweel can always connect in both directions
        _mapPre[? 0x640] = true;
        _mapNex[? 0x640] = true;
        
        #endregion
        
        #region Thai C99
        
        var _map = thaiBaseMap;
        for(var _i = 0x0E01; _i <= 0x0E2F; _i++) _map[? _i] = true;
        _map[? 0x0E30] = true;
        _map[? 0x0E40] = true;
        _map[? 0x0E41] = true;
        
        var _map = thaiBaseDescenderMap;
        _map[? 0x0E0E] = true;
        _map[? 0x0E0F] = true;
        
        var _map = thaiBaseAscenderMap;
        _map[? 0x0E1B] = true;
        _map[? 0x0E1D] = true;
        _map[? 0x0E1F] = true;
        _map[? 0x0E2C] = true;
        
        var _map = thaiTopMap;
        _map[? 0x0E48] = true;
        _map[? 0x0E49] = true;
        _map[? 0x0E4A] = true;
        _map[? 0x0E4B] = true;
        _map[? 0x0E4C] = true;
        
        var _map = thaiLowerMap;
        _map[? 0x0E38] = true;
        _map[? 0x0E39] = true;
        _map[? 0x0E3A] = true;
        
        var _map = thaiUpperMap;
        _map[? 0x0E31] = true;
        _map[? 0x0E34] = true;
        _map[? 0x0E35] = true;
        _map[? 0x0E36] = true;
        _map[? 0x0E37] = true;
        _map[? 0x0E47] = true;
        _map[? 0x0E4D] = true;
        
        #endregion
        
        #region Krutidev
        
        var _unicodeSourceArray = [
            "‘",   "’",   "“",   "”",   "(",    ")",   "{",    "}",   "=", "।",  "?",  "-",  "µ", "॰", ",", ".",
            "०",  "१",  "२",  "३",     "४",   "५",  "६",   "७",   "८",   "९", "x", 
            
            "फ़्",  "क़",  "ख़",  "ग़", "ज़्", "ज़",  "ड़",  "ढ़",   "फ़",  "य़",  "ऱ",  "ऩ",  
            "त्त्",   "त्त",     "क्त",  "दृ",  "कृ",
            
            "ह्न",  "ह्य",  "हृ",  "ह्म",  "ह्र",  "ह्",   "द्द",  "क्ष्", "क्ष", "त्र्", "त्र","ज्ञ",
            "छ्य",  "ट्य",  "ठ्य",  "ड्य",  "ढ्य", "द्य","द्व",
            "श्र",  "ट्र",    "ड्र",    "ढ्र",    "छ्र",   "क्र",  "फ्र",  "द्र",   "प्र",   "ग्र", "रु",  "रू",
            "्र",
            
            "म्म्",
            
            "ओ",  "औ",  "आ",   "अ",   "ई",   "इ",  "उ",   "ऊ",  "ऐ",  "ए", "ऋ",
            
            "क्",  "क",  "क्क",  "ख्",   "ख",    "ग्",   "ग",  "घ्",  "घ",    "ङ",
            "चै",   "च्",   "च",   "छ",  "ज्", "ज",   "झ्",  "झ",   "ञ",
            
            "ट्ट",   "ट्ठ",   "ट",   "ठ",   "ड्ड",   "ड्ढ",  "ड",   "ढ",  "ण्", "ण",  
            "त्",  "त",  "थ्", "थ",  "द्ध",  "द", "ध्", "ध",  "न्",  "न",  
            
            "प्",  "प",  "फ्", "फ",  "ब्",  "ब", "भ्",  "भ",  "म्",  "म",
            "य्",  "य",  "र",  "ल्", "ल",  "ळ",  "व्",  "व", 
            "श्", "श",  "ष्", "ष",  "स्",   "स",   "ह",     
            
            "ऑ",   "ॉ",  "ो",   "ौ",   "ा",   "ी",   "ु",   "ू",   "ृ",   "े",   "ै",
            "ं",   "ँ",   "ः",   "ॅ",    "ऽ", chr(0x94D), //virama
        ];
            
        var _krutidevSourceArray = [
            "^", "*",  "Þ", "ß", "¼", "½", "¿", "À", "¾", "A", "\\", "&", "&", "Œ", "]","-", 
            "å",  "ƒ",  "„",   "…",   "†",   "‡",   "ˆ",   "‰",   "Š",   "‹","Û",
            
            "¶",   "d",    "[k",  "x",  "T",  "t",   "M+", "<+", "Q",  ";",    "j",   "u",
            "Ù",   "Ùk",   "Dr",    "–",   "—",       
            
            "à",   "á",    "â",   "ã",   "ºz",  "º",   "í", "{", "{k",  "«", "=","K", 
            "Nî",   "Vî",    "Bî",   "Mî",   "<î", "|","}",
            "J",   "Vª",   "Mª",  "<ªª",  "Nª",   "Ø",  "Ý",   "æ", "ç", "xz", "#", ":",
            "z",
            
            "Ee",
            
            "vks",  "vkS",  "vk",    "v",   "bZ",  "b",  "m",  "Å",  ",s",  ",",   "_",
            
            "D",  "d",    "ô",     "[",     "[k",    "X",   "x",  "?",    "?k",   "³", 
            "pkS",  "P",    "p",  "N",   "T",    "t",   "÷",  ">",   "¥",
            
            "ê",      "ë",      "V",  "B",   "ì",       "ï",     "M",  "<",  ".", ".k",   
            "R",  "r",   "F", "Fk",  ")",    "n", "/",  "/k",  "U", "u",   
            
            "I",  "i",   "¶", "Q",   "C",  "c",  "H",  "Hk", "E",   "e",
            "¸",   ";",    "j",  "Y",   "y",  "G",  "O",  "o",
            "'", "'k",  "\"", "\"k", "L",   "l",   "g",      
            
            "v‚",    "‚",    "ks",   "kS",   "k",     "h",    "q",   "w",   "`",    "s",    "S",
            "a",    "¡",    "%",     "W",   "·", "~",
        ];
        
        var _map = devanagariLookupMap;
        var _i = 0;
        repeat(array_length(_unicodeSourceArray))
        {
            var _string = _unicodeSourceArray[_i];
            
            var _searchInteger = 0;
            var _j = string_length(_string);
            repeat(_j)
            {
                _searchInteger = (_searchInteger << 16) | ord(string_char_at(_string, _j));
                --_j;
            }
            
            var _string = _krutidevSourceArray[_i];
            var _writeArray = [];
            var _j = 1;
            repeat(string_length(_string))
            {
                array_push(_writeArray, ord(string_char_at(_string, _j)));
                ++_j;
            }
            
            _map[? _searchInteger] = _writeArray;
            ++_i;
        }
        
        //Use a ds_map rather than a struct since our keys are integers
        var _map = devanagariMatraMap;
        _map[?   58] = true;
        _map[? 2305] = true;
        _map[? 2306] = true;
        _map[? 2366] = true;
        _map[? 2367] = true;
        _map[? 2368] = true;
        _map[? 2369] = true;
        _map[? 2370] = true;
        _map[? 2371] = true;
        _map[? 2373] = true;
        _map[? 2375] = true;
        _map[? 2376] = true;
        _map[? 2379] = true;
        _map[? 2380] = true;
        
        #endregion
    }
    
    return _result;
}