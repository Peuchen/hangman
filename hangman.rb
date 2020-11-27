require 'yaml'
require 'date'

class Game
  def initialize
    @incorrect_guesses = []
    @strike = 0

    @secret_word = create_word_list.shuffle.first
    @placeholder = "-" * @secret_word.length
  end

  def choose_mode
    puts "Do you want to play a new game (n) or start a saved game (s)?"
    input = gets.chomp.downcase
    until input == "n" || input == "s"
      puts "Please try again."
      input = gets.chomp.downcase
    end
    if input == "n"
      play
    end
  end

  def create_word_list
    possible_words = []

    dictionary = File.readlines('5desk.txt')
    dictionary.each do |word| word.strip!
      if word.length > 4 && word.length < 13 && word == word.downcase
        possible_words << word
      end
    end
    possible_words
  end

  def play
    while @placeholder.include?("-") && @strike < 10
      display
      feedback(guess)
    end
  end

  def display
    puts "********************\nYou have got #{10-@strike} guesses left."
    puts "Secret word: #{@placeholder} (#{@placeholder.length} letters)"
    puts "Incorrect: #{@incorrect_guesses.sort.join(' ')}"
  end

  def guess
    puts "Please guess a letter. To save your progress, please write down 'save'."
    input = gets.chomp.downcase
    save_to_yaml(input)
    until (input.match(/[a-z]/) && input.length == 1)
      puts "You have not chosen 1 letter from the alphabet or saved your game by entering 'save'. Please try again."
      input = gets.chomp.downcase
      save_to_yaml(input)
    end
    input
  end

  def feedback(guess)
    if @secret_word.include?(guess)
      puts "'#{guess}' is included in the secret word."
      @secret_word.split("").each_with_index do |letter, idx|
        @placeholder[idx] = letter if letter == guess
      end
      puts "Secret word: #{@placeholder} (#{@placeholder.length} letters)\nYou have won, congratulations!" unless @placeholder.include?("-")
    else
      puts "'#{guess}' is NOT included in the secret word."
      @incorrect_guesses << guess
      @strike += 1
      if @strike == 10
        puts "You have lost the game. The secret word was '#{@secret_word}'."
      end
    end
  end

  def save_to_yaml(input)
    if input == "save"
      current_time = Time.now
      File.open("savefile.yaml", "w") do |file|
        file.puts YAML::dump(current_time)
        file.puts YAML::dump(@incorrect_guesses)
        file.puts YAML::dump(@strike)
        file.puts YAML::dump(@secret_word)
        file.puts YAML::dump(@placeholder)
      end
      puts "Your game has been saved at #{current_time}."
      exit
    end
  end

end

game = Game.new
game.choose_mode

#AFTER DEVELOPING THE GAME

#Instead of making a guess, the player should also have the option to save the game

#When the program first loads, allow the player to open one of their saved games, which jumps exactly back to the saved moment