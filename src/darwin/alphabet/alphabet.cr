module Darwin::Alphabet
    abstract class Alphabet(T)
        abstract def random_gene() : T
    end
end