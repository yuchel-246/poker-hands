require 'rails_helper'
require './app/services/judge_hand'
require './app/services/const/hands_name'
require './app/services/const/error_valid_format'
require './app/services/const/error_message'
include CardJudgeModule
include HandsNameModule
include ErrorValidFormatModule
include ErrorMessageModule


describe 'ポーカー形式・役判定テスト' do
  describe 'カード形式判定テスト' do
    context 'A-Zと1-13のカード5枚ある時' do
      before do
        @cards = JudgeHand.new(card: 'S1 S2 S3 S4 S5')
      end
      it '有効である' do
        expect(@cards.valid?).to eq true
      end
    end
    context 'A-Zと1-13のカード6枚ある時' do
      before do
        @cards = JudgeHand.new(card: 'S1 S2 S3 S4 S5 S6')
      end
      it '無効である' do
        expect(@cards.valid?).to eq false
        expect(@cards.msg).to eq VALID_FORMAT_MSG
      end
    end
    context 'A-Zと1-13のカード4枚ある時' do
      before do
        @cards = JudgeHand.new(card: 'S1 S2 S3 S4')
      end
      it '無効である' do
        expect(@cards.valid?).to eq false
        expect(@cards.msg).to eq VALID_FORMAT_MSG
      end
    end
    context 'A-Zと1-13のカード5枚だが同じカードがある時' do
      before do
        @cards = JudgeHand.new(card: 'S1 S2 S3 S4 S4')
      end
      it '無効である' do
        expect(@cards.valid?).to eq false
        expect(@cards.msg).to eq VALID_DUPLICATION_MSG
      end
    end
    context '存在しないスートが含まれている時' do
      before do
        @cards = JudgeHand.new(card: 'A1 S2 S3 S4 S5')
      end
      it '無効である' do
        expect(@cards.valid?).to eq false
        expect(@cards.msg).to eq @cards.identify
      end
    end
    context '存在しない数字が存在する時' do
      before do
        @cards = JudgeHand.new(card: 'S14 S2 S3 S4 S5')
      end
      it '無効である' do
        expect(@cards.valid?).to eq false
        expect(@cards.msg).to eq @cards.identify
      end
    end
    context 'カードの形式が異なる時' do
      before do
        @cards = JudgeHand.new(card: 'S S2 S3 S4 S5')
      end
      it '無効である' do
        expect(@cards.valid?).to eq false
        expect(@cards.msg).to eq @cards.identify
      end
    end
    context 'カードが半角スペースで区切られていない時' do
      before do
        @cards = JudgeHand.new(card: 'S1/S2/S3/S4/S5')
      end
      it '無効である' do
        expect(@cards.valid?).to eq false
        expect(@cards.msg).to eq VALID_FORMAT_MSG
      end
    end
  end

  describe '役判定テスト' do
    context '役がSTRAIGHT_FLASHの時' do
      before do
        @cards = JudgeHand.new(card: 'S1 S2 S3 S4 S5')
        @cards.judge
      end
      it 'ストレートフラッシュを返す' do
        expect(@cards.hand).to eq STRAIGHT_FLASH
      end
    end
    context '役がSTRAIGHTの時' do
      before do
        @cards = JudgeHand.new(card: 'D1 S2 S3 S4 S5')
        @cards.judge
      end
      it 'ストレートを返す' do
        expect(@cards.hand).to eq STRAIGHT
      end
    end
    context '役がFLASHの時' do
      before do
        @cards = JudgeHand.new(card: 'S1 S2 S3 S4 S6')
        @cards.judge
      end
      it 'フラッシュを返す' do
        expect(@cards.hand).to eq FLASH
      end
    end
    context '役がFOUR_OF_A_KINDの時' do
      before do
        @cards = JudgeHand.new(card: 'S1 D1 H1 C1 S5')
        @cards.judge
      end
      it 'フォー・オブ・ア・カインドを返す' do
        expect(@cards.hand).to eq FOUR_OF_A_KIND
      end
    end
    context '役がFULLHOUSEの時' do
      before do
        @cards = JudgeHand.new(card: 'S1 D1 H1 S2 D2')
        @cards.judge
      end
      it 'フルハウスを返す' do
        expect(@cards.hand).to eq FULLHOUSE
      end
    end
    context '役がTHREE_OF_A_KINDの時' do
      before do
        @cards = JudgeHand.new(card: 'S1 D1 H1 S2 S3')
        @cards.judge
      end
      it 'スリー・オブ・ア・カインドを返す' do
        expect(@cards.hand).to eq THREE_OF_A_KIND
      end
    end
    context '役がTWO_PAIRの時' do
      before do
        @cards = JudgeHand.new(card: 'S1 D1 S2 D2 S3')
        @cards.judge
      end
      it 'ツーペアを返す' do
        expect(@cards.hand).to eq TWO_PAIR
      end
    end
    context '役がONE_PAIRの時' do
      before do
        @cards = JudgeHand.new(card: 'S1 D1 S3 S4 S5')
        @cards.judge
      end
      it 'ワンペアを返す' do
        expect(@cards.hand).to eq ONE_PAIR
      end
    end
    context '役がHIGH_CARDの時' do
      before do
        @cards = JudgeHand.new(card: 'S1 D2 S3 S4 S6')
        @cards.judge
      end
      it 'ハイカードを返す' do
        expect(@cards.hand).to eq HIGH_CARD
      end
    end
  end
end