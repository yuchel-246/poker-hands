require 'rails_helper'
require './app/services/judge_hand'
include CardJudgeModule


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
    context 'cardが正しい時resultへ' do
      before do
        card_set = 'S1 S2 S3 S4 S5'
        post :judgment, params: {card_judge_module_judge_hand: {card_set: card_set} }
      end
      it 'リクエストは200 OKとなること' do
        expect(response.status).to eq 200
      end
      it "resultテンプレートに変遷する" do
        expect(response).to render_template :result
      end
    end
    
    context 'cardが不正の時errorへ' do
      before do
        card_set = 'S1 S2 S3 S4 S'
        post :judgment, params: {card_judge_module_judge_hand: {card_set: card_set} }
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
