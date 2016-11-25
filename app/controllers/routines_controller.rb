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
    # find a way to make associations work
    @current_routine = current_user.current_routine_id
    if @current_routine
      @progress = Routine.find(@current_routine)
    end
  end

  def new
    @routine = Routine.new
  end

  def viewroutine
    @specroutine = params['id']
    # first check if exists
    # then check if shared and current user 
    # then proceed

    @search = Routine.where(:id => @specroutine)
    if @search.length == 0
      flash[:notice] = "that does not exist"
      return redirect_to publicroutines_path
    end
    # elsif
    # @exists = current_user.routines.where(:id => @specroutine)
    if !@search[0].shared
      flash[:notice] = "you can't be there"
      return redirect_to root_path
    end
    @specroutine = @search[0]
  end

  def create
    # we won't use routine_params
    # routine_details = routine_params

    # example routine for reference
    # user.routines.create(name:'not current routine 6',description:'test text',shared:true, routine:{'split':2, 'list':[[['bench', 5,5],['rows', 3,8]],[['ohp',5,5],['deadlift',1,5]]]},difficulty:'novice')

    # example of what im doin
    # #<Routine id: 77, name: "10:18", description: "asd", routine: {"split"=>0, "list"=>[]}, created_at: "2016-11-19 13:18:33", updated_at: "2016-11-19 13:18:33", difficulty: "intermediate", user_id: 1, shared: true>

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
    @routine.routine = @exerciselist

    if params['button'] == "Share & Set As Current"
      # puts "if button statement"
      @routine.shared = true
      if @routine.save
        # puts "if save statement"
        @current_user.routines << @routine
        @current_user.current_routine_id = @routine.id
        @current_user.save
        redirect_to action: 'currentroutine'
      end
    elsif params['button'] == "Share Routine"
      # puts 2
      @current_user.routines << @routine
      @routine.shared = true
      if @routine.save
        redirect_to action: 'publicroutines'
      end
    elsif params['button'] == "Set As Current"
      # puts 3
      @routine.shared = false
      if @routine.save
        @current_user.current_routine_id = @routine.id
        @current_user.save
        redirect_to action: 'currentroutine'
      end
    end
    # dont forget to delete currentroutine if it isnt shared and user chooses to set current
  end

  # move this to users controller later
  def setcurrent
    current_user.current_routine_id = params['routine_id']
    if current_user.save
      redirect_to progress_path
    end
    # flash[:notice] = "current routine saved"

    # current_user.current_routine_id = 
    # current_user.save
  end

  private
  def ensure_loggedin!
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
