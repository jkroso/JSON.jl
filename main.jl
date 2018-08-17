@require "github.com/JuliaIO/JSON.jl" Common

const M = MIME"application/json"

json(value) = sprint(show, M(), value)

Base.show(io::IO, ::M, s::AbstractString) = begin
  write(io, Common.STRING_DELIM)
  for byte in codeunits(s)
    write(io, Common.ESCAPED_ARRAY[byte + 0x01])
  end
  write(io, Common.STRING_DELIM)
end

Base.show(io::IO, m::M, s::Symbol) = show(io, m, string(s))
Base.show(io::IO, ::M, n::Real) = print(io, n)
Base.show(io::IO, ::M, b::Bool) = show(io, b)
Base.show(io::IO, ::M, ::Nothing) = write(io, "null")

Base.show(io::IO, m::M, dict::AbstractDict) = begin
  write(io, '{')
  first = true
  for (key,value) in dict
    if first
      first = false
    else
      write(io, ',')
    end
    write(io, "\"$key\":")
    show(io, m, value)
  end
  write(io, '}')
end

Base.show(io::IO, m::M, arraylike::Union{Set,Vector,Pair}) = begin
  write(io, '[')
  first = true
  for value in arraylike
    if first
      first = false
    else
      write(io, ',')
    end
    show(io, m, value)
  end
  write(io, ']')
end
