require "./alphabet"
require "./crossover"

class GAConfig(T)
    property alphabet : Alphabet(T)
    property genome_length : Int32
    property population_size : Int32
    property elitism : Int32

    def initialize(@alphabet : Alphabet(T), @genome_length : Int32, @population_size : Int32, @elitism = 0)
    end
end