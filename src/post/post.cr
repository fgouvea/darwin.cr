require "../darwin"

abstract class PostProcessor(T)
    abstract def process(engine : Darwin(T))
end