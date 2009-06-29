require 'test_helper'
require 'pdf_report'
class PdfReportTest < ActiveSupport::TestCase  
  should "create a new report" do
    pdf = Report::PDF.new
    assert pdf.instance_of?(Report::PDF)
  end
  
  context "Report::PDF initialised with a block" do
    should "create a new report from that block" do
      title = "My Report"
      description = "Reports data for week ..."
    
      pdf = Report::PDF.new do |n|
        n.title = title
        n.description = description
      end
    
      assert_equal title, pdf.title
      assert_equal description, pdf.description
    end
  end
  
  context "A Report::PDF instance" do
    setup do
      
      collection = [
        ["google.com", "88 minutes", "45 MB"],
        ["facebook.com", "90 minutes", "35 MB"],
        ["netfox.com", "37 minutes", "30 MB"],
        ["news.com.au", "27 minutes", "29 MB"],
        ["yahoo.com", "19 minutes", "11 MB"]
      ] 
      
      @pdf = Report::PDF.new do |r|
        r.title = "Acme Corp: Internet Access Report"
        r.description = "Report Description"
      end
      
      @section = Report::Section.new do |s|
        s.title = "Top Domains"
        s.description = "Top domains accessed between 2009/05/04 and 2009/05/06"
      end
      
      @table = Report::Table.new(collection) do |t|
        t.column("Domain") {|r| r[0]}
        t.column("Time Spent") {|r| r[1]}
        t.column("Download") {|r| r[2]}
      end
      
      @chart = Report::Chart.new(:bar, collection) do |c|
        c.series("Domain") {|r| r[0]}
        c.series("Time Spent") {|r| r[1].split.first.to_i}
        c.series("Download") {|r| r[2].split.first.to_i}
      end
      
    end
    
    should "generate a PDF document" do
      @section.table = @table
      @section.chart = @chart
      @pdf.sections << @section
      @pdf.generate
    end
    
    should "be able to add a section to the pdf with a block" do
      title = "Top Domains"
      description = "Top domains accessed on ..."
      table = mock()
      chart = mock()
      
      assert_equal @pdf.sections.size, 0
      @pdf.sections.add do |section|
        section.title = title
        section.description = description
        section.table = table
        section.chart = chart
      end
      
      assert_equal @pdf.sections.size, 1
      assert_equal @pdf.sections[0].title, title
      assert_equal @pdf.sections[0].description, description
      assert_equal @pdf.sections[0].table, table
      assert_equal @pdf.sections[0].chart, chart
    end
    
    should "be able to iterate through sections using 'each'" do
      assert_respond_to @pdf.sections, :each
    end
    
    should "be able to access a section via array index notation" do
      assert_respond_to @pdf.sections, :[]
    end
  end
  
  context "With a collection of records it" do
    setup do
      @record = mock()
      @record.expects(:foo)
      @record.expects(:bar)
      @record.expects(:baz)
      @collection = [@record]
    end
    
    should "create a new table given a block" do
   
      table = Report::Table.new(@collection) do |table|
        table.column("foo") { |rec| rec.foo}
        table.column("bar") { |rec| rec.bar}
        table.column("baz") { |rec| rec.baz}
      end
      
      assert_equal table.columns.size, 3
    end
    
    should "create a new chart given a block" do
    
      table = Report::Chart.new(:lc, @collection) do |chart|
        chart.series("foo") { |rec| rec.foo}
        chart.series("bar") { |rec| rec.bar}
        chart.series("baz") { |rec| rec.baz}
      end
      
      assert_equal table.dataset.size, 3
    end
  end
end
