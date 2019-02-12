class HttpMonitJob < ApplicationJob
  queue_as :default

  def perform(destination)
    HttpMonitService.call(destination)
  end
end
