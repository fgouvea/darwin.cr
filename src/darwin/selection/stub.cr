require "./selection"

module Darwin::Selection
    class StubSelector(T) < SelectionOperator(T)
        property calls = [] of Array(Genome(T))

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