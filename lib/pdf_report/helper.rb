module Report
  module Helper
    def text_with_font(document, text, options)
      document.font(options.delete(:font) || document.font)
      document.text(text, options)
    end
  end
end