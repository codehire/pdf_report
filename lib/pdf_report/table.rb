module Report
  class Table
    attr_accessor :columns
    
    def initialize(collection, &block)
      @column_names = []
      @columns = {}
      @collection = collection  
      yield self if block_given?
    end
    
    def column(name, &block)
      @columns[name] = []
      if block_given?
        @column_names << name
        @collection.each do |record|
          @columns[name] << yield(record)
        end
      end
      @columns[name]
    end
    
    def generate(document, table_options={})
      options = table_options.clone
      data = @column_names.map{|k| @columns[k]}.transpose
      document.pad(options.delete(:padding)) do
        document.table data, options.merge(:headers => @column_names, :width => document.bounds.width)
      end
    end
  end
end