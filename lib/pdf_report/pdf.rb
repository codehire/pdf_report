module Report
  class PDF
    include Report::Helper
    
    attr_accessor :title, :description, :sections
    attr_reader :options
    
    def initialize(opts={}, &block)
      @sections = SectionArray.new
      defaults = {
        :prawn_options => {
          :page_size => "A4", 
          :page_layout => :portrait, 
          :left_margin => 20.mm, 
          :right_margin =>20.mm,
          :top_margin => 25.mm,
          :bottom_margin => 20.mm 
        },
        :table_options => {
          :border_style => :grid,
          :border_width => 0.25,
          :padding => 10.mm
        },
        :chart_options => {
          :inset => 10.mm,
          :size => '1000x300',
          :bar_width => 'a',
          :orientation => :horizontal,
          :colours => '4D89F9,C6D9FD' 
        },
        :padding => 5.mm,
        :title_font => "Whitney",
        :title_size => 22,        
        :body_font => "Helvetica",
        :body_size => 12,
        :table_size => 11,
        :filename =>"untitled.pdf"
        }
        @options = defaults.merge(opts)
      yield(self) if block_given?
    end
    
    def generate(filename=nil)
      filename ||= options[:filename]
      Prawn::Document.generate(filename, options[:prawn_options]) do |document|
        document.font_families.update(Report::Fonts::Whitney)
        text_with_font(document, title, :font => options[:title_font], :size => options[:title_size])
        if description
          document.pad(options[:padding]) do
            text_with_font(document, title, :font => options[:body_font], :size => options[:body_size])
          end
        end
        sections.each do |section|
          section.generate(document, options)
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