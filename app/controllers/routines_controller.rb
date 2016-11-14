class RoutinesController < ApplicationController
  before_filter :ensure_loggedin!, except: [:publicroutines]

  def routine_params
    # params.require(:routine).permit(:name, :description, :difficulty, :routine[])
  end

  def publicroutines
    @sharedroutines = Routine.where(:shared => true)
  end

  def myroutines
    # @myroutines = Routine.find(params[:id])
    # console.log(@myroutines)
    # @user = current_user
    @myroutines = current_user.routines.where(:shared => true)
  end

  def currentroutine
    @progress = current_user.current_routine
  end

  def new
    @routine = Routine.new
  end

  def create
    # routine_details = routine_params
    puts 1
    puts params.inspect
    puts 1
    puts routine_params
    puts 1
    # @routine = Routine.new(routine_details)
    # @routine.user_id = current_user
    # @routine.save
  end

  private
  def ensure_loggedin!
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
