abstract class MutationOperator(T)
    abstract def mutate(genome : Array(T)) : Array(T)
end