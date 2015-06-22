typealias M MIME"application/json"

json(value) = sprint(writemime, M(), value)

Base.writemime(io::IO, ::M, n::Real) = write(io, string(n))
Base.writemime(io::IO, ::M, b::Bool) = write(io, string(b))
Base.writemime(io::IO, ::M, ::Nothing) = write(io, "null")

test("Primitives") do
  @test json(1.0) == "1.0"
  @test json(nothing) == "null"
  @test json(false) == "false"
  @test json(true) == "true"
end

function Base.writemime(io::IO, ::M, s::String)
  write(io, '"')
  print_escaped(io, s, "\"")
  write(io, '"')
end

test("Strings") do
  @test json("a") == "\"a\""
  @test json("\"") == "\"\\\"\""
  @test json("\n") == "\"\\n\""
end

function Base.writemime(io::IO, m::M, dict::Dict)
  write(io, '{')
  items = collect(dict)
  if !isempty(items)
    for (key,value) in items[1:end-1]
      write(io, "\"$key\":")
      writemime(io, "application/json", value)
      write(io, ',')
    end
    write(io, "\"$(items[end][1])\":")
    writemime(io, "application/json", items[end][2])
  end
  write(io, '}')
end

test("Dict") do
  @test json(["a"=>1,"b"=>2]) == """{"b":2,"a":1}"""
  @test json(Dict()) == "{}"
  @test json(["a"=>1]) == """{"a":1}"""
end

function Base.writemime(io::IO, ::M, array::Array)
  write(io, '[')
  if !isempty(array)
    for value in array[1:end-1]
      writemime(io, "application/json", value)
      write(io, ',')
    end
    writemime(io, "application/json", array[end])
  end
  write(io, ']')
end

test("Array") do
  @test json([1,true,"3"]) == """[1,true,"3"]"""
  @test json([1]) == "[1]"
  @test json([]) == "[]"
end
