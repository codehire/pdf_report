module Report
  class Chart
    
    attr_accessor :dataset, :options
    
    # Creates a new chart instance of the specified +chart_type+ [+:line+ | +:bar+] containing the records supplied in the +collection+ Array.
    # Accepts an +options+ Hash, and an optional block to which the new Table instance will
    # be yielded.
    # The following options are recognised:
    # <tt>:inset</tt>:: margin to apply to the chart image [10.mm]
    # <tt>:size</tt>:: Chart size to be passed to Google Charts API ['1000x300']
    # <tt>:bar_width</tt>:: Bar width to be passed to Google Charts API ['a']
    # <tt>:orientation</tt>:: Orientation [:horizontal]
    # <tt>:colours</tt>:: Colours to be passed to Google Charts API ['4D89F9,C6D9FD']
    def initialize(chart_type, collection, options = {}, &block)
      @names = []
      @dataset = {}    
      @chart_type = chart_type
      @collection = collection
      @options = options
      yield(self) if block_given?
    end
    
    # Defines a Chart data series with a given +name+. The first series to be defined
    # is assumed to be the label series.
    # Supply a block to define how the series should be populated from the underlying
    # +collection+ records. e.g:
    #  c = Report::Chart.new(:bar)
    #  c.series("download") { |rec| rec.download }
    def series(name, &block)
      @dataset[name] = []
      @names << name
      if block_given?
        @collection.each do |record|
          @dataset[name] << yield(record)
        end
      end
      @dataset[name]
    end
    
    # Renders the chart to the given 
    # Prawn::Document[http://prawn.majesticseacreature.com/docs/prawn-core/classes/Prawn/Document.html] 
    # instance, +document+. Accepts an optional hash of +chart_options+.
    def generate(document, chart_options={}) 
      options = chart_options.merge(options || {})
      names = @names.dup
      labels = dataset[names.shift]

      case @chart_type
        when :line
          chart = GoogleChart::LineChart.new(options[:size])
          chart.axis(:x, :labels => labels)
          chart.axis(:y)
        when :bar
          chart = GoogleChart::BarChart.new(options[:size], nil, options[:orientation], false)
          chart.width_spacing_options(:bar_width => options[:bar_width])
          chart.axis(:y, :labels => labels)
          chart.axis(:x)
      end
          
      names.each do |key|
        chart.data key, dataset[key]
      end
      
      inset = options[:inset]
      # Dimensions for inset bounding box and the image within it
      width = document.bounds.width - 2 * inset
      height = width / 4
            
      document.pad(inset) do 
        document.bounding_box([inset, document.cursor], :width => width, :height => height) do
          begin
            chart_file = open(GoogleChart::Base::BASE_URL, :method => :post, :body => chart.escaped_post_params(:chco => options[:colours]))
            document.image(chart_file, :width => width, :height => height)
          rescue
            document.text "ERROR: Could not create chart."
          end
        end
      end
    end
  end
end