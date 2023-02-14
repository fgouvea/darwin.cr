require "../spec_helper"

include Darwin::Crossover

describe StubCrossover do
    describe "#crossover" do
    
        it "should give results in order they are given" do
            crossover = StubCrossover(Int32).new([[0, 0, 0], [1, 1, 1], [2, 2, 2]])

            result1 = crossover.crossover([1, 2, 3], [4, 5, 6])
            result2 = crossover.crossover([7, 8, 9], [0, 1, 2])
            result3 = crossover.crossover([3, 4, 5], [6, 7, 8])

            result1.should eq [0, 0, 0]
            result2.should eq [1, 1, 1]
            result3.should eq [2, 2, 2]
        end
    
        it "should return unchanged first parent if results run out" do
            crossover = StubCrossover(Int32).new([[0, 0, 0]])

            result1 = crossover.crossover([1, 2, 3], [4, 5, 6])
            result2 = crossover.crossover([7, 8, 9], [0, 1, 2])
            result3 = crossover.crossover([3, 4, 5], [6, 7, 8])

            result1.should eq [0, 0, 0]
            result2.should eq [7, 8, 9]
            result3.should eq [3, 4, 5]
        end
    
        it "should record number of calls" do
            expected_calls = [{[1, 2, 3], [4, 5, 6]},
                            {[7, 8, 9], [0, 1, 2]}]

            crossover = StubCrossover(Int32).new()

            crossover.calls.size.should eq 0

            crossover.crossover(expected_calls[0][0], expected_calls[0][1])

            crossover.calls.size.should eq 1
            
            crossover.crossover(expected_calls[1][0], expected_calls[1][1])

            crossover.calls.size.should eq 2
            crossover.calls.should eq expected_calls
        end
    end
end