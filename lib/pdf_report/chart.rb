module Report
  class Chart
    attr_accessor :dataset
    def initialize(chart_type, collection, &block)
      @names = []
      @dataset = {}
      
      @collection = collection
      @defaults = { :inset => 10.mm }
      yield self if block_given?
    end
    

    def series(name=nil, &block)
      @dataset[name] = []
      if block_given?
        @names << name
        @collection.each do |record|
          @dataset[name] << yield(record)
        end
      end
      @dataset[name]
    end
    
    def generate(document) 
      names = @names.dup
      labels = dataset[names.shift]

      bc = GoogleChart::BarChart.new("1000x300", nil, :horizontal, false)
      bc.width_spacing_options(:bar_width=> 'a')
      bc.axis(:y, :labels => labels)
      bc.axis(:x)

      
      names.each do |key|
        bc.data key, dataset[key]
      end
      
      puts bc.to_escaped_url(:chco =>"4D89F9,C6D9FD")

      inset = @defaults[:inset]
      width = document.bounds.width - 2 * inset
      height = width / 4
            
      document.pad(inset) do 
        document.bounding_box([inset, document.cursor], :width => width, :height => height) do
          document.image(open(bc.to_escaped_url(:chco =>'4D89F9,C6D9FD')), :width => width, :height => width/4)
        end
      end
    end
  end
end