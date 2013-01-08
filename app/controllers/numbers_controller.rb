class NumbersController < ApplicationController
  before_filter :build_number, :only => [:new, :create]

  def index
    @numbers = Number.all
  end

  def new
  end

  def create
    if @number.save
      redirect_to numbers_path
    else
      render :new
    end
  end

  protected
  def build_number
    @number = NumberFactory.build_number(params[:number])
  end
end
