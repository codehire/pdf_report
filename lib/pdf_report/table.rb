module Report
  class Table
    attr_accessor :columns, :options
    
    # Creates a new table instance containing the records supplied in the +collection+ Array.
    # Accepts an +options+ Hash, and an optional block to which the new Table instance will
    # be yielded. 
    # Recognises and passes all Prawn::Table[http://prawn.majesticseacreature.com/docs/prawn-layout/classes/Prawn/Table.html]
    # options.
    # Also recognises:
    # <tt>:document_padding</tt>:: Vertical padding before and after table.
    def initialize(collection, options = {}, &block)
      @column_names = []
      @columns = {}
      @collection = collection  
      @options = options
      yield(self) if block_given?
    end
    
    # Defines a Table column with a given +name+.
    # Supply a block to define how the column should be populated from the underlying
    # +collection+ records. e.g:
    #  t = Report::PDF::Table.new
    #  t.column("date") { |rec| rec.created_at } 
    #  Alternatively, just provide the name of the column
    #  t.column("date", :created_at)
    def column(name, column_name = nil, &block)
      @columns[name] = []
      @column_names << name
      if block_given?
        @collection.each do |record|
          @columns[name] << if block_given?
            yield(record)
          else
            record.send(:[], column_name)
          end
        end
      end
      @columns[name]
    end
    
    # Renders the table to the given 
    # Prawn::Document[http://prawn.majesticseacreature.com/docs/prawn-core/classes/Prawn/Document.html] 
    # instance, +document+. Accepts an optional hash of +table_options+.
    def generate(document, table_options={})
      options = table_options.merge(options || {})
      data = @column_names.map{|k| @columns[k]}.transpose
      unless data.empty?
        document.pad(options.delete(:document_padding)) do
          document.table data, options.merge(:headers => @column_names, :width => document.bounds.width)
        end
      else
        document.text_box "No Data", :overflow => :expand
      end
    end
  end
end
