require 'rails_helper'

describe CardsController do

  describe 'GET #top' do
    it 'リクエストは200 OKとなること' do
      expect(response.status).to eq 200
    end
  end

  describe 'POST #judgment' do
    it "正しいビューに変遷する" do
      expect(response).to render_template :judgement
    end
    it "@cardが期待される値を持つ" do
      expect(assigns(:card)).to be_a_new(JudgeHand)
    end
  end
  
end
