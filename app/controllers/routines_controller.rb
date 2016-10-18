class RoutinesController < ApplicationController
  before_filter :ensure_loggedin!, only: [:newroutine, :currentroutine, :myroutines]

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

  def newroutine
  end

  private
  def ensure_loggedin!
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
