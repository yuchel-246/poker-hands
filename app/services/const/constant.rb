
module CardConstModule
  VALID_FORMAT = /\A.[\d]?[\d]?[ ].[\d]?[\d]?[ ].[\d]?[\d]?[ ].[\d]?[\d]?[ ].[\d]?[\d]?\z/.freeze
  VALID_FORMAT_STRICT = /\A[SDHC]([1-9]|1[0-3])[ ][SDHC]([1-9]|1[0-3])[ ][SDHC]([1-9]|1[0-3])[ ][SDHC]([1-9]|1[0-3])[ ][SDHC]([1-9]|1[0-3])\z/.freeze

  STRAIGHT_FLASH = 'ストレートフラッシュ'
  STRAIGHT = 'ストレート'
  FLASH = 'フラッシュ'
  FOUR_OF_A_KIND = 'フォー・オブ・ア・カインド'
  FULLHOUSE = 'フルハウス'
  THREE_OF_A_KIND = 'スリー・オブ・ア・カインド'
  TWO_PAIR = 'ツーペア'
  ONE_PAIR = 'ワンペア'
  HIGH_CARD = 'ハイカード'

  VALID_FORMAT_MSG = "5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"
  VALID_DUPLICATION_MSG = "カードが重複しています。"
end