require "../spec_helper"

include Darwin::Alphabet

describe StringAlphabet do
    describe "#random_gene" do
        it "returns a gene according to the RNG that is a character on the string" do

            alphabet = StringAlphabet.new(
                alphabet_string: "vasco",
                rng: MockRandom.new(random_ints: [4, 1, 0]))

            gene1 = alphabet.random_gene
            gene2 = alphabet.random_gene
            gene3 = alphabet.random_gene

            gene1.should eq 'o'
            gene2.should eq 'a'
            gene3.should eq 'v'
        end
    end
end