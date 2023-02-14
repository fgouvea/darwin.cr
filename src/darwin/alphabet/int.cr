require "./alphabet"

module Darwin::Alphabet
    class IntAlphabet < Alphabet(Int32)
        def initialize(@min = Int32::MIN, @max = Int32::MAX, @rng : Random = Random.new)
        end

        def random_gene() : Int32
            @rng.rand(@min..@max)
        end
    end
end