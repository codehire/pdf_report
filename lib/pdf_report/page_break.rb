module Report
  class PageBreak
    include Report::Helper
    
    def generate(document, options = {})
      document.start_new_page
    end
  end
end
