module Report
  class Section
    attr_accessor :title, :description, :table, :chart
    
    def initialize(&block)
      @table = nil
      @chart = nil
      yield self if block_given?
    end
    
    def generate(document)
      document.pad(5.mm) do
        document.text title
        document.text description if description
        chart.generate(document) if chart
        table.generate(document) if table
      end
     end
  end
end