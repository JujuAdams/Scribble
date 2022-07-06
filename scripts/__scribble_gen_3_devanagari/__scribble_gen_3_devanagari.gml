#region Build find-replace lookup table

//TODO - Precalculate the lookup table
//TODO - Move this to __scribble_system_glyph_data()
var _unicode_source_array = [
    "‘",   "’",   "“",   "”",   "(",    ")",   "{",    "}",   "=", "।",  "?",  "-",  "µ", "॰", ",", ".",
	"०",  "१",  "२",  "३",     "४",   "५",  "६",   "७",   "८",   "९", "x", 

	"फ़्",  "क़",  "ख़",  "ग़", "ज़्", "ज़",  "ड़",  "ढ़",   "फ़",  "य़",  "ऱ",  "ऩ",  
	"त्त्",   "त्त",     "क्त",  "दृ",  "कृ",

	"ह्न",  "ह्य",  "हृ",  "ह्म",  "ह्र",  "ह्",   "द्द",  "क्ष्", "क्ष", "त्र्", "त्र","ज्ञ",
	"छ्य",  "ट्य",  "ठ्य",  "ड्य",  "ढ्य", "द्य","द्व",
	"श्र",  "ट्र",    "ड्र",    "ढ्र",    "छ्र",   "क्र",  "फ्र",  "द्र",   "प्र",   "ग्र", "रु",  "रू",
	"्र",

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
    
var _krutidev_source_array = [
    "^", "*",  "Þ", "ß", "¼", "½", "¿", "À", "¾", "A", "\\", "&", "&", "Œ", "]","-", 
	"å",  "ƒ",  "„",   "…",   "†",   "‡",   "ˆ",   "‰",   "Š",   "‹","Û",

	"¶",   "d",    "[k",  "x",  "T",  "t",   "M+", "<+", "Q",  ";",    "j",   "u",
	"Ù",   "Ùk",   "Dr",    "–",   "—",       

	"à",   "á",    "â",   "ã",   "ºz",  "º",   "í", "{", "{k",  "«", "=","K", 
	"Nî",   "Vî",    "Bî",   "Mî",   "<î", "|","}",
	"J",   "Vª",   "Mª",  "<ªª",  "Nª",   "Ø",  "Ý",   "æ", "ç", "xz", "#", ":",
	"z",

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

//Use a ds_map rather than a struct since our keys will be integers
global.__scribble_krutidev_lookup_map = ds_map_create();
    
var _i = 0;
repeat(array_length(_unicode_source_array))
{
    var _string = _unicode_source_array[_i];
        
    var _searchInteger = 0;
    var _j = string_length(_string);
    repeat(_j)
    {
        _searchInteger = (_searchInteger << 16) | ord(string_char_at(_string, _j));
        --_j;
    }
        
    var _string = _krutidev_source_array[_i];
    var _writeArray = [];
    var _j = 1;
    repeat(string_length(_string))
    {
        array_push(_writeArray, ord(string_char_at(_string, _j)));
        ++_j;
    }
        
    global.__scribble_krutidev_lookup_map[? _searchInteger] = _writeArray;
        
    ++_i;
}
    
#endregion



#region Build matra lookup table

//Use a ds_map rather than a struct since our keys are integers
//TODO - Convert these to hex and add comments
global.__scribble_krutidev_matra_lookup_map = ds_map_create();
global.__scribble_krutidev_matra_lookup_map[?   58] = true;
global.__scribble_krutidev_matra_lookup_map[? 2305] = true;
global.__scribble_krutidev_matra_lookup_map[? 2306] = true;
global.__scribble_krutidev_matra_lookup_map[? 2366] = true;
global.__scribble_krutidev_matra_lookup_map[? 2367] = true;
global.__scribble_krutidev_matra_lookup_map[? 2368] = true;
global.__scribble_krutidev_matra_lookup_map[? 2369] = true;
global.__scribble_krutidev_matra_lookup_map[? 2370] = true;
global.__scribble_krutidev_matra_lookup_map[? 2371] = true;
global.__scribble_krutidev_matra_lookup_map[? 2373] = true;
global.__scribble_krutidev_matra_lookup_map[? 2375] = true;
global.__scribble_krutidev_matra_lookup_map[? 2376] = true;
global.__scribble_krutidev_matra_lookup_map[? 2379] = true;
global.__scribble_krutidev_matra_lookup_map[? 2380] = true;
    
#endregion



#macro __SCRIBBLE_PARSER_INSERT_NUKTA  ds_grid_set_grid_region(_temp_grid, _glyph_grid, _i+1, 0, _glyph_count+3, __SCRIBBLE_GEN_GLYPH.__SIZE, 0, 0);\
                                       ds_grid_set_grid_region(_glyph_grid, _temp_grid, 0, 0, _glyph_count+3 - _i, __SCRIBBLE_GEN_GLYPH.__SIZE, _i+2, 0);\
                                       ;\
                                       ++_i;\
                                       ++_glyph_count;\
                                       ;\
                                       _glyph_grid[# _i+1, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = 0x093C;\ //Nukta
                                       _glyph_grid[# _i+1, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT];


/// @ignore
function __scribble_gen_3_devanagari()
{
    //Avoid this mess if we can
    if (!__has_devanagari) exit;
    
    var _glyph_grid   = global.__scribble_glyph_grid;
    var _control_grid = global.__scribble_control_grid;
    var _temp_grid    = global.__scribble_temp2_grid;
    var _glyph_count  = global.__scribble_generator_state.__glyph_count;
    
    //Glyph count includes the terminating null. We don't need that for Krutidev conversion
    --_glyph_count;
    
    //Pad the end because we'll need to read beyond the end of the string during the final find-replace
    //We pad with 0xFFFF to avoid accidentally making incorrect substring matches later
    _glyph_grid[# _glyph_count,   __SCRIBBLE_GEN_GLYPH.__UNICODE] = 0xFFFF;
    _glyph_grid[# _glyph_count+1, __SCRIBBLE_GEN_GLYPH.__UNICODE] = 0xFFFF;
    _glyph_grid[# _glyph_count+2, __SCRIBBLE_GEN_GLYPH.__UNICODE] = 0xFFFF;
    _glyph_grid[# _glyph_count+3, __SCRIBBLE_GEN_GLYPH.__UNICODE] = 0xFFFF;
    
    
    
    #region Transform quotes and split up nukta ligatures
    
    var _in_single_quote = false;
    var _in_double_quote = false;
    var _i = 0;
    repeat(_glyph_count)
    {
        switch(_glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE])
        {
            //Set up alternating single quote marks
            case ord("'"):
                _in_single_quote = !_in_single_quote;
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = _in_single_quote? ord("^") : ord("*");
            break;
            
            //Set up alternating double quote marks
            case ord("\""):
                _in_double_quote = !_in_double_quote;
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = _in_double_quote? ord("ß") : ord("Þ");
            break;
            
            //Split up nukta ligatures into their componant parts
            //TODO - Convert to hex and add comments
            case ord("ऩ"):
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = ord("न");
                __SCRIBBLE_PARSER_INSERT_NUKTA
            break;
            
            case ord("ऱ"):
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = ord("र");
                __SCRIBBLE_PARSER_INSERT_NUKTA
            break;
            
            case ord("क़"):
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = ord("क");
                __SCRIBBLE_PARSER_INSERT_NUKTA
            break;
            
            case ord("ख़"):
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = ord("ख");
                __SCRIBBLE_PARSER_INSERT_NUKTA
            break;
            
            case ord("ग़"):
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = ord("ग");
                __SCRIBBLE_PARSER_INSERT_NUKTA
            break;
            
            case ord("ज़"):
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = ord("ज");
                __SCRIBBLE_PARSER_INSERT_NUKTA
            break;
            
            case ord("ड़"):
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = ord("ड");
                __SCRIBBLE_PARSER_INSERT_NUKTA
            break;
            
            case ord("ढ़"):
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = ord("ढ");
                __SCRIBBLE_PARSER_INSERT_NUKTA
            break;
            
            case ord("फ़"):
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = ord("फ");
                __SCRIBBLE_PARSER_INSERT_NUKTA
            break;
            
            case ord("य़"):
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = ord("य");
                __SCRIBBLE_PARSER_INSERT_NUKTA
            break;
        }
        
        ++_i;
    }
    
    #endregion
    
    
    
    #region Reposition ि  to the front of the word and replace it with an "f"
    
    //TODO - Log where ि  is found during the nukta ligature sweep
    var _i = 1; //Start at the second char because we don't care if the string starts with 0x093F (Vowel Sign I)
    repeat(_glyph_count-1)
    {
        var _char = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE];
        if (_char == ord("ि"))
        {
            //If we find a virama behind us keep tracking backwards
            //We go two indexes backwards because virama (should) always follows another character
            var _j = _i - 1;
            while((_j >= 0) && (_glyph_grid[# _j, __SCRIBBLE_GEN_GLYPH.__UNICODE] == 0x094D)) _j -= 2;
            
            //Copy everything from the start of the subtring (where ि  will go) to the end (which is where ि  currently is)
            ds_grid_set_grid_region(_temp_grid, _glyph_grid, _j, 0, _i-1, __SCRIBBLE_GEN_GLYPH.__SIZE, 0, 0);
            
            //Then copy that back into the glyph grid, but one character forwards
            ds_grid_set_grid_region(_glyph_grid, _temp_grid, 0, 0, _i-1 - _j, __SCRIBBLE_GEN_GLYPH.__SIZE, _j+1, 0);
            
            //Insert ि  (encoded in Krutidev as f) into its new position
            _glyph_grid[# _j, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = ord("f");
            _glyph_grid[# _j, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _glyph_grid[# _j+1, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT];
        }
        
        ++_i;
    }
    
    #endregion
    
    
    
    #region Move र् (ra + virama) after matras
    
    var _matraLookupMap = global.__scribble_krutidev_matra_lookup_map;
    
    //Using a for-loop here as _glyph_count may change
    for(var _i = 0; _i < _glyph_count; ++_i)
    {
        //TODO - Log where ra-virama is found during the nukta ligature sweep
        if ((_glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] == ord("र")) && (_glyph_grid[# _i+1, __SCRIBBLE_GEN_GLYPH.__UNICODE] == 0x094D)) //Ra followed by virama
        {
            var _newPosition = _i + 2;
            
            //If the character after the probable position for ra+virama is a matra, keep searching right
            var _charRight = _glyph_grid[# _newPosition+1, __SCRIBBLE_GEN_GLYPH.__UNICODE];
            while(ds_map_exists(_matraLookupMap, _charRight))
            {
                _newPosition++;
                _charRight = _glyph_grid[# _newPosition+1, __SCRIBBLE_GEN_GLYPH.__UNICODE];
            }
            
            var _copyCount = 1 + _newPosition - (_i+2)
            
            //Copy everything after the ra-virama position into the temp buffer
            //We're going to copy that back into the glyph grid in two stages
            ds_grid_set_grid_region(_temp_grid, _glyph_grid, _i+2, 0, _glyph_count-1 + 4, __SCRIBBLE_GEN_GLYPH.__SIZE, _i+2, 0);
            
            //First copy: Move the gylphs between the old position and the new position back two slots
            //            This effective deletes the old ra+virama position
            ds_grid_set_grid_region(_glyph_grid, _temp_grid, _i+2, 0, _newPosition, __SCRIBBLE_GEN_GLYPH.__SIZE, _i, 0);
            
            //Insert the new ra+virama combined character. Krutidev handles this as a single glyph (encoded as Z)
            _glyph_grid[# _i + _copyCount, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = ord("Z");
            _glyph_grid[# _i + _copyCount, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _glyph_grid[# _copyCount-1, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT];
            
            //Second copy: Place the remainder of the glyphs after ra+virama
            ds_grid_set_grid_region(_glyph_grid, _temp_grid, _newPosition+1, 0, _glyph_count+3, __SCRIBBLE_GEN_GLYPH.__SIZE, _i + _copyCount + 1, 0);
            
            //Overall this reduces the total number of glyphs by one since we're replace ra + virama with a single Z
            --_glyph_count;
        }
    }
    
    #endregion
    
    
    
    #region Perform bulk find-replace
    
    var _lookupMap = global.__scribble_krutidev_lookup_map;
    
    //Create a 64-bit minibuffer
    //Fortunately all the characters we're looking for fit into 16 bits and we only need to look for 4 at a time
    var _oneChar   = 0x0000;
    var _twoChar   =              ((_glyph_grid[# 0, __SCRIBBLE_GEN_GLYPH.__UNICODE] & 0xFFFF) << 16);
    var _threeChar = _twoChar   | ((_glyph_grid[# 1, __SCRIBBLE_GEN_GLYPH.__UNICODE] & 0xFFFF) << 32);
    var _fourChar  = _threeChar | ((_glyph_grid[# 2, __SCRIBBLE_GEN_GLYPH.__UNICODE] & 0xFFFF) << 48);
    
    //Using a for-loop here as _glyph_count may change
    for(var _i = 0; _i < _glyph_count; ++_i;)
    {
        _oneChar   = _twoChar   >> 16;
        _twoChar   = _threeChar >> 16;
        _threeChar = _fourChar  >> 16;
        _fourChar  = _threeChar | ((_glyph_grid[# _i+3, __SCRIBBLE_GEN_GLYPH.__UNICODE] & 0xFFFF) << 48);
        
        //Try to find a matching substring
        var _foundLength = 4;
        var _replacementArray = _lookupMap[? _fourChar];
        
        if (_replacementArray == undefined)
        {
            _foundLength = 3;
            _replacementArray = _lookupMap[? _threeChar];
            
            if (_replacementArray == undefined)
            {
                _foundLength = 2;
                _replacementArray = _lookupMap[? _twoChar];
                
                if (_replacementArray == undefined)
                {
                    _foundLength = 1;
                    _replacementArray = _lookupMap[? _oneChar];
                }
            }
        }
        
        //Perform a character replacement if we found any matching substring
        if (_replacementArray != undefined)
        {
            var _replacementLength = array_length(_replacementArray);
            
            if ((_foundLength == 1) && (_replacementLength == 1))
            {
                //Shortcut for the most common replacement operation
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = _replacementArray[0];
            }
            else
            {
                //Heavyweight general replacement code... we want to avoid as many delete/insert commands as possible
                
                //Copy over as much data as possible from one array
                var _copyCount = min(_foundLength, _replacementLength);
                
                var _j = 0;
                repeat(_copyCount)
                {
                    _glyph_grid[# _i + _j, __SCRIBBLE_GEN_GLYPH.__UNICODE] = _replacementArray[_j];
                    ++_j;
                }
                
                if (_foundLength > _replacementLength)
                {
                    //If we're replacing with fewer characters than we found then we need to delete some characters
                    var _copyStart = _i + _copyCount + _foundLength - _replacementLength;
                    var _copyLength = _glyph_count - _copyStart;
                    
                    ds_grid_set_grid_region(_temp_grid, _glyph_grid, _copyStart, 0, _glyph_count, __SCRIBBLE_GEN_GLYPH.__SIZE, 0, 0);
                    ds_grid_set_grid_region(_glyph_grid, _temp_grid, 0, 0, _copyLength, __SCRIBBLE_GEN_GLYPH.__SIZE, _i + _copyCount, 0);
                }
                else if (_foundLength < _replacementLength)
                {
                    //Throw an error if we're trying to add more than one character
                    //I don't think this ever comes up but it might in the future
                    if (_replacementLength - _foundLength > 1)
                    {
                        __scribble_error("Devanagari substring insertion length > 1. Please report this error");
                    }
                    
                    //Otherwise, we're adding characters to the array so we have to insert some characters
                    //This code presumes we're only adding 1 character
                    var _insertPos = _i + _copyCount;
                    ds_grid_set_grid_region(_temp_grid, _glyph_grid, _insertPos, 0, _glyph_count, __SCRIBBLE_GEN_GLYPH.__SIZE, 0, 0);
                    ds_grid_set_grid_region(_glyph_grid, _temp_grid, 0, 0, _glyph_count - _insertPos, __SCRIBBLE_GEN_GLYPH.__SIZE, _insertPos+1, 0);
                    
                    _glyph_grid[# _insertPos, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = _replacementArray[_replacementLength-1];
                    _glyph_grid[# _insertPos, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _glyph_grid[# _insertPos-1, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT];
                }
                
                _i           += _replacementLength - 1; //Off-by-one to account for ++_i in the for-loop
                _glyph_count += _replacementLength - _foundLength;
                
                //Recalculate our minibuffer since we've messed around with the array a lot
                _twoChar   =              ((_glyph_grid[# _i+1, __SCRIBBLE_GEN_GLYPH.__UNICODE] & 0xFFFF) << 16);
                _threeChar = _twoChar   | ((_glyph_grid[# _i+2, __SCRIBBLE_GEN_GLYPH.__UNICODE] & 0xFFFF) << 32);
                _fourChar  = _threeChar | ((_glyph_grid[# _i+3, __SCRIBBLE_GEN_GLYPH.__UNICODE] & 0xFFFF) << 48);
            }
        }
    }
    
    #endregion
    
    
    
    #region Copy data across for all the Krutidev characters we've just inserted
    
    var _control_index = 0;
    
    var _font_name            = undefined;
    var _font_glyphs_map      = undefined;
    var _font_glyph_data_grid = undefined;
    
    var _i = 0;
    repeat(_glyph_count)
    {
        var _control_delta = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] - _control_index;
        repeat(_control_delta)
        {
            if (_control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL.__TYPE] == __SCRIBBLE_GEN_CONTROL_TYPE.__FONT)
            {
                var _font_name            = _control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL.__DATA];
                var _font_data            = __scribble_get_font_data(_font_name);
                var _font_glyph_data_grid = _font_data.__glyph_data_grid;
                var _font_glyphs_map      = _font_data.__glyphs_map;
            }
            
            _control_index++;
        }
        
        var _found_glyph = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE];
        
        var _glyph_write = _found_glyph;
        if (_glyph_write != 32) _glyph_write += __SCRIBBLE_DEVANAGARI_OFFSET;
        
        //Pull info out of the font's data structures
        var _data_index = _font_glyphs_map[? _glyph_write];
        
        //If our glyph is missing, choose the missing character glyph instead!
        if (_data_index == undefined)
        {
            __scribble_trace("Couldn't find glyph data for character code " + string(_found_glyph) + " (" + chr(_found_glyph) + ") in font \"" + string(_font_name) + "\"");
            _glyph_write = ord(SCRIBBLE_MISSING_CHARACTER);
            _data_index = _font_glyphs_map[? _glyph_write];
        }
        
        if (_data_index == undefined)
        {
            //This should only happen if SCRIBBLE_MISSING_CHARACTER is missing for a font
            __scribble_trace("Couldn't find glyph data for character code " + string(_glyph_write) + " (" + chr(_glyph_write) + ") in font \"" + string(_font_name) + "\"");
        }
        else
        {
            //Add this glyph to our grid by copying from the font's own glyph data grid
            ds_grid_set_grid_region(_glyph_grid, _font_glyph_data_grid, _data_index, SCRIBBLE_GLYPH.UNICODE, _data_index, SCRIBBLE_GLYPH.BILINEAR, _i, __SCRIBBLE_GEN_GLYPH.__UNICODE);
        }
        
        ++_i;
    }
    
    //Create a null terminator so we correctly handle the last character in the string
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = 0x00; //ASCII line break (dec = 10)
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__BIDI         ] = __SCRIBBLE_BIDI.ISOLATED;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__X            ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__Y            ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__WIDTH        ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__HEIGHT       ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT  ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__SEPARATION   ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _glyph_grid[# _glyph_count-1, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT]; //Make sure we collect controls at the end of a string
    
    global.__scribble_generator_state.__glyph_count = _glyph_count+1;
    
    #endregion
}
