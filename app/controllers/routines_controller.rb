class RoutinesController < ApplicationController
  before_filter :ensure_loggedin!, except: [:publicroutines]

  def routine_params
    params.require(:routine).permit(:name, :description, :difficulty)
  end

  def publicroutines
    if user_signed_in?
      @myroutines = current_user.routines.where(:shared => true)
    end
    @sharedroutines = Routine.where(:shared => true)
  end

  def currentroutine
    @progress = current_user.current_routine
  end

  def new
    @routine = Routine.new
  end

  def viewroutine
    @specroutine = params['id']
    @specroutine = Routine.find(@specroutine)
  end

  def create
    # we won't use routine_params
    # routine_details = routine_params

    # example routine for reference
    # user.routines.create(name:'not current routine 6',description:'test text',shared:true, routine:{'split':2, 'list':[[['bench', 5,5],['rows', 3,8]],[['ohp',5,5],['deadlift',1,5]]]},difficulty:'novice')

    # example post params for reference
    # Parameters: {"utf8"=>"✓", "routine"=>{"name"=>"", "description"=>"", "tablecount"=>"3,2"}, "exercisename"=>["1", "2", "3", "1", "2"], "sets"=>["1", "2", "3", "1", "2"], "reps"=>["1", "2", "3", "1", "2"], "commit"=>"Create"}

    # puts 1
    # puts params
    @splitcount = params['routine']['tablecount'].split(",").map(&:to_i)
    # puts a[0]
    # puts 1
    @routine = Routine.new()
    @routine.name = params['routine']['name']
    @routine.description = params['routine']['description']
    @routine.difficulty = params['routine']['difficulty']

    @exerciselist = {}
    @exerciselist['split'] = @splitcount.length

    sum = 0
    alldays = []
    @splitcount.each do |rows|
      oneday = []
      rows.times do |i|
        oneexercise = [params['exercisename'][i+sum], params['sets'][i+sum], params['reps'][i+sum]]
        oneday << oneexercise
      end
      alldays << oneday
      sum = sum + rows
    end
    @exerciselist['list'] = alldays
    @routine['routine'] = @exerciselist
    @current_user.routines << @routine


    # "Set As Current"
    # "Share Routine"
    # "Share & Set As Current"
    # dont forget to add warning if choosing to replace currentroutine
    if params['button'] == "Share & Set As Current"
      @routine.shared = true
      user = User.find(current_user.id)
      user.current_routine = @routine
      user.save
      # @routine.save
      # redirect_to action: 'currentroutine'
      # if @routine.save
      #   user = User.find(current_user.id)
      #   user.current_routine = @routine
      #   user.save
      #   redirect_to action: 'currentroutine'
      # end
    elsif params['button'] == "Share Routine"
      @routine.shared = true
      if @routine.save
        redirect_to action: 'publicroutines'
      end
    elsif params['button'] == "Set As Current"
      @routine.shared = false
      user = User.find(current_user.id)
      user.current_routine = @routine
      if @routine.save
        user.save
        redirect_to action: 'currentroutine'
      end
    end
    # dont forget to delete currentroutine if it isnt shared and user chooses to set current
  end

  private
  def ensure_loggedin!
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
