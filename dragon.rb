class Dragon

  attr_reader :name, :group, :gender, :asleep, :stuffInBelly, :stuffInIntestine

  def initialize(name = @name, group = @group, gender = @gender)
    @name = name
    @group = group
    @gender = gender
    @asleep = 10
    @stuffInBelly = 10  # He's full.
    @stuffInIntestine =  0  # He doesn't need to go.

    puts @name + ' is born.'

    Thread.new do
      while @stuffInBelly >= 0 do
        time_passing
        sleep 1
      end
    end
  end

  def info
    puts "#{@name}'s  details: "
    puts "Group: #{@group}"
    puts "Gender: #{@gender}"
    sleepy_decider
  end

  def feed
    puts 'You feed ' + @name + '.'
    @stuffInBelly = 100
  end

  def walk
    puts 'You walk ' + @name + '.'
    @stuffInIntestine = 0
  end

  def putToBed
    if sleepy_decider == false
      passageOfTime
      puts "He is not sleepy"
      return false
    else
      puts 'You put ' + @name + ' to bed.'
      3.times do
          sleep 1
          puts 'Hrrrrrrrrrrr'
      end
      puts 'Almast UP'
      sleep 1
      puts 'Agrrrrrrrr I am so Fresh!!!'
    end
  end

  def toss
    puts 'You toss ' + @name + ' up into the air.'
    puts 'He giggles, which singes your eyebrows.'
  end

  def rock

  end



  private

  def sleepy_decider
    if @asleep < 15
      puts "#{@name} is so sleepy, has to rest"
    elsif @asleep >=15 && @asleep < 80
      puts "#{@name} is fine"
    else
      puts "#{@name} is really fresh, he won't sleep..."
      false
    end
    true
  end


  def hungry?
    @stuffInBelly <= 20
  end

  def poopy?
    @stuffInIntestine >= 10
  end

  def time_passing
    @stuffInBelly = @stuffInBelly - 1
  end


=begin

  def passageOfTime
    if @stuffInBelly > 0
      # Move food from belly to intestine.
      @stuffInBelly     = @stuffInBelly     - 1
      @stuffInIntestine = @stuffInIntestine + 1
    else  # Our dragon is starving!
      if @asleep
        @asleep = false
        puts 'He wakes up suddenly!'
      end
      puts @name + ' is starving!  In desperation, he ate YOU!'
      exit  # This quits the program.
    end

    if @stuffInIntestine >= 10
      @stuffInIntestine = 0
      puts 'Whoops!  ' + @name + ' had an accident...'
    end

    if hungry?
      if @asleep
        @asleep = false
        puts 'He wakes up suddenly!'
      end
      puts @name + '\'s stomach grumbles...'
    end

    if poopy?
      if @asleep
        @asleep = false
        puts 'He wakes up suddenly!'
      end
      puts @name + ' does the potty dance...'
    end
  end


=end

end

Jhon = Dragon.new("John","Hero","Male")