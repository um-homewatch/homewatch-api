require "rails_helper"

describe Things::Status::LightController, type: :controller do
  let(:home) { create(:home) }

  describe "GET #show" do
    it "returns the status of a light" do
      light = create(:light, home: home)
      light_status = { on: true }
      stub_status!(light, light_status)

      authenticate(home.user)
      get :show, params: { home_id: home.id, light_id: light.id }

      expect(parsed_response).to eq(light_status)
    end
  end

  describe "PUT #update" do
    it "should update the status of a light" do
      light = create(:light, home: home)
      light_status = { on: false }
      stub_send_status!(light, light_status)

      authenticate(home.user)
      put :update, params: { home_id: home.id, light_id: light.id, status: light_status }

      expect(parsed_response).to eq(light_status)
    end
  end
end