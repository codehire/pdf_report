module Report
  class Chart
    attr_accessor :series
    def initialize(chart_type, collection, &block)
      @series = {}
      @collection = collection  
      yield self if block_given?
    end
    
    def series(name, &block)
      @series[name] = []
      if block_given?
        @collection.each do |record|
          @series[name] << yield(record)
        end
      end
      @series[name]
    end
  end
end