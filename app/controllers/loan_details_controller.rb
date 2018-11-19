class LoanDetailsController < ApplicationController
  def index
    @loan_details = LoanDetail.all

    render("loan_detail_templates/index.html.erb")
  end

  def show
    @loan_detail = LoanDetail.find(params.fetch("id_to_display"))
    
    i=0;
    j=0;
    end_balance = @loan_detail.current_balance;
    end_balance_adj = @loan_detail.current_balance;
    pmt_amt = @loan_detail.monthly_min_payment;
    interest_rate =  @loan_detail.interest_rate.to_f / 100;
    periods = @loan_detail.periods_in_year;
    mo_int = interest_rate/periods;
    cum_int = 0;
    cum_int_adj = 0;
    
    @pmt_schedule = [];
    @pmt_schedule_adj = [];
    
    # Loan without any additional payments
    while end_balance > 0
      beg_balance = end_balance;
      pmt_no = i+1;
      interest = beg_balance*mo_int;
      
      # Checks if the scheduled payment exceeds the ammount that is still owed on the loan
      # Adjusts payment down to the beginng balance + interest accrued if it us
       
      if beg_balance + interest < pmt_amt
        pmt_amt = beg_balance + interest;
      end
      
      principal = pmt_amt - interest;
      end_balance = beg_balance - principal;
      cum_int += interest;
      
      
      @pmt_schedule[i] = [pmt_no , beg_balance, pmt_amt , principal , interest , end_balance, cum_int];
      i += 1;
    end
    
    # Loan with additional payments
    pmt_amt = @loan_detail.monthly_min_payment;
    pmt_adj_table = [
      ["One Time" , 250 , 15],
      ["Recurring" , 50 , 5],
      ["Recurring" , 50 , 25]
      ];
    
    while end_balance_adj > 0
      beg_balance_adj = end_balance_adj
      pmt_amt = @loan_detail.monthly_min_payment;
      pmt_no = j+1;
      interest = beg_balance_adj*mo_int;
      
      pmt_amt_adj = pmt_amt;
      
      # Checks to see if there are any payment adjustments happpening
      # during this loan period and adjusting payment accordingly
      pmt_adj_table.each do |occurence , amount , time|
        if occurence == "One Time" && time == pmt_no
          pmt_amt_adj += amount
        elsif occurence == "Recurring" && time <= pmt_no
          pmt_amt_adj += amount
        else
          pmt_amt_adj = pmt_amt_adj;
        end
      end
      
      # Checks if the scheduled payment exceeds the ammount that is still owed on the loan
      # Adjusts payment down to the beginng balance + interest accrued if it us
       
      if beg_balance_adj + interest < pmt_amt_adj
        pmt_amt_adj = beg_balance_adj + interest
      end
      
      principal = pmt_amt_adj - interest;
      end_balance_adj = beg_balance_adj - principal;
      cum_int_adj += interest;
      
      
      @pmt_schedule_adj[j] = [pmt_no , beg_balance_adj, pmt_amt_adj , principal , interest , end_balance_adj, cum_int_adj];
      j += 1;
    end    
    
    render("loan_detail_templates/show.html.erb")
  end

  def new_form
    @loan_detail = LoanDetail.new

    render("loan_detail_templates/new_form.html.erb")
  end

  def create_row
    @loan_detail = LoanDetail.new

    @loan_detail.current_balance = params.fetch("current_balance")
    @loan_detail.original_amount = params.fetch("original_amount")
    @loan_detail.interest_rate = params.fetch("interest_rate")
    @loan_detail.periods_in_year = params.fetch("periods_in_year")
    @loan_detail.interest_per_month = params.fetch("interest_per_month")
    @loan_detail.monthly_min_payment = params.fetch("monthly_min_payment")

    if @loan_detail.valid?
      @loan_detail.save

      redirect_back(:fallback_location => "/loan_details", :notice => "Loan detail created successfully.")
    else
      render("loan_detail_templates/new_form_with_errors.html.erb")
    end
  end

  def edit_form
    @loan_detail = LoanDetail.find(params.fetch("prefill_with_id"))

    render("loan_detail_templates/edit_form.html.erb")
  end

  def update_row
    @loan_detail = LoanDetail.find(params.fetch("id_to_modify"))

    @loan_detail.current_balance = params.fetch("current_balance")
    @loan_detail.original_amount = params.fetch("original_amount")
    @loan_detail.interest_rate = params.fetch("interest_rate")
    @loan_detail.periods_in_year = params.fetch("periods_in_year")
    @loan_detail.interest_per_month = params.fetch("interest_per_month")
    @loan_detail.monthly_min_payment = params.fetch("monthly_min_payment")

    if @loan_detail.valid?
      @loan_detail.save

      redirect_to("/loan_details/#{@loan_detail.id}", :notice => "Loan detail updated successfully.")
    else
      render("loan_detail_templates/edit_form_with_errors.html.erb")
    end
  end

  def destroy_row
    @loan_detail = LoanDetail.find(params.fetch("id_to_remove"))

    @loan_detail.destroy

    redirect_to("/loan_details", :notice => "Loan detail deleted successfully.")
  end
end
