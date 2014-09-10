
# to-json

A JSON writer for Julia

## Installation

With [packin](//github.com/jkroso/packin): `packin add jkroso/to-json`

## API

### json(data::Any)

Returns a JSON representation of `data` 

```julia
json([1,"two", true]) # => """[1,"two",true]"""
```

### write_json(io::IO, data::Any)

Write the JSON representation of `data` to `io`. This is used internally by `json()` and is the function you should extend if you want to support new types
