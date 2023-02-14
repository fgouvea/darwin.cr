require "../engine"

module Darwin::Post
    abstract class PostProcessor(T)
        abstract def process(engine : Engine(T))
    end
end