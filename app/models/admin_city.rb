class AdminCity < ApplicationRecord
  belongs_to :admin
  belongs_to :city
end
