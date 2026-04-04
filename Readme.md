# JSON.jl

Implements

- `Base.show(::IO, ::MIME"application/json", x)`
- `Base.parse(::MIME"application/json", ::IO)`

## API

```julia
using Kip
@use "github.com/jkroso/JSON.jl/write.jl" json
@use "github.com/jkroso/JSON.jl/read.jl" parse_json
```

### `json(data::Any)`

Returns a JSON `String` representation of `data`

```julia
json([1,"two", true]) # => """[1,"two",true]"""
```

Alternatively you can use

```julia
repr("application/json", [1, "two", true]) # => """[1,"two",true]"""
```

Or

```julia
show(stdout, MIME("application/json"), [1, "two", true])
```

### `parse_json(::Union{IO,String})`

```julia
parse_json("{\"a\":1}")
```

or

```julia
parse(MIME("application/json"), "{\"a\":1}")
```

### `parse_json(data, ::Type{T})`

Parses JSON then converts the result to `T`. By default this just calls `parse_json(data)` and then `convert`s, but specialized methods can parse directly into `T` if they wish.

```julia
parse_json("{\"a\":1}", Dict{String,Int}) # => Dict{String,Int}("a" => 1)
```
