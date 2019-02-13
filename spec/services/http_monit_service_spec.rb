require "rails_helper"

RSpec.describe HttpMonitService do
  context "invalid url" do

    it "raise error" do
      expect { HttpMonitService.new.call("") }.to raise_error OpenURI::HTTPError
    end
  end

  context "valid url" do
    context "service is not available now" do
      let(:not_availbale_service) { "http//notavailble.com/test" }

      it "raise error" do
        expect { HttpMonitService.new.call(not_availbale_service) }.to raise_error OpenURI::HTTPError
      end
    end
  end
end
