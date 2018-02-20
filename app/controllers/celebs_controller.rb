class CelebsController < ApplicationController


  def get_birthdays
    puts params
    info = Celeb.get_birthdays(month: params[:month], date: params[:date])
    render json: info
  end


end
