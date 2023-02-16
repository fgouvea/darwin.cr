require "./alphabet"

module Darwin::Alphabet

    # A convenience class to create an `Darwin::Alphabet::ArrayAlphabet(T)` of `Char` from a string. 
    class StringAlphabet < ArrayAlphabet(Char)

        # Constructor that receives the string of genes.
        #
        # Each char in the string will be an element on the `Darwin::Alphabet::ArrayAlphabet(T)` array of genes.
        #
        # A custom `Random` object can be passed as the `rng` parameter.
        def initialize(alphabet_string : String, rng : Random = Random.new)
            super(alphabet_string.chars, rng)
        end
    end
end