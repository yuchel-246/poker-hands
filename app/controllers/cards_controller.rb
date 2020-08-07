# frozen_string_literal: true

class CardsController < ApplicationController

  def top
    @card = JudgeHand.new
  end

  def judgment
    @card = JudgeHand.new(card_params)
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
  end

  def error
  end

  private

  def card_params
    params.require(:judge_hand).permit(:hand)
  end
end
