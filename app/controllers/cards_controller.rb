class CardsController < ApplicationController
  def top
    @card = Card.new
  end
  def judgment
    @card = Card.new(card_params)
    #正規表現による分類、配列
    @num = @card.hand.delete("^0-9| ").split(' ')
    @suit = @card.hand.delete("^SDHC| ").split(' ')
    @trump = @card.hand.split(/[\d ]/)
    #変換
    for i in 0..4
      @num[i] = @num[i].to_i
    end
    #役判定
    if @suit.count(@suit[0]) == @suit.length && @num.sort[1] == @num.sort[0] +1 && @num.sort[2] == @num.sort[0] + 2 && @num.sort[3] == @num.sort[0] +3 && @num.sort[4] == @num.sort[0] + 4
      @result = "ストレートフラッシュ"
    elsif @suit.count(@suit[0]) == @suit.length
      @result ="フラッシュ"
    elsif @num.sort[1] == @num.sort[0] +1 && @num.sort[2] == @num.sort[0] + 2 && @num.sort[3] == @num.sort[0] +3 && @num.sort[4] == @num.sort[0] + 4
      @result = "ストレート"
    else
      @result = "ハイカード"
    end
    
    #ダブりのエラー表示のため
    @suit_duplicate = @trump.uniq
    #エラー箇所表示のため用件に合わないものを出力実装中
    @a = @trump.reject{/^(?!.*([SDHC]|[1-9]|1[0-3])).+$/}
    if @card.save
      render action: :result
    else
      render action: :error
    end
  end
  def result
  end
  def error
  end

  private
  def card_params
    params.require(:card).permit(:hand)
  end

end

