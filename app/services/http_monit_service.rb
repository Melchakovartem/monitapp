class HttpMonitService
  require 'net/http'

  attr_reader :connection, :current_status

  def initialize
    @connection, @current_status = nil
  end

  def self.call
    new.call
  end

  def call(destination)
    raise OpenURI::HTTPError.new("Please use correct url", destination) unless destination =~ URI::regexp
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
    end
  end

  private

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
      raise OpenURI::HTTPError.new("Service not availbale", "") if @current_status != "200"
    end

    def check_status(http_code)
      if http_code != "200" and @current_status == "200"
        NotificationMailer.service_down(http_code).deliver_now
        puts "down"
        @current_status = http_code
      elsif http_code == "200" and @current_status != "200"
        NotificationMailer.service_up.deliver_now
        puts "up"
        @current_status = http_code
      end
    end
end