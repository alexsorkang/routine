class RoutinesController < ApplicationController
  before_filter :ensure_loggedin!, only: [:newroutine, :currentroutine, :myroutines]

  def publicroutines
  end

  def myroutines
    # @myroutines = Routine.find(params[:id])
    # console.log(@myroutines)
    # @user = current_user
  end

  def currentroutine
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
