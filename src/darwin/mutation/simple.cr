require "./mutation"
require "../alphabet"

module Darwin::Mutation

    # A simple implementation for the `MutationOperator`, which for each gene in the genome
    # may randomly (controlled by a probability parameter) assign a random gene in the alphabet.
    #
    # The generic `T` type refers to the type of a gene in the implementation.
    class SimpleMutator(T) < MutationOperator(T)
        
        # Constructor that recieves the `alphabet` used to generate random genes and a `probability` of choosing to alter each gene.
        #
        # A custom `Random` object can be passed as the `rng` parameter.
        def initialize(@alphabet : Darwin::Alphabet::Alphabet(T), @probability : Float64, @rng : Random = Random.new)
        end

        def mutate(genome : Array(T)) : Array(T)
            genome.map do |gene|
                if @rng.rand < @probability
                    @alphabet.random_gene
                else
                    gene
                end
            end
        end
    end
end