var _x = 10;
var _y = 10;

var _element = scribble("Text that doesn't specify a pre-processor")
_element.draw(_x, _y);

_y += _element.get_height() + 20;

var _element = scribble("Text that sets <undefined> for its pre-processor")
.preprocessor(undefined);
_element.draw(_x, _y);

_y += _element.get_height() + 20;

var _element = scribble("Text that forces SCRIBBLE_NO_PREPROCESS")
.preprocessor(SCRIBBLE_NO_PREPROCESS);
_element.draw(_x, _y);

_y += _element.get_height() + 20;

var _elementRefresh = scribble("Text that uses a custom pre-processor")
.preprocessor(function(_string)
{
    return "[c_red]" + _string;
});
_elementRefresh.draw(_x, _y);

_y += _element.get_height() + 20;

_elementRefresh.preprocessor(function(_string)
{
    return "[c_blue]" + _string + " (changed via a call to .preprocessor())";
});
_elementRefresh.draw(_x, _y);

_y += _elementRefresh.get_height() + 20;