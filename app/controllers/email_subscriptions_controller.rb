require 'blue_state_digital'

class EmailSubscriptionsController < ApplicationController
  skip_before_filter :has_district?

  def new
  end

  def create
    response = submit_to_bsd
    if response.code == "302" && response.body =~ /thanks/
      flash[:info] = "Thanks! We'll keep you up to date."
      redirect_to "/"
    else
      flash[:error] = "Oops! Please be sure to fill out all required fields."
      redirect_to :back
    end
  end

  def adhoc
    response = submit_to_bsd
    respond_to do |format|
      if response.code == "302" && response.body =~ /thanks/
        format.json { render :json => {:success => true, :message => "Thanks for subscribing!"}}
        format.text { render :text => "success"}
        format.html { redirect_to "/thanks"}
      else
        flash[:error] = "Oops, your form submission was invalid."
        format.json { render :json => {:success => false}, :status => 400 }
        format.text { render :text => "error", :status => 400 }
        format.html { redirect_to :back}
      end
    end
  end

  protected

  def submit_to_bsd
    if params[:name].present?
      params[:firstname], params[:lastname] = params[:name].split(' ', 2)
    end
    params[:zip] = params[:zipcode] if params[:zipcode].present?

    result = BlueStateDigital.subscribe_to_email params
    return result[:response]
  end
end
