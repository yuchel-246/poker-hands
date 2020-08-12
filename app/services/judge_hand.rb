module CardJudgeModule
  class JudgeHand
    include ActiveModel::Model
    attr_accessor :hand, :trump
    validate :validate
    require './app/services/const/constant'
    include CardConstModule
    
    def validate
      cards = hand.split(/[ ]/)
      if not VALID_FORMAT.match?(hand)
        @errors = VALID_FORMAT_MSG
      elsif not VALID_FORMAT_STRICT.match?(hand)
        @errors = identify
      elsif cards.size != cards.uniq.size
        @errors = VALID_DUPLICATION_MSG
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
        @trump = STRAIGHT_FLASH
      when [true, false, [1, 1, 1, 1, 1]]
        @trump = STRAIGHT
      when [false, true, [1, 1, 1, 1, 1]]
        @trump = FLASH
      when [false, false, [4, 1]]
        @trump = FOUR_OF_A_KIND
      when [false, false, [3, 2]]
        @trump = FULLHOUSE
      when [false, false, [3, 1, 1]]
        @trump = THREE_OF_A_KIND
      when [false, false, [2, 2, 1]]
        @trump = TWO_PAIR
      when [false, false, [2, 1, 1, 1]]
        @trump = ONE_PAIR
      else
        @trump = HIGH_CARD
      end
    end

    private

    def identify
      error_message = ''
      @cards = hand.split(' ')
      @cards.each.with_index(1) do |item, i|
        error_message += "#{i}番目のカード指定文字が不正です。（#{item}）半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。\r\n" if not item.match(/\A[SDHC]([1-9]|1[0-3])\z/)
      end
      error_message # eachでreturnしない場合、nilを返却する
    end

    def straight?
      @nums.sort[1] == @nums.min + 1 && @nums.sort[2] == @nums.min + 2 && @nums.sort[3] == @nums.min + 3 && @nums.sort[4] == @nums.min + 4
    end

    def flash?
      @suits.count(@suits[0]) == @suits.length
    end
  end
end


