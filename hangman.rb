require 'yaml'
require 'date'

class Game
  def initialize
    @incorrect_guesses = []
    @strike = 0

    @secret_word = create_word_list.shuffle.first
    @placeholder = "-" * @secret_word.length
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

  def choose_mode
    puts "Do you want to play a new game (n) or start a saved game (s)?"
    input = gets.chomp.downcase
    until input == "n" || input == "s"
      puts "Please try again."
      input = gets.chomp.downcase
    end
    load_from_yaml if input == "s"
    play
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
    puts "Please guess a letter. To save your progress, please enter 'save'."
    input = gets.chomp.downcase
    until (input.match(/[a-z]/) && input.length == 1) || input == "save"
      puts "Please guess 1 letter from the alphabet or enter 'save'."
      input = gets.chomp.downcase
    end
    save_to_yaml if input == "save"
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

  def save_to_yaml
    current_time = Time.now
    File.open("savefile.yaml", "w") do |file|
      hash = {current_time: current_time,
              incorrect_guesses: @incorrect_guesses,
              strike: @strike,
              secret_word: @secret_word,
              placeholder: @placeholder}
      file.puts YAML::dump(hash)
    end
    puts "Your game has been saved at #{current_time}."
    exit
  end

  def load_from_yaml
    File.open("savefile.yaml", "r") do |file|
      data = YAML::load(file)
      current_time = data[:current_time]
      @incorrect_guesses = data[:incorrect_guesses]
      @strike = data[:strike]
      @secret_word = data[:secret_word]
      @placeholder = data[:placeholder]
      puts "This game was saved at #{current_time}."
    end
  end

end

game = Game.new
game.choose_mode