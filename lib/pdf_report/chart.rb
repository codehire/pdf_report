module Report
  class Chart
    attr_accessor :dataset
    def initialize(chart_type, collection, &block)
      @dataset = {}
      @collection = collection
      @defaults = { :inset => 10.mm}
      yield self if block_given?
    end
    

    def series(name=nil, &block)
      @dataset[name] = []
      if block_given?
        @collection.each do |record|
          @dataset[name] << yield(record)
        end
      end
      @dataset[name]
    end
    
    def generate(document) 
      bc = GoogleChart::BarChart.new('800x200', nil, :horizontal, false)
      bc.data_encoding = :text
      @dataset.keys.each do |k|
        bc.data k, @dataset[k]
      end
      
      puts bc.to_escaped_url(:chco =>"4D89F9,C6D9FD")
      inset = @defaults[:inset]
      y= document.cursor
      document.bounding_box([inset, y- inset], :width => document.bounds.width - 2 * inset) do
        document.image(open(bc.to_escaped_url(:chxt =>'y,x',:chco =>'4D89F9,C6D9FD', :chds =>'0,160')), :width => document.bounds.width)
      end
    end
  end
end