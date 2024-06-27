// Feather disable all

/// @param string

function StringArabicParse(_inString)
{
    static _joinPrevMap = __StringArabicParseData().__joinPrevMap;
    static _joinNextMap = __StringArabicParseData().__joinNextMap;
    static _initialMap  = __StringArabicParseData().__initialMap;
    static _medialMap   = __StringArabicParseData().__medialMap;
    static _finalMap    = __StringArabicParseData().__finalMap;
    static _isolatedMap = __StringArabicParseData().__isolatedMap;
    
    
    
    var _glyphArray = [];
    global.__StringArabicParse_glyphArray = _glyphArray;
    
    string_foreach(_inString, function(_character, _index)
    {
        array_push(global.__StringArabicParse_glyphArray, ord(_character));
    });
    
    array_push(_glyphArray, 0x00);
    
    var _outGlyphArray = [];
    var _prevJoinNext = false;
    
    var _i = 0;
    while(true)
    {
        var _glyphFound = _glyphArray[_i];
        if ((_glyphFound >= 0x0600) && (_glyphFound <= 0x06FF)) // Arabic Unicode block
        {
            var _glyphWrite = _glyphFound;
            var _glyphNext  = _glyphArray[_i+1];
            
            // Lam with Alef ligatures
            if (_glyphWrite == 0x0644)
            {
                if (_glyphNext == 0x0622)
                {
                    _glyphWrite = 0xFEF5; //Lam with Alef with madda above
                }
                else if (_glyphNext == 0x0623)
                {
                    _glyphWrite = 0xFEF7; //Lam with Alef with hamza above
                }
                else if (_glyphNext == 0x0625)
                {
                    _glyphWrite = 0xFEF9; //Lam with Alef with madda below
                }
                else if (_glyphNext == 0x0627)
                {
                    _glyphWrite = 0xFEFB; //Lam with Alef with hamza below
                }
                
                //If we've found a ligature, skip the next glyph
                if (_glyphWrite != _glyphFound)
                {
                    ++_i;
                    _glyphNext = _glyphArray[_i];
                }
            }
            
            // If the next glyph is tashkil, ignore it for the purposes of determining join state
            if ((_glyphNext >= 0x064B) && (_glyphNext <= 0x0652)) //Tashkil range
            {
                var _j = _i;
                do
                {
                    ++_j;
                    _glyphNext = _glyphArray[_j];
                }
                until not ((_glyphNext >= 0x064B) && (_glyphNext <= 0x0652))
            }
            
            // Figure out what to replace this glyph with, depending on what glyphs around it join in which directions
            if (_prevJoinNext) // Does the previous glyph allow joining to us?
            {
                if (_joinPrevMap[? _glyphNext]) // Does the next glyph allow joining to us?
                {
                    array_push(_outGlyphArray, _medialMap[? _glyphWrite] ?? _glyphWrite);
                }
                else
                {
                    array_push(_outGlyphArray, _finalMap[? _glyphWrite] ?? _glyphWrite);
                }
            }
            else
            {
                if (_joinPrevMap[? _glyphNext]) // Does the next glyph allow joining to us?
                {
                    array_push(_outGlyphArray, _initialMap[? _glyphWrite] ?? _glyphWrite);
                }
                else
                {
                    array_push(_outGlyphArray, _isolatedMap[? _glyphWrite] ?? _glyphWrite);
                }
            }
            
            // If this glyph isn't tashkil then update the previous glyph state
            if not ((_glyphFound >= 0x064B) && (_glyphFound <= 0x0652))
            {
                _prevJoinNext = _joinNextMap[? _glyphWrite];
            }
            
            //TODO - Adjust height of shadda after lam
        }
        else if (_glyphFound == 0x00)
        {
            break;
        }
        else
        {
            _prevJoinNext = false;
            array_push(_outGlyphArray, _glyphFound);
        }
        
        ++_i;
    }
    
    array_reverse_ext(_outGlyphArray);
    global.__StringArabicParse_outGlyphArray = _outGlyphArray;
    
    array_foreach(_outGlyphArray, function(_element, _index)
    {
        global.__StringArabicParse_outGlyphArray[@ _index] = chr(_element);
    });
    
    return string_concat_ext(_outGlyphArray);
}

function __StringArabicParseData()
{
    static _result = undefined;
    if (_result != undefined) return _result;
    
    _result = {};
    with(_result)
    {
        __joinPrevMap = ds_map_create();
        __joinNextMap = ds_map_create();
        __initialMap  = ds_map_create();
        __medialMap   = ds_map_create();
        __finalMap    = ds_map_create();
        __isolatedMap = ds_map_create();
    
        //Arabic Presentation Forms
        var _mapIso = __isolatedMap;
        var _mapIni = __initialMap;
        var _mapMed = __medialMap;
        var _mapFin = __finalMap;
        
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
        
        
        
        //Arabic join direction
        var _mapPre = __joinPrevMap;
        var _mapNex = __joinNextMap;
        
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
    }
    
    return _result;
}