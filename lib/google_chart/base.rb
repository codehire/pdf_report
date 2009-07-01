module GoogleChart
  class Base
    def escaped_post_params(extras={})
      prepare_params
      params.merge!(extras)
      result = params.map { |k,v| "#{k}=#{URI.escape(v.to_s)}" }.join('&')      
      puts params[:chd].size
      result
    end
  end
end