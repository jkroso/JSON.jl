
# write-json

Implements `Base.writemime(::IO, ::MIME"application/json", value)` for all the builtin Julia data structures which can be safely writen as JSON.

## API

```julia
@require "github.com/jkroso/write-json.jl" json
```

### `json(data::Any)`

Returns a JSON `String` representation of `data`

```julia
json([1,"two", true]) # => """[1,"two",true]"""
```

### `writemime(io::IO, ::MIME"application/json", data::Any)`

Write the JSON representation of `data` to `io`. This is used internally by `json()` and is the function you should extend if you want to define serializations for new data types
