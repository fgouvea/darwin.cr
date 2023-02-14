require "./mutation"
require "../alphabet"

module Darwin::Mutation
    class SimpleMutator(T) < MutationOperator(T)
        
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