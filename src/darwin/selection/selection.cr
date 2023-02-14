require "../genome"

module Darwin::Selection
    abstract class SelectionOperator(T)
        abstract def select_mates(genomes : Array(Darwin::Genome(T))) : Tuple(Darwin::Genome(T), Darwin::Genome(T))
    end
end