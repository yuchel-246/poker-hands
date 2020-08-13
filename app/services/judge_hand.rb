module CardJudgeModule
  class JudgeHand
    include ActiveModel::Model
    attr_accessor :card_set, :hand, :error
    require './app/services/const/error_message'
    require './app/services/const/error_valid_format'
    require './app/services/const/hands_name'
    include HandsNameModule
    include ErrorMessageModule
    include ErrorValidFormatModule
    
    def valid?
      cards = card_set.split(/[ ]/)
      if not VALID_FORMAT.match?(card_set)
        @error = VALID_FORMAT_MSG
        return false
      elsif not VALID_FORMAT_STRICT.match?(card_set)
        @error = identify
        return false
      elsif cards.size != cards.uniq.size
        @error = VALID_DUPLICATION_MSG
        return false
      else
        return true
      end
    end

    # 役判定
    def judge
      @nums = card_set.delete('^0-9| ').split(' ').map{|n|n.to_i}
      @suits = card_set.delete('^SDHC| ').split(' ')
      cards = card_set.split(' ')
      # 変換
      count_box = []
      (0..@nums.uniq.length - 1).each do |i|
        count_box[i] = @nums.count(@nums.uniq[i])
      end
      
      case [straight?, flash?, count_box.sort.reverse]
      when [true, true, [1, 1, 1, 1, 1]]
        @hand = STRAIGHT_FLASH
      when [true, false, [1, 1, 1, 1, 1]]
        @hand = STRAIGHT
      when [false, true, [1, 1, 1, 1, 1]]
        @hand = FLASH
      when [false, false, [4, 1]]
        @hand = FOUR_OF_A_KIND
      when [false, false, [3, 2]]
        @hand = FULLHOUSE
      when [false, false, [3, 1, 1]]
        @hand = THREE_OF_A_KIND
      when [false, false, [2, 2, 1]]
        @hand = TWO_PAIR
      when [false, false, [2, 1, 1, 1]]
        @hand = ONE_PAIR
      else
        @hand = HIGH_CARD
      end
    end

    def identify
      error_message = ''
      cards = card_set.split(' ')
      cards.each.with_index(1) do |item, i|
        error_message += "#{i}番目のカード指定文字が不正です。（#{item}）半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。\r\n" if not item.match(/\A[SDHC]([1-9]|1[0-3])\z/)
      end
      error_message # eachでreturnしない場合、nilを返却する
    end

    private
    def straight?
      @nums.sort[1] == @nums.min + 1 && @nums.sort[2] == @nums.min + 2 && @nums.sort[3] == @nums.min + 3 && @nums.sort[4] == @nums.min + 4
    end

    def flash?
      @suits.count(@suits[0]) == @suits.length
    end
  end
end


