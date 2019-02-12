class NotificationMailer < ApplicationMailer
	def service_down(http_code)
		@http_code = http_code
		mail to: "artem@melchakovvv.ru", subject: 'Service down'
	end

	def service_up
		mail to: "artem@melchakovvv.ru", subject: 'Service up'
	end
end
