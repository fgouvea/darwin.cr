require "./mutation"

class StubMutator(T) < MutationOperator(T)
    property calls = [] of Array(T)

    def initialize(@mutation_results = [] of Array(T))
    end

    def mutate(genome : Array(T)) : Array(T)
        @calls.push genome

        if @mutation_results.size > 0
            @mutation_results.shift
        else
            genome
        end
    end
end