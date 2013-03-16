class NumbersController < ApplicationController
  before_filter :build_number, :only => [:new, :create]

  def index
    @numbers = Number.all
  end

  def new
    @number.phone = Phone.new
  end
  
  def show
    @number = Number.find(params[:id])
  end

  def create
    if @number.save
      flash[:notice] = "Number Successfully Created, Please Allow up to 10 minutes for number to provision"
      redirect_to number_path(@number)
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
      flash[:notice] = "Number Successfully Updated"
      redirect_to numbers_path
    else
      render :edit
    end
  end

  def destroy
    @number = Number.find(params[:id])
    if @number.destroy
      flash[:notice] = "Number Successfully Deleted"
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
