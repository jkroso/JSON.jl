@require "."

@test json(["a"=>1,"b"=>2]) == """{"b":2,"a":1}"""
@test json([1,true,"3"]) == """[1,true,"3"]"""
@test json(["a"=>1]) == """{"a":1}"""
@test json([1]) == "[1]"
@test json(1.0) == "1.0"
