module WebConsole
  class Mapper
    def initialize(exception)
      @exception = exception
    end

    def [](index)
      @exception.backtrace[index]
    end
  end
end
