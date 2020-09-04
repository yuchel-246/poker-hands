# frozen_string_literal: true

class CardsController < ApplicationController
  require './app/services/judge_hand'
  include CardJudgeModule
  
  def top
    @card = JudgeHand.new
  end

  def judgment
    @card = JudgeHand.new(card_params)
    unless @card.valid?
      render action: :error
    else
      @card.judge
      render action: :result
    end
    
  end

  def result
  end

  def error
  end

  private

  def card_params
    params.require(:card_judge_module_judge_hand).permit(:card)
  end
end
