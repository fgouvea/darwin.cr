require "./selection"

module Darwin::Selection
    
    # A stub of `SelectionOperator` for testing purposes.
    #
    # The generic `T` type refers to the type of a gene in the implementation.
    class StubSelector(T) < SelectionOperator(T)

        # All the calls received by the stub, with each element being the array of genomes received by the `select_mates()` method.
        property calls = [] of Array(Genome(T))

        # Constructor that receives the array of ids (position in the genome array) that will be chosen by the stub.
        #
        # If the array runs out, the stub will return the first two genomes in the array received as a parameter.
        def initialize(@selection_ids = [] of Tuple(Int32, Int32))
        end

        def select_mates(genomes : Array(Genome(T))) : Tuple(Genome(T), Genome(T))
            @calls.push genomes

            ids = {0, 1}

            if @selection_ids.size > 0
                ids = @selection_ids.shift
            end

            {genomes[ids[0]], genomes[ids[1]]}
        end
    end
end