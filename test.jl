@use "./write.jl" json
@use "./read.jl" parse_json
using Test

@testset "write" begin
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
    @test json("\e") == "\"\\u001b\""
  end

  @testset "Symbols" begin
    @test json(:a) == "\"a\""
  end

  @testset "Dict" begin
    @test json(Dict("a"=>1,"b"=>2)) == """{"b":2,"a":1}"""
    @test json(Dict()) == "{}"
    @test json(Dict("a"=>1)) == """{"a":1}"""
  end

  @testset "NamedTuple" begin
    @test json((a=1,b=2)) == """{"a":1,"b":2}"""
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
end

@testset "read" begin
  @testset "primitives" begin
    @test !parse_json("false")
    @test parse_json("true")
    @test parse_json("null") == nothing
  end

  @testset "numbers" begin
    @test parse_json("1") == 1
    @test parse_json("+1") == 1
    @test parse_json("-1") == -1
    @test parse_json("1.0") == 1.0
  end

  @testset "strings" begin
    @test parse_json("\"hi\"") == "hi"
    @test parse_json("\"\\n\"") == "\n"
    @test parse_json("\"\\u0026\"") == "&"
  end

  @testset "Vector" begin
    @test parse_json("[]") == []
    @test parse_json("[1]") == Any[1]
    @test parse_json("[1,2]") == Any[1,2]
    @test parse_json("[ 1, 2 ]") == Any[1,2]
  end

  @testset "Dict" begin
    @test parse_json("{}") == Dict{AbstractString,Any}()
    @test parse_json("{\"a\":1}") == Dict{AbstractString,Any}("a"=>1)
  end
end
