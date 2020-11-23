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
    puts "Please guess a letter."
    input = gets.chomp.downcase
    until input.match(/[a-z]/) && input.length == 1
      puts "You have not chosen 1 letter from the alphabet. Please try again."
      input = gets.chomp.downcase
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

end

game = Game.new
game.play

#AFTER DEVELOPING THE GAME

#Instead of making a guess, the player should also have the option to save the game

#When the program first loads, allow the player to open one of their saved games, which jumps exactly back to the saved moment