@require "." json
using Base.Test

@testset "Primitives" begin
  @test json(1.0) == "1.0"
  @test json(UInt8(1)) == "1"
  @test json(nothing) == "null"
  @test json(false) == "false"
  @test json(true) == "true"
end

@testset "Strings" begin
  @test json("a") == "\"a\""
  @test json("\"") == "\"\\\"\""
  @test json("\n") == "\"\\n\""
end

@testset "Symbols" begin
  @test json(:a) == "\"a\""
end

@testset "Dict" begin
  @test json(Dict("a"=>1,"b"=>2)) == """{"b":2,"a":1}"""
  @test json(Dict()) == "{}"
  @test json(Dict("a"=>1)) == """{"a":1}"""
end

@testset "Vector" begin
  @test json([1,true,"3"]) == """[1,true,"3"]"""
  @test json([1]) == "[1]"
  @test json([]) == "[]"
end

@testset "Set" begin
  @test json(Set([1])) == "[1]"
end

@testset "Pair" begin
  @test json(:a=>1) == "[\"a\",1]"
end

@testset "Nullable" begin
  @test json(Nullable()) == "null"
  @test json(Nullable(1)) == "1"
end
