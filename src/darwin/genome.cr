require "./config"

module Darwin
    class Genome(T)
        property dna
        property fitness = 0.0

        def initialize(@dna : Array(T))
        end
    end

    class GenomeFactory(T)

        def initialize(@config : Config(T))
        end

        def random() : Genome(T)
            Genome.new((0...@config.genome_length).map {@config.alphabet.random_gene})
        end 
    end
end