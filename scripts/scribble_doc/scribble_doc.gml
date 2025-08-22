// Feather disable all

function scribble_doc(_width, _height) constructor
{
    __elementArray = [];
    
    static create = function(_string, _uniqueID = undefined)
    {
        var _element = new scribble_unique(_string);
        _element.wrap(__width, __height);
        return _element;
    }
    
    static destroy = function(_index)
    {
        array_delete(__elementArray, _index, 1);
    }
    
    static get_element = function(_index)
    {
        if ((_index < 0) || (_index >= array_length(__elementArray)))
        {
            return undefined;
        }
        
        return __elementArray[_index];
    }
    
    static get_count = function()
    {
        return array_length(__elementArray);
    }
    
    static draw = function(_x, _y)
    {
        var _i = 0;
        repeat(array_length(__elementArray))
        {
            var _element = __elementArray[_i]
            _element.draw(_x, _y);
            if (_element.get_state() < 1) break;
            _y += _element.get_bbox().height;
            ++_i;
        }
    }
}