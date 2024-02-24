const ESCAPED_ARRAY = Vector{Vector{UInt8}}(undef, 256)
let LATIN_U = UInt8('u')
    LATIN_R = UInt8('r')
    STRING_DELIM = UInt8('"')
    BACKSPACE = UInt8('\b')
    TAB = UInt8('\t')
    NEWLINE = UInt8('\n')
    FORM_FEED = UInt8('\f')
    RETURN = UInt8('\r')
    SOLIDUS = UInt8('/')
    BACKSLASH = UInt8('\\')
    LATIN_B = UInt8('b')
    LATIN_F = UInt8('f')
    LATIN_T = UInt8('t')
    LATIN_N = UInt8('n')
    ESCAPES = Dict(STRING_DELIM => STRING_DELIM,
                   BACKSLASH    => BACKSLASH,
                   SOLIDUS      => SOLIDUS,
                   LATIN_B      => BACKSPACE,
                   LATIN_F      => FORM_FEED,
                   LATIN_N      => NEWLINE,
                   LATIN_R      => RETURN,
                   LATIN_T      => TAB)
    REVERSE_ESCAPES = Dict(reverse(p) for p in ESCAPES)
  for c in 0x00:0xFF
      ESCAPED_ARRAY[c + 1] = if c == SOLIDUS
          [SOLIDUS]  # don't escape this one
      elseif c ≥ 0x80
          [c]  # UTF-8 character copied verbatim
      elseif haskey(REVERSE_ESCAPES, c)
          [BACKSLASH, REVERSE_ESCAPES[c]]
      elseif iscntrl(Char(c)) || !isprint(Char(c))
          UInt8[BACKSLASH, LATIN_U, string(c, base=16, pad=4)...]
      else
          [c]
      end
  end
end

const M = MIME"application/json"

json(value) = sprint(show, M(), value)

Base.show(io::IO, ::M, s::AbstractString) = begin
  write(io, '"')
  for byte in codeunits(s)
    write(io, ESCAPED_ARRAY[byte + 0x01])
  end
  write(io, '"')
end

Base.show(io::IO, m::M, s::Symbol) = show(io, m, string(s))
Base.show(io::IO, ::M, n::Real) = print(io, n)
Base.show(io::IO, ::M, b::Bool) = show(io, b)
Base.show(io::IO, ::M, ::Nothing) = write(io, "null")

Base.show(io::IO, m::M, nt::NamedTuple) = invoke(show, Tuple{IO,M,AbstractDict}, io, m, pairs(nt))
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

Base.show(io::IO, m::M, arraylike::Union{AbstractSet,AbstractVector,Pair,Tuple}) = begin
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
