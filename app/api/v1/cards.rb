module V1
  class Cards < Grape::API
    require_relative '../../services/judge_hand.rb'
    include CardJudgeModule
    resources :cards do
      post '/' do
        card_sets = params[:cards]
        cards = []
        card_sets.each do |card_set|
          cards << JudgeHand.new(card: card_set)
        end

        scores = []
        cards.each do |card|
          card.judge
          scores << card.strong
        end

        results = []
        errors = []
        cards.each do |card|
          if card.valid?
            best_score = scores.max
            if best_score == card.strong
              results << {"card": card.card,"hand": card.hand, "best":"true"}
            else
              results << {"card": card.card,"hand": card.hand, "best":"false"}
            end
          else 
            errors << {"card": card.card, "msg": card.msg}
          end
        end
        
        if results.present? && errors.present?
          response = {result: results, error: errors}
        elsif results.present?
          response = {result: results}
        else 
          response = {error: errors}
        end
        response
      end
    end
  end
end
