module Report
  class Section
    attr_accessor :title, :description, :table, :chart
    
    def initialize
      @table = nil
      @chart = nil
    end
  end
end