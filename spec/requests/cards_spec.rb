require 'rails_helper'

RSpec.describe "Cards", type: :request do

  describe "POST /v1/cards" do
    context '3つのカードが正しい時' do

      before do
        cards = {"cards": ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7"]}
        post "/v1/cards", params: cards
      end
    
      it '201が返ってくる' do
        expect(response.status).to eq 201
      end
    
      it '成功時のjsonレスポンスを返す' do
        result_response = {"result"=>[{"best"=>"false", "card"=>"H1 H13 H12 H11 H10", "hand"=>"フラッシュ"}, {"best"=>"true", "card"=>"H9 C9 S9 H2 C2", "hand"=>"フルハウス"}, {"best"=>"false", "card"=>"C13 D12 C11 H8 H7", "hand"=>"ハイカード"}]}
        expect(JSON.parse(response.body)).to eq result_response
      end
    end

    context '3つのカードが不正な場合' do

      before do
        cards = {"cards": ["H1 H13 H12 H11 H10, H16", "H9 C9 S9 H2", "C14 D12 C11 H8 H7"]}
        post "/v1/cards", params: cards
      end
    
      it '201が返ってくる' do
        expect(response.status).to eq 201
      end
    
      it '不正時のjsonレスポンスを返す' do
        error_response = {"error" => [{"card"=>"H1 H13 H12 H11 H10, H16", "msg"=>"5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"}, {"card"=>"H9 C9 S9 H2", "msg"=>"5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"}, {"card"=>"C14 D12 C11 H8 H7", "msg"=>"1番目のカード指定文字が不正です。（C14）半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"}]}
        expect(JSON.parse(response.body)).to eq error_response
      end
    end

    context '正しいカードと不正なカードが混ざっている場合' do

      before do
        cards = {"cards": ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2", "C14 D12 C11 H8 H7"]}
        post "/v1/cards", params: cards
      end
    
      it '201が返ってくる' do
        expect(response.status).to eq 201
      end
    
      it '成功時・不正時のjsonレスポンスを返す' do
        mix_response = {"error" => [{"card"=>"C14 D12 C11 H8 H7", "msg"=>"1番目のカード指定文字が不正です。（C14）半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"}],"result" => [{"best"=>"false", "card"=>"H1 H13 H12 H11 H10", "hand"=>"フラッシュ"}, {"best"=>"true", "card"=>"H9 C9 S9 H2 C2", "hand"=>"フルハウス"}]}
        expect(JSON.parse(response.body)).to eq mix_response
      end
    end

    context 'リクエスト形式が不正な場合' do

      before do
        cards = {"hands": ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7"]}
        post '/v1/cards', params: cards
      end
    
      it '400が返ってくる' do
        expect(response.status).to eq 400
      end

    end

    context 'URLが不正な場合' do

      before do
        cards = {"cards": ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7"}
        post "/v1/card", params: cards
      end
    
      it '404が返ってくる' do
        expect(response.status).to eq 404
      end

    end
  end
end