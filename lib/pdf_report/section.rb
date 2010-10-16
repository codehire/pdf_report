module Report
  class Section
    include Report::Helper
    
    attr_accessor :title, :description, :chart
    attr_reader :table
    
    # Creates a new section, which is yielded to the block if supplied.
    def initialize(title = nil, &block)
      @title = title
      @table = nil
      @chart = nil
      yield(self) if block_given?
    end

    def table(collection, options = {})
      @table = Table.new(collection, options)
      yield @table if block_given?
    end
    
    # Renders the section to the given 
    # Prawn::Document[http://prawn.majesticseacreature.com/docs/prawn-core/classes/Prawn/Document.html] 
    # instance, +document+. Accepts an optional hash of rendering +options+.
    def generate(document, options = {})
      document.pad(options[:padding]) do
        text_with_font document, title, :font => options[:title_font], :size => options[:title_size]
        if description
          document.pad(options[:padding]) do
            text_with_font document, description, :font => options[:body_font], :size => options[:body_size], :style => :italic
          end
        end
        document.font(options[:body_font], :size => options[:body_size], :style => :normal)
        chart.generate(document, options[:chart_options] || {}) if chart
        @table.generate(document, options[:table_options] || {}) if @table
      end
     end
  end
end
