module Report
  class Section
    include Report::Helper
    
    attr_accessor :title, :description, :table, :chart
    
    def initialize(&block)
      @table = nil
      @chart = nil
      yield self if block_given?
    end
    
    def generate(document, options = {})
      document.pad(options[:padding]) do
        text_with_font document, title, :font => options[:title_font], :size => options[:title_size]
        if description
          document.pad(options[:padding]) do
            text_with_font document, description, :font => options[:body_font], :size => options[:body_size]
          end
        end
        chart.generate(document, options[:chart_options] || {}) if chart
        table.generate(document, options[:table_options] || {}) if table
      end
     end
  end
end