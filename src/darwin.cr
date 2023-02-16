require "./darwin/**"

# Main module of the lib
#
# Defines the `Darwin::PostProcessor` (`Darwin::Post::PostProcessor`) and `Darwin::Evaluator` (`Darwin::Evaluation::Evaluator`) for convenience, since these are usually the classes that will have to be implemented by the user.
module Darwin
    alias PostProcessor = Post::PostProcessor
    alias Evaluator = Evaluation::Evaluator
end