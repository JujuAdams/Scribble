# Miscellaneous

&nbsp;

## `[/]`

**Command tag.** Resets the formatting for all effects, fonts, colours, etc.

&nbsp;

## `[nbsp]`

**Command tag.** Inserts a non-breaking space. Actual non-breaking space characters *are* natively supported but `[nbsp]` may be more convenient in some situations.

&nbsp;

## `[zwsp]`

**Command tag.** Inserts a zero-width space. Actual zero-width space characters *are* natively supported but `[zwsp]` may be more convenient in some situations.

&nbsp;

## `scribble_is_text_element(value)`

**Returns:** Boolean, whether the provided value is a Scribble text element

|Name   |Datatype|Purpose      |
|-------|--------|-------------|
|`value`|any     |Value to test|

&nbsp;

## `.template(function, [executeOnlyOnChange])`

**Returns**: The text element

|Name                   |Datatype                       |Purpose                                                                            |
|-----------------------|-------------------------------|-----------------------------------------------------------------------------------|
|`function`             |function, or array of functions|Function to execute to set Scribble behaviour for this text element                |
|`[executeOnlyOnChange]`|boolean                        |Whether to only execute the template function if it has changed. Defaults to `true`|

Executes a function in the scope of this text element. If that function contains method calls then the methods will be applied to this text element. For example:

```
function example_template()
{
    wrap(150);
    blend(c_red, 1);
}

scribble("This text is red and will be wrapped inside a box that's 150px wide.").template(example_template).draw(10, 10);
```

&nbsp;

## `.ignore_command_tags(state)` *regenerator*

**Returns**: The text element

|Name   |Datatype|Purpose                       |
|-------|--------|------------------------------|
|`state`|boolean |Whether to ignore command tags|

Directs Scribble to ignore all [command tags](text-formatting) in the string and instead render them as plaintext.

&nbsp;

## `.z(z)`

**Returns**: The text element

|Name|Datatype|Purpose                                     |
|----|--------|--------------------------------------------|
|`z` |number  |The z coordinate to draw the text element at|

Controls the z coordinate to draw the text element at. This is largely irrelevant in 2D games, but this functionality is occasionally useful nonetheless. The z coordinate defaults to [`SCRIBBLE_DEFAULT_Z`](https://github.com/JujuAdams/Scribble/blob/docs/8.0/configuration.md).

&nbsp;

## `.get_z()`

**Returns**: Number, the z-position of the text element as set by `.z()`

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;

## `.overwrite(string)` *regenerator*

**Returns**: The text element

|Name    |Datatype|Purpose                                     |
|--------|--------|--------------------------------------------|
|`string`|string  |New string to display using the text element|

Replaces the string in an existing text element.

!> This function may cause a recaching of the underlying text model so should be used sparingly. Do not be surprised if this method resets associated typists, invalidates text element state, or causes outright crashes.

&nbsp;

## `.pre_update_typist(typist)`

**Returns**: The text element

|Name     |Datatype|Purpose                                                                                                     |
|---------|--------|------------------------------------------------------------------------------------------------------------|
|`[typist]`|typist |Typist being used to render the text element. See [`scribble_typist()`](typist-methods) for more information|

Updates a typist associated with the text element. You will typically not need to call this method, but it is occasionally useful for resolving order-of-execution issues.