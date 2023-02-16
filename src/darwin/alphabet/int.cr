require "./alphabet"

module Darwin::Alphabet

    # An alphabet implementation in which each gene is an Int32 inside a specific range.
    class IntAlphabet < Alphabet(Int32)

        # Constructor that can receive the `min` and `max` values for the range of ints that can be generated as genes.
        #
        # By default, the whole Int32 range is available. Use the `min` and `max` parameters to specify the range.
        #
        # The `max` value is **included** in the range.
        #
        # A custom `Random` object can be passed as the `rng` parameter.
        def initialize(@min = Int32::MIN, @max = Int32::MAX, @rng : Random = Random.new)
        end

        # Returns an Int32 inside the `min..max` range.
        def random_gene() : Int32
            @rng.rand(@min..@max)
        end
    end
end