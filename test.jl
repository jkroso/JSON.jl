@require "." JSON

function buffer(data)
  buf = IOBuffer()
  writemime(buf, "application/json", data)
  takebuf_array(buf)
end

@test JSON(["a"=>1,"b"=>2]) == """{"b":2,"a":1}"""
@test JSON([1,true,"3"]) == """[1,true,"3"]"""
@test JSON(["a"=>1]) == """{"a":1}"""
@test JSON([1]) == "[1]"
@test JSON(1.0) == "1.0"

suite("strings") do
  @test buffer("a") == Uint8['"', 'a', '"']
  @test buffer("\"") == Uint8['"', '\\', '"', '"']
end
