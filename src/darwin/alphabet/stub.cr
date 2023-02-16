require "./alphabet"

module Darwin::Alphabet

    # Stub alphabet intended for testing purposes.
    class StubAlphabet(T) < Alphabet(T)

        # Constructor that receives an array of genes that will be returned by the stub in order.
        def initialize(@random_genes : Array(T))
        end

        # Returns the next element in the array or an error if the array has run out.
        def random_gene() : T
            @random_genes.shift
        end
    end
end