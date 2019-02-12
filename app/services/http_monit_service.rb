class HttpMonitService
  class << self
    require 'net/http'

    def call(destination)
      raise "Please use correct url" unless destination =~ URI::regexp
      set_connection(destination)
      set_current_status
      
      begin
        @connection.start

        loop do
          get = Net::HTTP::Get.new('/')
          http_code = @connection.request(get).code
          check_status(http_code)
        end
      rescue
        NotificationMailer.tcp_down.deliver_now
        puts "tcp down"
      end
    end

    def check_status(http_code)
      if http_code != "200" and @current_status == "200"
        NotificationMailer.service_down(http_code).deliver_now
        puts "down"
        @current_status = http_code
      elsif http_code == "200" and @current_status != "200"
        NotificationMailer.service_up.deliver_now
        @current_status = http_code
      end
    end

    def set_connection(destination)
      uri = URI.parse(destination)
      @connection = Net::HTTP.new(uri.host, uri.port)
      @connection.use_ssl = true if uri.port == 443
      @connection.open_timeout = 1
      @connection.read_timeout = 3
    end

    def set_current_status
      get = Net::HTTP::Get.new('/')
      @current_status = @connection.request(get).code
      raise "Service not available" if @current_status != "200"
    end
  end
end