class NumbersController < ApplicationController
  before_filter :build_number, :only => [:new, :create]

  def index
    @numbers = Number.all
  end

  def new
    @number.phone = Phone.new
  end

  def create
    if @number.save
      redirect_to numbers_path
    else
      render :new
    end
  end

  def edit
    @number = Number.find(params[:id])
  end

  def update
    @number = Number.find(params[:id])
    if @number.update_attributes(params[:number])
      redirect_to numbers_path
    else
      render :edit
    end
  end

  def destroy
    @number = Number.find(params[:id])
    if @number.destroy
      flash[:notice] = "Number deleted successfully"
      redirect_to numbers_path
    else
      raise "Number not destroyed #{@number.inspect}"
    end
  end

  protected
  def build_number
    @number = NumberFactory.build_number(params[:number])
  end
end
