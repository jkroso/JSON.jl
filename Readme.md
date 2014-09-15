
# to-json

A JSON writer for Julia

## Installation

With [packin](//github.com/jkroso/packin): `packin add jkroso/to-json`

## API

### JSON(data::Any)

Returns a JSON representation of `data`

```julia
JSON([1,"two", true]) # => """[1,"two",true]"""
```

### writemime(io::IO, ::MIME"application/json", data::Any)

Write the JSON representation of `data` to `io`. This is used internally by `JSON()` and is the function you should extend if you want to define serializations for new data types
