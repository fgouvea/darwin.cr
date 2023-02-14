require "spec"
require "../src/darwin/**"

class MockRandom
    include Random
    property range_received

    @range_received : Range(Int32, Int32) | Nil

    def initialize(@random_ints = [] of Int32,
                    @random_floats = [] of Float64,
                    @random_bools = [] of Bool)
    end

    def next_u
        u0
    end

    def rand(r : Range(Int, Int))
        @range_received = r
        return @random_ints.shift
    end

    def rand(max : Int)
        return @random_ints.shift
    end

    def rand()
        return @random_floats.shift
    end

    def next_bool()
        return @random_bools.shift
    end
end