@require "."

##
# Serialize `data` as a JSON String
#
serialize(data) = begin
  io = IOBuffer()
  writemime(io, "application/json", data)
  takebuf_string(io)
end

@test serialize(["a"=>1,"b"=>2]) == """{"b":2,"a":1}"""
@test serialize([1,true,"3"]) == """[1,true,"3"]"""
@test serialize(["a"=>1]) == """{"a":1}"""
@test serialize([1]) == "[1]"
@test serialize(1.0) == "1.0"
@test serialize([]) == "[]"
@test serialize(Dict()) == "{}"

suite("strings") do
  @test [serialize("a")...] == ['"', 'a', '"']
  @test [serialize("\"")...] == ['"', '\\', '"', '"']
  @test [serialize("\n")...] == ['"', '\\', 'n', '"']
end
