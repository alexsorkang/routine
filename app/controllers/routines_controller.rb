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
    # user.routines << @routine
    # @current_user.routines << @routine
    # "Set As Current"
    # "Share Routine"
    # "Share & Set As Current"
    # dont forget to add warning if choosing to replace currentroutine

    # @user = User.find(current_user.id)
    # puts 'this is user'
    # puts @user.inspect
    # puts 'end of user'
    # puts user
    if params['button'] == "Share & Set As Current"
      puts "if button statement"
      @routine.shared = true
      # puts 2
      # puts @routine.inspect
      # puts 2
      # User.update(current_user.id, :current_routine => @routine)
      # @user.current_routine = @routine
      # puts @routine.inspect
      # puts 1
      # puts @user.current_routine.inspect
      # puts 1
      # if @user.save!
      #   puts 'saved here'
      #   puts current_user.current_routine.inspect
      #   puts 1
      # end
      # puts 3
      # user.save
      # @routine.save
      # redirect_to action: 'currentroutine'
      if @routine.save
        puts "if save statement"
        @current_user.routines << @routine
        @user = User.find(current_user.id)
        @user.current_routine = @routine
        @user.save
        # puts @routine.id
        # puts 2
        # @user = current_user
        # @user.current_routine = @routine
        # @user.save
        # puts @routine.inspect
        # puts 2
        # User.update(current_user.id, :current_routine => @routine)
        # puts 3
        # puts current_user.current_routine.inspect
        # puts 3
        redirect_to action: 'currentroutine'
      end
    elsif params['button'] == "Share Routine"
      # puts 2
      @routine.shared = true
      if @routine.save
        redirect_to action: 'publicroutines'
      end
    elsif params['button'] == "Set As Current"
      # puts 3
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
