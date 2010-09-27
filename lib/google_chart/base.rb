module GoogleChart
  class Base
    def escaped_post_params(extras={})
      prepare_params
      puts "extras #{extras.inspect}"
      params.merge!(extras)
    end
  end
end
