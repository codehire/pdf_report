module Report
  module Helper
    # Renders some +text+ to the given Prawn::Document[http://prawn.majesticseacreature.com/docs/prawn-core/classes/Prawn/Document.html] 
    # instance, +document+, using the suppplied +options+.
    def text_with_font(document, text, options)
      document.font(options.delete(:font) || document.font)
      document.text(text, options)
    end
  end
end