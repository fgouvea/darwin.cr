require "./mutation"

module Darwin::Mutation

    # A stub `MutationOperator` intended for testing.
    #
    # The generic `T` type refers to the type of a gene in the implementation.
    class StubMutator(T) < MutationOperator(T)

        # All the calls received by the stub, with each element being the array of genes received by the `mutate()` method.
        property calls = [] of Array(T)

        # Constructor that receives an array of results the stub will return.
        #
        # If the array runs out, the stub will simply return the original genome that was received.
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
end