typealias M MIME"application/json"

json(value) = sprint(writemime, M(), value)

Base.writemime(io::IO, ::M, n::Real) = write(io, string(n))
Base.writemime(io::IO, ::M, b::Bool) = write(io, string(b))
Base.writemime(io::IO, ::M, ::Void) = write(io, "null")

function Base.writemime(io::IO, ::M, s::AbstractString)
  write(io, '"')
  print_escaped(io, s, "\"")
  write(io, '"')
end

Base.writemime(io::IO, m::M, s::Symbol) = writemime(io, m, string(s))

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
