class Pattern < ApplicationRecord
  belongs_to :sample, optional: true
end
