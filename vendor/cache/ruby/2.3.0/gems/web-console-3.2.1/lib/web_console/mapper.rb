module WebConsole
  class Mapper
    def initialize(exception)
      @exception = exception
      @bindings = exception.bindings
    end

    def [](index)
      trace = @exception.backtrace[index]
      file, line = trace.to_s.strip(':')
      @bindings.find { |b| b.eval('__FILE__') == file && b.eval('__LINE__') == line }
    end
  end
end
