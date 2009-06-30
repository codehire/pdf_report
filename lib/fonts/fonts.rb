module Report
  module Fonts
    Whitney_Path = File.expand_path(File.join(File.dirname(__FILE__), 'Whitney'))
    Whitney = {
      "Whitney" => {
        :bold =>        File.join(Whitney_Path, 'WHITNSEM.TTF'),
        :italic =>      File.join(Whitney_Path, 'WHITNMIT.TTF'),
        :bold_italic => File.join(Whitney_Path, 'WHITNDIT.TTF'),
        :normal =>      File.join(Whitney_Path, 'WHITNMED.ttf')
      }
    }
  end
end