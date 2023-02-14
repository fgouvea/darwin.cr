require "../genome"

abstract class SelectionOperator(T)
    abstract def select_mates(genomes : Array(Genome(T))) : Tuple(Genome(T), Genome(T))
end