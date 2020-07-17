# frozen_string_literal: true

class CardsController < ApplicationController
  def top
    @card = Card.new
  end

  def judgment
    @card = Card.new(card_params)
    if @card.valid?
      # バリデーションエラーではない場合
      # → 役判定処理を実施
      render action: :result
    else
      # バリデーションエラーの場合
      render action: :error
    end
  end

  def result
    @a = @cards
  end

  def error
    
  end

  private

  def card_params
    params.require(:card).permit(:hand)
  end
end
