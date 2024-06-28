/// @param glyphArray
/// @param rightToLeftHint
/// @param [copy=true]

function GlyphArrayBiDiReorder(_glyphArray, _rightToLeftHint, _copy = true)
{
    static _bidiMap = GlyphData().bidiMap;
    
    var _overallBidi = _rightToLeftHint? BIDI.R2L : BIDI.L2R;
    if (_copy) _glyphArray = variable_clone(_glyphArray);
    
    var _length = array_length(_glyphArray);
    if (_length <= 1) return _glyphArray
    
    var _bidiArray = array_create(_length, undefined);
    
    //First sweep to set basic bi-directional information
    var _i = 0;
    repeat(_length-1)
    {
        var _glyph = _glyphArray[_i];
        var _bidi  = _bidiMap[? _glyph];
        _bidiArray[_i] = _bidi ?? BIDI.L2R;
        ++_i;
    }
    
    var _funcDetermineBidi = function(_funcDetermineBidi, _overallBidi, _bidiArray, _length, _start, _searchDirection)
    {
        static _bidiMap = GlyphData().bidiMap;
        
        var _inBidi = _bidiArray[_start];
        
        //Already have a concrete directionality, return it
        if ((_inBidi == BIDI.L2R) || (_inBidi == BIDI.R2L))
        {
            return _inBidi;
        }
        
        //L2R aliases
        if ((_inBidi == BIDI.ISOLATED) || (_inBidi == BIDI.ISOLATED_CJK) || (_inBidi == BIDI.L2R_DEVANAGARI))
        {
            _bidiArray[@ _start] = BIDI.L2R;
            return BIDI.L2R;
        }
        
        //R2L alias
        if (_inBidi == BIDI.R2L_ARABIC)
        {
            _bidiArray[@ _start] = BIDI.R2L;
            return BIDI.R2L;
        }
        
        //Symbols try to stick themselves to whatever glyph is immediately adjacent
        if (_inBidi == BIDI.SYMBOL)
        {
            //Check before first
            var _newBidi = (_start <= 0)? undefined : _funcDetermineBidi(_funcDetermineBidi, _overallBidi, _bidiArray, _length, _start-1, undefined);
            if ((_newBidi == BIDI.L2R) || (_newBidi == BIDI.R2L))
            {
                _bidiArray[@ _start] = _newBidi;
                return _newBidi;
            }
            
            //Check after second
            var _newBidi = (_start >= _length-1)? undefined : _funcDetermineBidi(_funcDetermineBidi, _overallBidi, _bidiArray, _length, _start+1, undefined);
            if ((_newBidi == BIDI.L2R) || (_newBidi == BIDI.R2L))
            {
                _bidiArray[@ _start] = _newBidi;
                return _newBidi;
            }
            
            //If we're unsuccessful (which is usually unlikely) then use whitespace logic, which follows
        }
        
        if (_searchDirection == undefined)
        {
            return _inBidi;
        }
        
        if (_searchDirection <= 0)
        {
            var _beforeBidi = (_start <= 0)? undefined : _funcDetermineBidi(_funcDetermineBidi, _overallBidi, _bidiArray, _length, _start-1, -1);
        }
        
        if (_searchDirection >= 0)
        {
            var _afterBidi = (_start >= _length-1)? undefined : _funcDetermineBidi(_funcDetermineBidi, _overallBidi, _bidiArray, _length, _start+1,  1);
        }
        
        if (_searchDirection < 0) return _beforeBidi;
        if (_searchDirection > 0) return _afterBidi;
        
        if (_beforeBidi == undefined) _beforeBidi = _overallBidi;
        if (_afterBidi  == undefined) _afterBidi  = _overallBidi;
        
        //Prefer the overall direction if either adjacent word shares it
        var _newBidi = ((_beforeBidi == _overallBidi) || (_afterBidi == _overallBidi))? _overallBidi : _beforeBidi;
        
        //If we *still* can't decide on the direction, default to L2R
        if ((_newBidi != BIDI.L2R) && (_newBidi != BIDI.R2L)) _newBidi = BIDI.L2R;
        
        //
        var _i = _start;
        repeat(_length - 1 - _start)
        {
            var _bidi = _bidiArray[_i];
            
            //We've found a non-neutral bidi glyph, abort
            if ((_bidi != BIDI.WHITESPACE) && (_bidi != BIDI.SYMBOL)) break;
            
            _bidiArray[@ _i] = _newBidi;
            ++_i;
        }
    }
    
    //Final pass to determine directionality for all glyphs
    var _i = 0;
    repeat(_length-1)
    {
        _funcDetermineBidi(_funcDetermineBidi, _overallBidi, _bidiArray, _length, _i, 0);
        ++_i;
    }
    
    //Reverse stretches of glyphs that do not conform to the overall direction
    var _currentBidi = _bidiArray[0];
    var _start = 0;
    var _i = 1;
    repeat(_length-2)
    {
        var _incomingBidi = _bidiArray[_i];
        if (_incomingBidi != _currentBidi)
        {
            if (_currentBidi != _overallBidi) array_reverse_ext(_glyphArray, _start, _i - _start);
            _currentBidi = _incomingBidi;
            _start = _i;
        }
        
        ++_i;
    }
    
    //If we're in right-to-left mode then reverse the whole lot
    if (_overallBidi == BIDI.R2L) array_reverse_ext(_glyphArray);
    
    return _glyphArray;
}