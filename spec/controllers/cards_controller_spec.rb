require 'rails_helper'

describe CardsController do

  describe 'GET #top' do
    before do
      get :top
    end
    it 'リクエストは200 OKとなること' do
      expect(response.status).to eq 200
    end
    it "topテンプレートに変遷する" do
      expect(response).to render_template :top
    end
  end

  describe 'Post #judgment' do
    context 'resultへ' do
      before do
        hand = 'S1 S2 S3 S4 S5'
        post :judgment, params: {judge_hand: {hand: hand} }
      end
      it 'リクエストは200 OKとなること' do
        expect(response.status).to eq 200
      end
      it "resultテンプレートに変遷する" do
        expect(response).to render_template :result
      end
    end
    
    context 'errorへ' do
      before do
        hand = 'S1 S2 S3 S4 S'
        post :judgment, params: {judge_hand: {hand: hand} }
      end
      it 'リクエストは200 OKとなること' do
        expect(response.status).to eq 200
      end
      it "errorテンプレートに変遷する" do
        expect(response).to render_template :error
      end
    end
  end

end
