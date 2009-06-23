module Report
  class Table
    attr_accessor :columns
    def initialize(collection, &block)
      @columns = {}
      @collection = collection  
      yield self if block_given?
    end
    
    def column(name, &block)
      @column[name] = []
      if block_given?
        @collection.each do |record|
          @column[name] << yield(record)
        end
      end
      @column[name]
    end

  end
end