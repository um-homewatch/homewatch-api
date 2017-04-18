require "rails_helper"

describe Things::LightsController, type: :controller do
  let(:home) { create(:home) }

  describe "GET #index" do
    it "returns the lights of a home" do
      lights = create_list(:light, 3, home: home)
      json = serialize_to_json(lights)

      authenticate(home.user)
      get :index, params: { home_id: home.id }

      expect(response.body).to eq(json)
    end
  end

  describe "GET #show" do
    it "returns a light from a home" do
      light = create(:light, home: home)
      json = serialize_to_json(light)

      authenticate(home.user)
      get :show, params: { home_id: home.id, id: light.id }

      expect(response.body).to eq(json)
    end

    it "returns a not found status code" do
      light = create(:light)

      authenticate(home.user)
      get :show, params: { home_id: home.id, id: light.id }

      expect(response).to have_http_status(:not_found)
    end
  end

  context "POST #create" do
    it "creates a user light" do
      light_params = attributes_for(:light, home: home)

      authenticate(home.user)

      expect do
        post :create, params: { home_id: home.id, light: light_params }
      end.to change { home.lights.count }.by(1)
    end

    it "returns the created resource" do
      light_params = attributes_for(:light)

      authenticate(home.user)
      post :create, params: { home_id: home.id, light: light_params }

      expect(parsed_response[:subtype]).to eq(light_params[:subtype])
      expect(parsed_response[:connection_info]).to eq(light_params[:connection_info])
    end
  end

  describe "PUT #update" do
    it "updates the status of a light" do
      light = create(:light, home: home)
      light_params = attributes_for(:light)

      authenticate(home.user)
      put :update, params: { home_id: home.id, id: light.id, light: light_params }
      light.reload

      expect(light.subtype).to eq(light_params[:subtype])
      expect(light.connection_info).to eq(light_params[:connection_info])
    end

    it "returns a not found status code" do
      light = create(:light)
      light_params = attributes_for(:light)

      authenticate(home.user)
      put :update, params: { home_id: home.id, id: light.id, light: light_params }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested light" do
      light = create(:light, home: home)

      authenticate(home.user)

      expect do
        delete :destroy, params: { home_id: home.id, id: light.id }
      end.to change { home.lights.count }.by(-1)
    end

    it "returns a not found status code" do
      light = create(:light)

      authenticate(home.user)
      delete :destroy, params: { home_id: home.id, id: light.id }

      expect(response).to have_http_status(:not_found)
    end
  end
end