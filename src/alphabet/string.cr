class StringAlphabet < ArrayAlphabet(Char)
    def initialize(alphabet_string : String, rng : Random = Random.new)
        super(alphabet_string.chars, rng)
    end
end