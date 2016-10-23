class RoutinesController < ApplicationController
  before_filter :ensure_loggedin!, except: [:publicroutines]

  def routine_params
    params.require(:routine)
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
    routine_details = routine_params
    @routine = Routine.new(routine_details)
    # @routine.user_id = current_user
    @routine.save
    # @routine = Routine.new
  end

  private
  def ensure_loggedin!
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
