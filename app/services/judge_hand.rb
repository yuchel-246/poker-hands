module CardJudgeModule
  class JudgeHand
    include ActiveModel::Model
    attr_accessor :card, :hand, :msg, :strong, :best
    require './app/services/const/error_message'
    require './app/services/const/error_valid_format'
    require './app/services/const/hands_name'
    include HandsNameModule
    include ErrorMessageModule
    include ErrorValidFormatModule
    
    def valid?
      cards = card.split(/[ ]/)
      if not VALID_FORMAT.match?(card)
        @msg = VALID_FORMAT_MSG
        return false
      elsif not VALID_FORMAT_STRICT.match?(card)
        @msg = identify
        return false
      elsif cards.size != cards.uniq.size
        @msg = VALID_DUPLICATION_MSG
        return false
      else
        return true
      end
    end

    # 役判定
    def judge
      nums = card.delete('^0-9| ').split(' ').map{|n|n.to_i}
      suits = card.delete('^SDHC| ').split(' ')
      cards = card.split(' ')
      # 変換
      count_box = []
      (0..nums.uniq.length - 1).each do |i|
        count_box[i] = nums.count(nums.uniq[i])
      end
      
      case [straight?(nums), flash?(suits), count_box.sort.reverse]
      when [true, true, [1, 1, 1, 1, 1]]
        @hand = STRAIGHT_FLASH
        @strong = 8
      when [false, false, [4, 1]]
        @hand = FOUR_OF_A_KIND
        @strong = 7
      when [false, false, [3, 2]]
        @hand = FULLHOUSE
        @strong = 6
      when [false, true, [1, 1, 1, 1, 1]]
        @hand = FLASH
        @strong = 5
      when [true, false, [1, 1, 1, 1, 1]]
        @hand = STRAIGHT
        @strong = 4
      when [false, false, [3, 1, 1]]
        @hand = THREE_OF_A_KIND
        @strong = 3
      when [false, false, [2, 2, 1]]
        @hand = TWO_PAIR
        @strong = 2
      when [false, false, [2, 1, 1, 1]]
        @hand = ONE_PAIR
        @strong = 1
      else
        @hand = HIGH_CARD
        @strong = 0
      end
    end

    def best_judge(card)
      scores = []
      scores << @strong

      high_score = scores.min
      if card.strong = high_score
        @best = "true"
      else
        @best = "false"
      end
    end
    

    def identify
      error_message = ''
      cards = card.split(' ')
      cards.each.with_index(1) do |item, i|
        error_message += "#{i}番目のカード指定文字が不正です。（#{item}）半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。" if not item.match(/\A[SDHC]([1-9]|1[0-3])\z/)
      end
      error_message # eachでreturnしない場合、nilを返却する
    end

    def straight?(nums)
      nums.sort[1] == nums.min + 1 && nums.sort[2] == nums.min + 2 && nums.sort[3] == nums.min + 3 && nums.sort[4] == nums.min + 4
    end

    def flash?(suits)
      suits.count(suits[0]) == suits.length
    end
  end
end


