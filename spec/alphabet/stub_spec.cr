require "../spec_helper"

describe StubAlphabet do
    describe "#random_gene" do
        it "returns genes in the order they appear in new" do
            alphabet = StubAlphabet.new(["first", "second", "third"])

            gene1 = alphabet.random_gene
            gene2 = alphabet.random_gene
            gene3 = alphabet.random_gene

            gene1.should eq "first"
            gene2.should eq "second"
            gene3.should eq "third"
        end

        it "should throw exception if it runs out of genes" do
            alphabet = StubAlphabet.new(["only gene"])

            alphabet.random_gene

            expect_raises(IndexError) do
                alphabet.random_gene
            end
        end
    end
end