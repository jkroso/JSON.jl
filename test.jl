@use "./write.jl" write_json
@use "./read.jl" parse_json
@use Dates...
@use Test...

@testset "write" begin
  @testset "Primitives" begin
    @test write_json(1.0) == "1.0"
    @test write_json(UInt8(1)) == "1"
    @test write_json(nothing) == "null"
    @test write_json(false) == "false"
    @test write_json(true) == "true"
  end

  @testset "Strings" begin
    @test write_json("a") == "\"a\""
    @test write_json("\"") == "\"\\\"\""
    @test write_json("\n") == "\"\\n\""
    @test write_json("\e") == "\"\\u001b\""
  end

  @testset "Symbols" begin
    @test write_json(:a) == "\"a\""
  end

  @testset "Dict" begin
    @test parse_json(write_json(Dict("a"=>1,"b"=>2))) == Dict("a"=>1,"b"=>2)
    @test write_json(Dict()) == "{}"
    @test write_json(Dict("a"=>1)) == """{"a":1}"""
  end

  @testset "NamedTuple" begin
    @test write_json((a=1,b=2)) == """{"a":1,"b":2}"""
  end

  @testset "Vector" begin
    @test write_json([1,true,"3"]) == """[1,true,"3"]"""
    @test write_json([1]) == "[1]"
    @test write_json([]) == "[]"
  end

  @testset "DateTime" begin
    t = DateTime(2026, 3, 9, 9, 37, 32, 251)
    result = parse_json(write_json(Dict("time" => t, "content" => "a")))
    @test result["content"] == "a"
    @test result["time"] == "2026-03-09T09:37:32.251"
  end

  @testset "Set" begin
    @test write_json(Set([1])) == "[1]"
  end

  @testset "Pair" begin
    @test write_json(:a=>1) == "[\"a\",1]"
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
    @test parse_json("7.5e-7") ≈ 7.5e-7
    @test parse_json("1e10") ≈ 1e10
    @test parse_json("2.5E+3") ≈ 2.5e3
    @test parse_json("1e-2") ≈ 0.01
    @test parse_json("{\"v\":7.5e-7}")["v"] ≈ 7.5e-7
    # Float64 precision — Float32 parsing corrupted these (47.849998…,
    # cents lost above ~$131k, integer ids drifting above 2^24).
    @test parse_json("47.85") == 47.85
    @test parse_json("1234567.89") == 1234567.89
    @test parse_json("16777217") == 16777217
    @test parse_json("131072.01") == 131072.01
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
    @test parse_json("[1, 2]", Vector{Float64}) isa Vector{Float64}
  end

  @testset "Dict" begin
    @test parse_json("{}") == Dict{AbstractString,Any}()
    @test parse_json("{\"a\":1}") == Dict{AbstractString,Any}("a"=>1)
  end

  @testset "parse_json(data, T)" begin
    @test parse_json("{\"a\":1}", Dict{String,Float64}) == Dict("a"=>1.0)
    @test parse_json("{\"a\":1}", Dict{String,Float64}) isa Dict{String,Float64}
    @test parse_json("[1,2,3]", Vector{Float32}) == Float32[1,2,3]
    @test parse_json("1.5", Float64) === Float64(1.5)
    @test parse_json("1", Int) === 1
    @test parse_json(IOBuffer("{\"a\":1}"), Dict{String,Int}) == Dict("a"=>1)
  end

  @testset "Date/DateTime" begin
    @test parse_json("\"2026-03-09\"", Date) == Date(2026, 3, 9)
    @test parse_json("\"2026-03-09\"", Date) isa Date
    @test parse_json("\"2026-03-09T09:37:32\"", DateTime) == DateTime(2026, 3, 9, 9, 37, 32)
    @test parse_json("\"2026-03-09T09:37:32.251\"", DateTime) == DateTime(2026, 3, 9, 9, 37, 32, 251)
    @test parse_json("\"2026-03-09T09:37:32.251\"", DateTime) isa DateTime
  end

  @testset "Symbol" begin
    @test parse_json("\"hello\"", Symbol) === :hello
  end

  @testset "Tuple" begin
    @test parse_json("[1,2,3]", Tuple{Float32,Float32,Float32}) === (Float32(1), Float32(2), Float32(3))
    @test parse_json("[1,\"a\"]", Tuple{Int,String}) === (1, "a")
  end

  @testset "Set" begin
    @test parse_json("[1,2,3]", Set{Float32}) == Set{Float32}([1,2,3])
    @test parse_json("[1,2,3]", Set{Float32}) isa Set{Float32}
  end

  @testset "NamedTuple" begin
    @test parse_json("{\"a\":1,\"b\":2}", NamedTuple{(:a,:b),Tuple{Int,Int}}) === (a=1, b=2)
    @test parse_json("{\"x\":\"hi\"}", NamedTuple{(:x,),Tuple{String}}) === (x="hi",)
  end
end
