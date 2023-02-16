require "./post"

module Darwin::Post

    # A stub `PostProcessor` intended for testing.
    #
    # The generic `T` type refers to the type of a gene in the implementation.
    class StubProcessor(T) < PostProcessor(T)

        # Tracks how many times the stub's `process` method as been called.
        property times_called = 0

        # Default constructor
        def initialize()
        end

        def process(engine : Darwin::Engine(T))
            @times_called += 1
        end
    end
end