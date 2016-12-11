class RoutinesController < ApplicationController
  before_filter :ensure_loggedin!, except: [:publicroutines, :viewroutine]
  # add before_filter for ismine? as opposed to using if statement

  # i should eventually use routine_params once i figure out how to obtain json
  def routine_params
    params.require(:routine).permit(:name, :description, :difficulty)
  end

  def publicroutines
    if user_signed_in?
      @myroutines = current_user.routines
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
    if user_signed_in?
      if !@search[0].shared && ismine?(@specroutine)
        flash[:notice] = "you can't be there"
        return redirect_to root_path
      end
    end
    @specroutine = @search[0]
  end

  def viewupdateroutine
    @routineid = params['id']
    @ismine = ismine?(@routineid)
    @theroutine = Routine.where(:id => @routineid)
    if @theroutine.length == 0 || !@ismine
      flash[:notice] = "you cannot be here"
      redirect_to publicroutines_path
    end
    @theroutine = @theroutine[0]

  end

  # the update needs to be redone (it should use update attributes but instead it does the exact same thing as new)
  def update
    @routine = Routine.find(params['id'].to_i)
    @splitcount = params['routine']['tablecount'].split(",").map(&:to_i)
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
    # @current_user.routines << @routine
    if params['button'] == "Share & Set As Current"
      # puts "if button statement"
      @routine.shared = true
      if @routine.save
        @current_user.current_routine_id = @routine.id
        @current_user.save
        redirect_to specroutine_path(params['id'].to_i)
      end
    elsif params['button'] == "Share Routine"
      @routine.shared = true
      if @routine.save
        redirect_to specroutine_path(params['id'].to_i)
      end
    elsif params['button'] == "Set As Current"
      @routine.shared = false
      if @routine.save
        @current_user.current_routine_id = @routine.id
        @current_user.save
        redirect_to specroutine_path(params['id'].to_i)
      end
    end
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

    @splitcount = params['routine']['tablecount'].split(",").map(&:to_i)
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
    @current_user.routines << @routine
    if params['button'] == "Share & Set As Current"
      # puts "if button statement"
      @routine.shared = true
      if @routine.save
        @current_user.current_routine_id = @routine.id
        @current_user.save
        redirect_to action: 'currentroutine'
      end
    elsif params['button'] == "Share Routine"
      @routine.shared = true
      if @routine.save
        redirect_to action: 'publicroutines'
      end
    elsif params['button'] == "Set As Current"
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
    # current_user.current_routine_id = params['routine_id']

    # this is redesigned way 
    # puts params
    copyroutine = Routine.find(params['routine_id'])
    puts copyroutine.inspect
    #<Routine id: 1, name: "stronglift 5x5 v2", description: "one of the more popular beginner programs", 
    # routine: {"list"=>[[["bench press", "5", "5"], ["bent over rows", "3", "10"], ["chest press", "3", "5"]], [["over head press", "5", "5"], ["deadlift", "3", "5"], ["lat pulldown", "3", "8"], ["bench press", "3", "10"]]], "split"=>2}, 
    # created_at: "2016-11-18 02:36:33", updated_at: "2016-12-02 05:26:31", difficulty: "novice", user_id: 1, shared: true>
    if ismine?(params['routine_id'])
      current_user.current_routine_id = copyroutine
      if current_user.save
        redirect_to progress_path
      end
    else
      setcur = Routine.new()
      setcur.name = copyroutine.name
      setcur.description = copyroutine.description
      setcur.routine = copyroutine.routine
      setcur.difficulty = copyroutine.difficulty
      setcur.shared = false
      if setcur.save
        @current_user.routines << setcur
        @current_user.current_routine_id = setcur.id
        @current_user.save
        redirect_to progress_path
      end
    end
    
    # this is end of redesigned way

    # if current_user.save
    #   redirect_to progress_path
    # end
  end

  def deleteroutine
    chosenroutine = params['routine_id']
    if ismine?(chosenroutine)
      if Routine.find(chosenroutine).destroy
        redirect_to publicroutines_path
      end
    else
      # not yet decided what to do if user somehow tries to delete a routine that isnt theirs
      redirect_to publicroutines_path
    end
  end

  def ismine?(routineid)
    return current_user.routines.where(:id => routineid).length == 1
  end
  private
  def ensure_loggedin!
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
