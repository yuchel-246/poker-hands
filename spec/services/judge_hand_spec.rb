require 'rails_helper'
require './app/services/judge_hand'
include CardJudgeModule
include CardConstModule


describe JudgeHand do
  describe 'バリデーションテスト' do
    context 'A-Zと1-13のカード5枚ある時' do
      it '有効である' do
        hand = JudgeHand.new(hand: 'S1 S2 S3 S4 S5')
        expect(hand).to be_valid
      end
    end
    context 'A-Zと1-13のカード6枚ある時' do
      it '無効である' do
        hand = JudgeHand.new(hand: 'S1 S2 S3 S4 S5 S6')
        expect(hand).not_to be_valid
      end
    end
    context 'A-Zと1-13のカード4枚ある時' do
      it '無効である' do
        hand = JudgeHand.new(hand: 'S1 S2 S3 S4')
        expect(hand).not_to be_valid
      end
    end
    context 'A-Zと1-13のカード5枚だが同じカードがある時' do
      it '無効である' do
        hand = JudgeHand.new(hand: 'S1 S2 S3 S4 S4')
        expect(hand).not_to be_valid
      end
    end
    context '存在しないスートが含まれている時' do
      it '無効である' do
        hand = JudgeHand.new(hand: 'A1 S2 S3 S4 S5')
        expect(hand).not_to be_valid
      end
    end
    context '存在しない数字が存在する時' do
      it '無効である' do
        hand = JudgeHand.new(hand: 'S14 S2 S3 S4 S5')
        expect(hand).not_to be_valid
      end
    end
    context 'カードの形式が異なる時' do
      it '無効である' do
        hand = JudgeHand.new(hand: 'S S2 S3 S4 S5')
        expect(hand).not_to be_valid
      end
    end
    context 'カードが半角スペースで区切られていない時' do
      it '無効である' do
        hand = JudgeHand.new(hand: 'S1/S2/S3/S4/S5')
        expect(hand).not_to be_valid
      end
    end
  end

  describe '役判定テスト' do
    context '役がSTRAIGHT_FLASHの時' do
      it 'ストレートフラッシュを返す' do
        cards = JudgeHand.new(hand: 'S1 S2 S3 S4 S5')
        cards.judge
        expect(cards.trump).to eq STRAIGHT_FLASH
      end
    end
    context '役がSTRAIGHTの時' do
      it 'ストレートを返す' do
        cards = JudgeHand.new(hand: 'D1 S2 S3 S4 S5')
        cards.judge
        expect(cards.trump).to eq STRAIGHT
      end
    end
    context '役がFLASHの時' do
      it 'フラッシュを返す' do
        cards = JudgeHand.new(hand: 'S1 S2 S3 S4 S6')
        cards.judge
        expect(cards.trump).to eq FLASH
      end
    end
    context '役がFOUR_OF_A_KINDの時' do
      it 'フォー・オブ・ア・カインドを返す' do
        cards = JudgeHand.new(hand: 'S1 D1 H1 C1 S5')
        cards.judge
        expect(cards.trump).to eq FOUR_OF_A_KIND
      end
    end
    context '役がFULLHOUSEの時' do
      it 'フルハウスを返す' do
        cards = JudgeHand.new(hand: 'S1 D1 H1 S2 D2')
        cards.judge
        expect(cards.trump).to eq FULLHOUSE
      end
    end
    context '役がTHREE_OF_A_KINDの時' do
      it 'スリー・オブ・ア・カインドを返す' do
        cards = JudgeHand.new(hand: 'S1 D1 H1 S2 S3')
        cards.judge
        expect(cards.trump).to eq THREE_OF_A_KIND
      end
    end
    context '役がTWO_PAIRの時' do
      it 'ツーペアを返す' do
        cards = JudgeHand.new(hand: 'S1 D1 S2 D2 S3')
        cards.judge
        expect(cards.trump).to eq TWO_PAIR
      end
    end
    context '役がONE_PAIRの時' do
      it 'ワンペアを返す' do
        cards = JudgeHand.new(hand: 'S1 D1 S3 S4 S5')
        cards.judge
        expect(cards.trump).to eq ONE_PAIR
      end
    end
    context '役がHIGH_CARDの時' do
      it 'ハイカードを返す' do
        cards = JudgeHand.new(hand: 'S1 D2 S3 S4 S6')
        cards.judge
        expect(cards.trump).to eq HIGH_CARD
      end
    end
  end
end