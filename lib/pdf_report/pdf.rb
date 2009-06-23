module Report
  class PDF
    attr_accessor :title, :description, :sections
    
    def initialize(&block)
      @sections = SectionArray.new
      yield self if block_given?
    end
    
    class SectionArray < Array
      def add(&block)
        section = Section.new
        yield section if block_given?
        self << section
      end
    end
  end
end