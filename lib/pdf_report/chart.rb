module Report
  class Chart
    attr_accessor :dataset
    def initialize(chart_type, collection, &block)
      @names = []
      @dataset = {}    
      @chart_type = chart_type
      @collection = collection      
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
    
    def generate(document, chart_options={}) 
      names = @names.dup
      labels = dataset[names.shift]

      case @chart_type
        when :line
          chart = GoogleChart::LineChart.new(chart_options[:size])
          chart.axis(:x, :labels => labels)
          chart.axis(:y)
        when :bar
          chart = GoogleChart::BarChart.new(chart_options[:size], nil, chart_options[:orientation], false)
          chart.width_spacing_options(:bar_width => chart_options[:bar_width])
          chart.axis(:y, :labels => labels)
          chart.axis(:x)
      end
      
      names.each do |key|
        chart.data key, dataset[key]
      end
      
      inset = chart_options[:inset]
      # Dimensions for inset bounding box and the image within it
      width = document.bounds.width - 2 * inset
      height = width / 4
            
      document.pad(inset) do 
        document.bounding_box([inset, document.cursor], :width => width, :height => height) do
          document.image(open(chart.to_escaped_url(:chco =>chart_options[:colours])), :width => width, :height => height)
        end
      end
    end
  end
end