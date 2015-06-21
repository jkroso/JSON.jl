typealias M MIME"application/json"

Base.writemime(io::IO, ::M, n::Real) = write(io, string(n))
Base.writemime(io::IO, ::M, b::Bool) = write(io, string(b))
Base.writemime(io::IO, ::M, ::Nothing) = write(io, "null")

test("Primitives") do
  @test sprint(writemime, M(), 1.0) == "1.0"
  @test sprint(writemime, M(), nothing) == "null"
  @test sprint(writemime, M(), false) == "false"
  @test sprint(writemime, M(), true) == "true"
end

function Base.writemime(io::IO, ::M, s::String)
  write(io, '"')
  print_escaped(io, s, "\"")
  write(io, '"')
end

test("Strings") do
  @test sprint(writemime, M(), "a") == "\"a\""
  @test sprint(writemime, M(), "\"") == "\"\\\"\""
  @test sprint(writemime, M(), "\n") == "\"\\n\""
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
  @test sprint(writemime, M(), ["a"=>1,"b"=>2]) == """{"b":2,"a":1}"""
  @test sprint(writemime, M(), Dict()) == "{}"
  @test sprint(writemime, M(), ["a"=>1]) == """{"a":1}"""
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
  @test sprint(writemime, M(), [1,true,"3"]) == """[1,true,"3"]"""
  @test sprint(writemime, M(), [1]) == "[1]"
  @test sprint(writemime, M(), []) == "[]"
end
