class CreateLoanDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :loan_details do |t|
      t.integer :current_balance
      t.integer :original_amount
      t.integer :interest_rate
      t.integer :periods_in_year
      t.string :interest_per_month
      t.integer :monthly_min_payment

      t.timestamps
    end
  end
end
