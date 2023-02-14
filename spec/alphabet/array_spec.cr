require "../spec_helper"

include Darwin::Alphabet

describe ArrayAlphabet do
    describe "#random_gene" do
        it "returns a gene according to the RNG" do

            alphabet = ArrayAlphabet(String).new(
                genes: ["second", "first", "third", "shouldn't show up"],
                rng: MockRandom.new(random_ints: [1, 0, 2]))

            gene1 = alphabet.random_gene
            gene2 = alphabet.random_gene
            gene3 = alphabet.random_gene

            gene1.should eq "first"
            gene2.should eq "second"
            gene3.should eq "third"
        end
    end
end