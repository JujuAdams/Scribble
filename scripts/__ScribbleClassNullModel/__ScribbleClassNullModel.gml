// Feather disable all

function __ScribbleClassNullModel() constructor
{
    __lineHeight = 1;
    __hasAnimation = false;
    __hasCycle = false;
    
    __allowGlyphDataGetter = true;
    
    __padBboxL = false;
    __padBboxT = false;
    __padBboxR = false;
    __padBboxB = false;
    
    __pagesArray = [
        {
            __lineDataArray: [
                {
                    
                },
            ],
            
            __regionArray: [],
            __eventsDict: {},
            
            __revealCount: 0,
        },
    ];
    
    __fitScale = 1;
    
    static __Draw = function() {}
    static __Freeze = function() {}
    
    static __GetGlyphData = function()
    {
        return {
            unicode:  0,
            left:     0,
            top:      0,
            right:    0,
            bottom:   0,
            y_offset: 0,
        };
    }
    
    static __GetLineData = function()
    {
        return __pagesArray[0].__lineDataArray[0];
    }
    
    static __GetGlyphCount = function() { return 0; }
    static __GetScrollMaxX = function() { return 0; }
    static __GetScrollMaxY = function() { return 0; }
    static __GetLineCount = function() { return 0; }
    static __GetLinesVisible = function() { return 0; }
    static __GetPageCount = function() { return 0; }
    static __GetWrapped = function() { return false; }
    static __GetText = function() { return ""; }
    static __GetWidth = function() { return 1; }
    static __GetHeight = function() { return 1; }
    
    static __GetBbox = function()
    {
        return {
            left:   0,
            top:    0,
            right:  0,
            bottom: 0,
        };
    }
    
    static __GetBboxRevealed = function()
    {
        return {
            left:   0,
            top:    0,
            right:  0,
            bottom: 0,
        };
    }
}