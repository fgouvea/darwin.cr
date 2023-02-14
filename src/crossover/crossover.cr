abstract class CrossoverOperator(T)
    abstract def crossover(genome1 : Array(T), genome2 : Array(T)) : Array(T)
end