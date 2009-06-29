module Report
  class PDF
    attr_accessor :title, :description, :sections
    attr_reader :defaults
    
    def initialize(&block)
      @sections = SectionArray.new
      @defaults = {
        :page_size => "A4", 
        :page_layout => :portrait, 
        :left_margin => 20.mm, 
        :right_margin =>20.mm,
        :top_margin => 25.mm,
        :bottom_margin => 20.mm
        }
      yield self if block_given?
    end
    
    def generate(filename="untitled.pdf")
      title = @title
      description = @description
      sections = @sections
      Prawn::Document.generate(filename) do 
        font "Times-Roman"
        text title
        text description if description
        sections.each do |section|
          section.generate(self)
        end
      end
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