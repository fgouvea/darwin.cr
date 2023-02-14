require "./alphabet"
require "./crossover"

module Darwin
    class Config(T)
        property alphabet : Darwin::Alphabet::Alphabet(T)
        property genome_length : Int32
        property population_size : Int32
        property elitism : Int32

        def initialize(@alphabet : Darwin::Alphabet::Alphabet(T), @genome_length : Int32, @population_size : Int32, @elitism = 0)
        end
    end
end