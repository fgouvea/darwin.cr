require "./config"

module Darwin

    # A genome object that holds an array of genes and its fitness score.
    # The generic `T` type refers to the type of a gene.
    class Genome(T)

        # The array of genes.
        property dna

        # The fitness score calculated by `Darwin::Engine(T)`.
        property fitness = 0.0

        # Constructor that receives the array of genes.
        # Initial fitness is always 0.0
        def initialize(@dna : Array(T))
        end
    end

    # A factory implementation to generate new random genomes.
    class GenomeFactory(T)

        # Constructor that receives a `Darwin::Config(T)` object containing the alphabet and genome length.
        def initialize(@config : Config(T))
        end

        # Generate a random genome.
        #
        # The genome length is dictated by the `Darwin::Config(T)` object passed at the factory initialization.
        #
        # The random genes come from the `Darwin::Alphabet::Alphabet#random_gene()` method implemented by the alphabet.
        def random() : Genome(T)
            Genome.new((0...@config.genome_length).map {@config.alphabet.random_gene})
        end 
    end
end