module Darwin::Alphabet

    # Abstract alphabet class used to provide genes for the genomes in the GA.
    abstract class Alphabet(T)

        # Returns a random gene from the set of possible genes.
        abstract def random_gene() : T
    end
end