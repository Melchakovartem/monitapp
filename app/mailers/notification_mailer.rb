class NotificationMailer < ApplicationMailer
	def service_down(http_code)
		@http_code = http_code
		mail to: Settings.mailto, subject: 'Service is down'
	end

	def service_up
		mail to: Settings.mailto, subject: 'Service is up'
	end

	def tcp_down
		mail to: Settings.mailto, subject: 'TCP connection is down'
	end
end
