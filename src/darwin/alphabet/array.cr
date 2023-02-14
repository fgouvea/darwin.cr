require "./alphabet"

module Darwin::Alphabet
    class ArrayAlphabet(T) < Alphabet(T)
        def initialize(@genes : Array(T), @rng : Random = Random.new)
        end

        def random_gene() : T
        @genes[@rng.rand(@genes.size)] 
        end
    end
end