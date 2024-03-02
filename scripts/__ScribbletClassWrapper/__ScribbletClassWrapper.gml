// Feather disable all

function __ScribbletClassWrapper(_element) constructor
{
    __element = _element;
    
    static Draw = function(_x, _y, _colour, _alpha)
    {
        __element.Draw(_x, _y, _colour, _alpha);
        __element.__lastDraw = current_time;
    }
    
    static GetWidth = function(_x, _y, _colour, _alpha)
    {
        return __element.GetWidth();
    }
    
    static GetHeight = function(_x, _y, _colour, _alpha)
    {
        return __element.GetHeight();
    }
}