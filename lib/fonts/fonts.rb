module Report
  # The Fonts module contains font definitions for Prawn. If you want to add more fonts
  # than those supported natively by Prawn, you will need to add definitions here.
  # For more information see: Prawn::Document#font_families[http://prawn.majesticseacreature.com/docs/prawn-core/classes/Prawn/Document.html]
  module Fonts
    # Path to the Whitney TTF Files
    Whitney_Path = File.expand_path(File.join(File.dirname(__FILE__), 'Whitney'))
        
    AdditionalFonts = {
      "Whitney" => {
        :bold =>        File.join(Whitney_Path, 'WHITNSEM.TTF'),
        :italic =>      File.join(Whitney_Path, 'WHITNLIT.ttf'),
        :bold_italic => File.join(Whitney_Path, 'WHITNDIT.TTF'),
        :normal =>      File.join(Whitney_Path, 'WHITNBOK.ttf')
      }
    }
  end
end
