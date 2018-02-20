class CelebsController < ApplicationController


  def get_birthdays
    get_all = params[:get_all] ? true : false
    info = Celeb.get_birthdays(month: params[:month], date: params[:date], get_all: get_all)
    render json: info
  end


end
