# == Schema Information
#
# Table name: loan_details
#
#  id                  :integer          not null, primary key
#  current_balance     :integer
#  original_amount     :integer
#  interest_rate       :integer
#  periods_in_year     :integer
#  interest_per_month  :string
#  monthly_min_payment :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class LoanDetail < ApplicationRecord
end
