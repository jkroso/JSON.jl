export json, write_json

##
# Serialize `data` as a JSON String
#
function json(data)
  io = IOBuffer()
  write_json(io, data)
  takebuf_string(io)
end

##
# Write data to a stream or buffer as a JSON String
#
function write_json(io::IO, dict::Dict)
  write(io, '{')
  items = collect(dict)
  for (key,value) in items[1:end-1]
    write(io, "\"$key\":")
    write_json(io, value)
    write(io, ',')
  end
  write(io, "\"$(items[end][1])\":")
  write_json(io, items[end][2])
  write(io, '}')
end

function write_json(io::IO, array::Array)
  write(io, '[')
  for value in array[1:end-1]
    write_json(io, value)
    write(io, ',')
  end
  write_json(io, array[end])
  write(io, ']')
end

function write_json(io::IO, str::String)
  write(io, '"')
  write(io, str)
  write(io, '"')
end

write_json(io::IO, n::Int) = write(io, string(n))
write_json(io::IO, n::FloatingPoint) = write(io, string(n))
write_json(io::IO, b::Bool) = write(io, string(b))
