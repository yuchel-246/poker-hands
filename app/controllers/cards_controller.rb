# frozen_string_literal: true

class CardsController < ApplicationController
  require './app/services/judge_hand'
  require './app/services/const/error_valid_format'
  include CardJudgeModule
  include ErrorValidFormatModule
  
  def top
    @card = JudgeHand.new
  end

  def judgment
    @card = JudgeHand.new(card_params)
    if @card.validate?
      # バリデーションエラーの場合
      render action: :error
    else
      @card.judge
      # バリデーションエラーではない場合
      # → 役判定処理を実施
      render action: :result
    end
  end

  def result
  end

  def error
  end

  private

  def card_params
    params.require(:card_judge_module_judge_hand).permit(:card_set, :error)
  end
end
