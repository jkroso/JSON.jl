
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

Alternatively you can use

```julia
stringmime("application/json", [1, "two", true]) # => """[1,"two",true]"""
```

### `show(io::IO, ::MIME"application/json", data::Any)`

Write the JSON representation of `data` to `io`
