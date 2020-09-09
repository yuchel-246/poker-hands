module ErrorValidFormatModule

  VALID_FORMAT = /\A.[\d]?[\d]?[ ].[\d]?[\d]?[ ].[\d]?[\d]?[ ].[\d]?[\d]?[ ].[\d]?[\d]?\z/.freeze
  VALID_FORMAT_STRICT = /\A[SDHC]([1-9]|1[0-3])[ ][SDHC]([1-9]|1[0-3])[ ][SDHC]([1-9]|1[0-3])[ ][SDHC]([1-9]|1[0-3])[ ][SDHC]([1-9]|1[0-3])\z/.freeze
  
end