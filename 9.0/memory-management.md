# Memory Management

&nbsp;

## `.build(freeze)`

**Returns**: N/A (`undefined`)

|Name    |Datatype|Purpose                                   |
|--------|--------|------------------------------------------|
|`freeze`|boolean |Whether to freeze generated vertex buffers|

Forces Scribble to build the text model for this text element. Calling this method twice will do nothing even if e.g. a macro command tag would return a different value (please use `.refresh()` instead). You should call this function if you're pre-caching (a.k.a. "stashing") text elements e.g. during a loading screen. Freezing vertex buffers will speed up rendering considerably but has a large up-front cost.

As this function returns `undefined`, the intended use of this function is:

```
///Create
element = scribble("Example test").wrap(200); //Create a new text element, and wrap it to maximum 200px wide
element.build(true); //Now build the text element

///Draw
element.draw(x, y);
```

## `.refresh()`

**Returns**: N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Forces Scribble to rebuild the text model for this text element. This is particularly useful for situations where a stashed text element needs to update e.g. a macro command tag would return a different value.

&nbsp;

## `.flush()`

**Returns**: N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Forces Scribble to remove this text element from the internal cache, invalidating the text element. If you have manually cached a reference to a flushed text element, that text element will no longer be able to be drawn. Given that Scribble actively garbage collects used memory it is uncommon that you'd want to ever use this function, but if you want to tightly manage your memory, this function is available.

&nbsp;

## `scribble_flush_everything()`

**Returns:** N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Frees all memory that Scribble text elements and text models are currently using. You will not normally need to call this function (Scribble automatically garbage collects resources that haven't been used recently) but it's occasionally useful when you need memory to be available immediately, or you want to make sure memory is being freed.

&nbsp;

## `scribble_refresh_everything()`

**Returns:** N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Forces every Scribble text element to refresh their text model. This may be useful if some global property has changed, such as a change in default font or a macro has changed.