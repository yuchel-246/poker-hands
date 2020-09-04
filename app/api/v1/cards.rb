module V1
  class Cards < Grape::API
    require_relative '../../services/judge_hand.rb'
    include CardJudgeModule
    resources :cards do
      post '/' do
        card_sets = params[:cards]
        card_set = []
        card_sets.each do |cards|
          card_set << JudgeHand.new(card: cards)
        end

        scores = []
        errors = []

        card_set.each do |card|
          unless card.valid?
            errors << {"card": card.card, "msg": card.msg}
          else
            card.judge
            scores << card.strong
          end
        end

        results = []
        best_score = scores.max
        card_set.each do |card|
          if card.hand == nil
            results
          elsif best_score == card.strong
            results << {"card": card.card, "hand": card.hand, "best": "true"}
          else
            results << {"card": card.card, "hand": card.hand, "best": "false"}
          end
        end
        
        response = {}
        response["result"] = results if results.present?
        response["error"] = errors if errors.present?
        response
      end
    end
  end
end
