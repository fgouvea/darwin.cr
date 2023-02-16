require "./alphabet"

module Darwin::Alphabet

    # An alphabet implementation with an array of possible genes.
    class ArrayAlphabet(T) < Alphabet(T)

        # Constructor that receives the array o possible genes.
        #
        # A custom `Random` object can be passed as the `rng` parameter.
        def initialize(@genes : Array(T), @rng : Random = Random.new)
        end

        # Returns a random element from the array.
        def random_gene() : T
            @genes[@rng.rand(@genes.size)] 
        end
    end
end