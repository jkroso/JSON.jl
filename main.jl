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

function Base.writemime(io::IO, m::M, dict::Associative)
  write(io, '{')
  first = true
  for (key,value) in dict
    if first
      first = false
    else
      write(io, ',')
    end
    write(io, "\"$key\":")
    writemime(io, m, value)
  end
  write(io, '}')
end

function Base.writemime(io::IO, m::M, arraylike::Union{Set,Vector,Pair})
  write(io, '[')
  first = true
  for value in arraylike
    if first
      first = false
    else
      write(io, ',')
    end
    writemime(io, m, value)
  end
  write(io, ']')
end
