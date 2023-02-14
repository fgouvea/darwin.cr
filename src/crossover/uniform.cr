require "./crossover"

class UniformCrossover(T) < CrossoverOperator(T)
    def initialize(@rng : Random = Random.new)
    end

    def crossover(genome1 : Array(T), genome2 : Array(T)) : Array(T)
        (0...genome1.size).map do |i|
            if @rng.next_bool 
                genome1[i] 
            else 
                genome2[i]
            end
        end
    end
end
