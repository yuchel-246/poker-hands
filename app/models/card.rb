# frozen_string_literal: true

class Card < ApplicationRecord
  VALID_FORMAT = /\A[A-Z][\d]?[\d]?[ ][A-Z][\d]?[\d]?[ ][A-Z][\d]?[\d]?[ ][A-Z][\d]?[\d]?[ ][A-Z][\d]?[\d]?\z/.freeze
  VALID_FORMAT_STRICT = /\A[SDHC]([1-9]|1[0-3])[ ][SDHC]([1-9]|1[0-3])[ ][SDHC]([1-9]|1[0-3])[ ][SDHC]([1-9]|1[0-3])[ ][SDHC]([1-9]|1[0-3])\z/.freeze
  validate :validate

  def validate
    cards = hand.split(/[ ]/)
    if hand.match(VALID_FORMAT).nil?
      errors.add(:hand, '5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）')
    elsif hand.match(VALID_FORMAT_STRICT).nil?
      errors.add(:hand, identify)
    elsif cards.size != cards.uniq.size
      errors.add(:hand, 'カードが重複しています。')
    end
  end

  # 役判定
  def judge
    @nums = hand.delete('^0-9| ').split(' ').map{|n|n.to_i}
    @suits = hand.delete('^SDHC| ').split(' ')
    @cards = hand.split(' ')
    # 変換
    count_box = []
    (0..@nums.uniq.length - 1).each do |i|
      count_box[i] = @nums.count(@nums.uniq[i])
    end
    
    case [straight?, flash?, count_box.sort.reverse]
    when [true, true, [1, 1, 1, 1, 1]]
      @result = 'ストレートフラッシュ'
    when [true, false, [1, 1, 1, 1, 1]]
      @result = 'ストレート'
    when [false, true, [1, 1, 1, 1, 1]]
      @result = 'フラッシュ'
    when [false, false, [4, 1]]
      @result = 'フォー・オブ・ア・カインド'
    when [false, false, [3, 2]]
      @result = 'フルハウス'
    when [false, false, [3, 1, 1]]
      @result = 'スリー・オブ・ア・カインド'
    when [false, false, [2, 2, 1]]
      @result = 'ツーペア'
    when [false, false, [2, 1, 1, 1]]
      @result = 'ワンペア'
    else
      @result = 'ハイカード'
    end
  end

  private

  def identify
    @cards = hand.split(' ')
    @cards.each.with_index(1) do |item, i|
      if item.match(/[SDHC]([1-9]|1[0-3])/)
        puts ''
      else
        return "#{i}番目のカード指定文字が不正です。（#{item}）\n半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
      end
    end
  end

  def straight?
    @nums.sort[1] == @nums.min + 1 && @nums.sort[2] == @nums.min + 2 && @nums.sort[3] == @nums.min + 3 && @nums.sort[4] == @nums.min + 4
  end

  def flash?
    @suits.count(@suits[0]) == @suits.length
  end
end
