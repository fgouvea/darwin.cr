require "./alphabet"
require "./crossover"

module Darwin
    
    # Configuration class to be used in the initialization of the `Engine` instance.
    #
    # This config only contains general info such as genome and population sizes, with the GA operators being passed directly to the `Darwin::Engine` object.
    #
    # The generic `T` type refers to the type of a gene in the implementation.
    class Config(T)

        # The alphabet that defines which genes can be part of a genome.
        property alphabet : Darwin::Alphabet::Alphabet(T)

        # How many genes are in each genome
        property genome_length : Int32

        # How many individuals are in the population of each generation of the GA.
        property population_size : Int32

        # How many of the fittest genomes are copied without changes to the next generations.
        #
        # Elitism is a property in the GA that copies the fittest genomes to the next generation directly, without going through the crossover and mutation operators.
        # This may be useful to avoid regressions from one generation to another because the fittest genomes were altered, resulting in a fittest individual with a lower fitness score than the generatino before. Using elitism can speed up the optimization of the GA depending on the problem.
        # _default = 0_
        property elitism : Int32

        def initialize(@alphabet : Darwin::Alphabet::Alphabet(T), @genome_length : Int32, @population_size : Int32, @elitism = 0)
        end
    end
end