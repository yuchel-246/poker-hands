class Card < ApplicationRecord
      VALID_CARD_HAND =  /\A[A-Z][\d]?[\d]?[ ][A-Z][\d]?[\d]?[ ][A-Z][\d]?[\d]?[ ][A-Z][\d]?[\d]?[ ][A-Z][\d]?[\d]?\z/
      VALID_CARD_HAND_SECOND = /\A[SDHC]([1-9]|1[0-3])[ ][SDHC]([1-9]|1[0-3])[ ][SDHC]([1-9]|1[0-3])[ ][SDHC]([1-9]|1[0-3])[ ][SDHC]([1-9]|1[0-3])\z/
      VALID_CARD_HAND_THIRD = /^(?!.*([SDHC]|[1-9]|1[0-3])).+$/
      validate :card_error
  def card_error
    num = hand.delete("^0-13")
    suit = hand.delete("^A-Z")
    trump = hand.split(/[ ]/)
    trump_duplicate = trump.uniq

    if hand.match(VALID_CARD_HAND) == nil
      errors.add(:hand, "5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）")
    elsif hand.match(VALID_CARD_HAND_SECOND) == nil
      errors.add(:hand, "○が不正です")
    elsif trump_duplicate.length != 5
      errors.add(:hand, "カードが重複しています。")
    end
  end
end
