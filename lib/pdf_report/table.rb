module Report
  class Table
    attr_accessor :columns
    attr_reader :defaults
    def initialize(collection, &block)
      @column_names = []
      @columns = {}
      @collection = collection  
      @defaults = { 
        :border_style => :grid,
        :border_width => 0.25,
        :inset => 10.mm
         }
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
    
    def generate(document)
      data = @column_names.map{|k| @columns[k]}.transpose
      document.pad(@defaults[:inset]) do
        document.table data, defaults.merge(:headers => @column_names, :width => document.bounds.width)
      end
    end
  end
end