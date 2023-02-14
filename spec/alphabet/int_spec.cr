require "../spec_helper"

include Darwin::Alphabet

describe IntAlphabet do
    describe "#random_gene" do
        it "returns a gene according to the RNG" do

            alphabet = IntAlphabet.new(rng: MockRandom.new(random_ints: [123, 456, 789]))

            gene1 = alphabet.random_gene
            gene2 = alphabet.random_gene
            gene3 = alphabet.random_gene

            gene1.should eq 123
            gene2.should eq 456
            gene3.should eq 789
        end

        if "should have the entire Int32 range as its default range"
            rng = MockRandom.new(random_ints: [0])
            alphabet = IntAlphabet.new(rng: rng)

            alphabet.random_gene

            rng.range_received.should eq Int32::MIN..Int32::MAX
        end

        if "should pass specified min and max values to RNG"
            rng = MockRandom.new(random_ints: [0])
            alphabet = IntAlphabet.new(min: 13, max: 21, rng: rng)

            alphabet.random_gene

            rng.range_received.should eq 13..21
        end
    end
end