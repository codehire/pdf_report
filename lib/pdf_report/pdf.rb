module Report
  class PDF
    include Report::Helper
    
    attr_accessor :title, :description, :sections
    attr_reader :options
    
    # Constructs a new PDF report instance. Optionally accepts and options Hash
    # and/or a block to which it yields the new instance.
    # 
    #  pdf = Report::PDF.new
    # Or:
    #  pdf = Report::PDF.new(:padding=>10.mm, :prawn_options =>{:page_layout => :landscape})
    # Or:
    #  pdf = Report::PDF.new do |n| 
    #   n.title = "My Report" 
    #   n.description = "Reports data for week starting 2009/10/01"
    #   n.options.update(:padding=>10.mm, :prawn_options =>{:page_layout => :landscape}) 
    #  end
    # The following options are recognised:
    # <tt>:prawn_options</tt>:: Hash of options to pass to Prawn::Document#new. See http://prawn.majesticseacreature.com/docs/prawn-core/ for details.
    # <tt>:table_options</tt>:: Hash of options to control table rendering. See Report::Table#new for details.
    # <tt>:chart_options</tt>:: Hash of options to control chart rendering. See Report::Chart#new for details.
    # <tt>:padding</tt>:: Vertical padding between block elements.
    # <tt>:title_font</tt>:: Font to use when displaying Report and Section titles. [Whitney]
    # <tt>:title_size</tt>:: Font size to use when displaying Report and Section titles. [22]
    # <tt>:body_font</tt>:: Font to use when displaying Report and Section descriptions. [Helvetica]
    # <tt>:body_size</tt>:: Font to use when displaying Report and Section descriptions. [12]
    # <tt>:filename</tt>:: Default filename of generated PDF [untitled.pdf]
    def initialize(options={}, &block)
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
          :font_size => 11,
          :document_padding => 10.mm,
          :header_color => "f6f6f6",
          :header_text_color => "0d57a3",
          :border_color => "dfdfdf",
          :row_colors => %w(fafafa ffffff)
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
        :filename =>"untitled.pdf"
        }

        @options = defaults.merge(options) do |key,old_item,new_item|
          if old_item.kind_of?(Hash) and new_item.kind_of?(Hash)
            # merge hashes within the options hash
            old_item.merge(new_item)
          else
            new_item
          end
        end
      yield(self) if block_given?
    end

    def page_break
      self.sections << PageBreak.new
    end
    
    def generate(filename = nil)
      prawn = Prawn::Document.new(options[:prawn_options]) do |document|
        # Add support for additional fonts
        document.font_families.update(Report::Fonts::AdditionalFonts)
        text_with_font(document, title, :font => options[:title_font], :size => options[:title_size])
        if description
          document.pad(options[:padding]) do
            text_with_font(document, description, :font => options[:body_font], :size => options[:body_size])
          end
        end
        sections.each do |section|
          section.generate(document, options)
        end
      end
      filename ? prawn.render_file(filename) : prawn.render
    end

    def section(title = nil, &block)
      self.sections << Section.new(title, &block)
    end

    class SectionArray < Array
      # Adds a new section to the array. Yields the newly created section instance to the block if one is passed.
      def add(&block)
        section = Section.new
        yield(section) if block_given?
        self << section
      end
    end
  end
end
