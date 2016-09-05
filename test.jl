@require "." json

test("Primitives") do
  @test json(1.0) == "1.0"
  @test json(nothing) == "null"
  @test json(false) == "false"
  @test json(true) == "true"
end

test("Strings") do
  @test json("a") == "\"a\""
  @test json("\"") == "\"\\\"\""
  @test json("\n") == "\"\\n\""
end

test("Symbols") do
  @test json(:a) == "\"a\""
end

test("Dict") do
  @test json(Dict("a"=>1,"b"=>2)) == """{"b":2,"a":1}"""
  @test json(Dict()) == "{}"
  @test json(Dict("a"=>1)) == """{"a":1}"""
end

test("Vector") do
  @test json([1,true,"3"]) == """[1,true,"3"]"""
  @test json([1]) == "[1]"
  @test json([]) == "[]"
end

test("Set") do
  @test json(Set([1])) == "[1]"
end

test("Pair") do
  @test json(:a=>1) == "[\"a\",1]"
end
