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
    
    # set as true for now
    @routine.shared = true

    @exerciselist = {}
    @exerciselist['split'] = @splitcount.length
    @routine['routine']['split'] = @exerciselist
    puts @routine
    # @exerciselist[]

  end

  private
  def ensure_loggedin!
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
