import Base.writemime
export JSON

typealias JSON MIME"application/json"

##
# Serialize `data` as a JSON String
#
JSON(data) = sprint(writemime, "application/json", data)

# Write data to `io` as a JSON String
# -----------------------------------

function writemime(io::IO, ::JSON, dict::Dict)
  write(io, '{')
  items = collect(dict)
  for (key,value) in items[1:end-1]
    write(io, "\"$key\":")
    writemime(io, "application/json", value)
    write(io, ',')
  end
  write(io, "\"$(items[end][1])\":")
  writemime(io, "application/json", items[end][2])
  write(io, '}')
end

function writemime(io::IO, ::JSON, array::Array)
  write(io, '[')
  for value in array[1:end-1]
    writemime(io, "application/json", value)
    write(io, ',')
  end
  writemime(io, "application/json", array[end])
  write(io, ']')
end

writemime(io::IO, ::JSON, s::String) = write(io, '"', s, '"')
writemime(io::IO, ::JSON, n::Int) = write(io, string(n))
writemime(io::IO, ::JSON, n::FloatingPoint) = write(io, string(n))
writemime(io::IO, ::JSON, b::Bool) = write(io, string(b))
