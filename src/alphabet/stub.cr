class StubAlphabet(T) < Alphabet(T)
    def initialize(@random_genes : Array(T))
    end

    def random_gene() : T
        @random_genes.shift
    end
end