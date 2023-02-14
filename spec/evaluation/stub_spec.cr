require "../spec_helper"

describe StubEvaluator do
    describe "#evaluate" do
        it "should return evaluations in the order they were given" do
            evaluator = StubEvaluator(Int32).new(evaluations: [1.0, 2.0, 3.0])

            result1 = evaluator.evaluate([1, 2, 3])
            result2 = evaluator.evaluate([4, 5, 6])
            result3 = evaluator.evaluate([7, 8, 9])

            result1.should eq 1.0
            result2.should eq 2.0
            result3.should eq 3.0
        end

        it "should return default value after running out of results" do
            evaluator = StubEvaluator(Int32).new(evaluations: [1.0], default_evaluation: 21.0)

            result1 = evaluator.evaluate([1, 2, 3])
            result2 = evaluator.evaluate([4, 5, 6])
            result3 = evaluator.evaluate([7, 8, 9])

            result1.should eq 1.0
            result2.should eq 21.0
            result3.should eq 21.0
        end

        it "should register calls" do
            expected_calls = [[1, 2, 3], [4, 5, 6]]

            evaluator = StubEvaluator(Int32).new(evaluations: [1.0, 2.0, 3.0])

            evaluator.calls.size.should eq 0
            
            evaluator.evaluate(expected_calls[0])

            evaluator.calls.size.should eq 1
            
            evaluator.evaluate(expected_calls[1])
            
            evaluator.calls.size.should eq 2
            evaluator.calls.should eq expected_calls
        end
    end
end         