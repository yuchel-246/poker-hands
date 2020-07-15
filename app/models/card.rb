# frozen_string_literal: true

class Card < ApplicationRecord
  VALID_CARD_HAND = /\A[A-Z][\d]?[\d]?[ ][A-Z][\d]?[\d]?[ ][A-Z][\d]?[\d]?[ ][A-Z][\d]?[\d]?[ ][A-Z][\d]?[\d]?\z/.freeze
  VALID_CARD_HAND_SECOND = /\A[SDHC]([1-9]|1[0-3])[ ][SDHC]([1-9]|1[0-3])[ ][SDHC]([1-9]|1[0-3])[ ][SDHC]([1-9]|1[0-3])[ ][SDHC]([1-9]|1[0-3])\z/.freeze
  VALID_CARD_HAND_THIRD = /^(?!.*([SDHC]|[1-9]|1[0-3])).+$/.freeze
  validate :card_error

  def card_error
    @trump = hand.split(/[ ]/)
    trump_duplicate = @trump.uniq
    if hand.match(VALID_CARD_HAND).nil?
      errors.add(:hand, '5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）')
    elsif hand.match(VALID_CARD_HAND_SECOND).nil?
      errors.add(:hand, where_error)
    elsif trump_duplicate.length != 5
      errors.add(:hand, 'カードが重複しています。')
    end
  end

  def where_error
    @trump.each.with_index(1) do |item, i|
      if item.match(/[SDHC]([1-9]|1[0-3])/)
        puts ''
      else
        return "#{i}番目のカード指定文字が不正です。（#{item}）\n半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
      end
    end
  end

  # 役判定
  def card_suit
    @num = hand.delete('^0-9| ').split(' ')
    @suit = hand.delete('^SDHC| ').split(' ')
    @trump = hand.split(' ')
    # 変換
    (0..4).each do |i|
      @num[i] = @num[i].to_i
    end
    count_box = []
    (0..@num.uniq.length - 1).each do |i|
      count_box[i] = @num.count(@num.uniq[i])
    end
    if count_box.sort.reverse == [4, 1]
      @result = 'フォー・オブ・ア・カインド'
    elsif  count_box.sort.reverse == [3, 2]
      @result = 'フルハウス'
    elsif  count_box.sort.reverse == [3, 1, 1]
      @result = 'スリー・オブ・ア・カインド'
    elsif  count_box.sort.reverse == [2, 2, 1]
      @result = 'ツーペア'
    elsif  count_box.sort.reverse == [2, 1, 1, 1]
      @result = 'ワンペア'
    elsif count_box.sort.reverse == [1, 1, 1, 1, 1]
      @result = if flash && straight
                  'ストレートフラッシュ'
                elsif flash
                  'フラッシュ'
                elsif straight
                  'ストレート'
                else
                  'ハイカード'
                end
    end
  end

  private

  def straight
    @num.sort[1] == @num.min + 1 && @num.sort[2] == @num.min + 2 && @num.sort[3] == @num.min + 3 && @num.sort[4] == @num.min + 4
  end

  def flash
    @suit.count(@suit[0]) == @suit.length
  end
end
