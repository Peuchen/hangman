#When a new game is started, load in the dictionary and randomly select a word between 5 and 12 characters long for the secret word
class Game
  def initialize
    $win = false

    @possible_words = []
    @incorrect_guesses = []

    @dictionary = File.readlines('5desk.txt')
    @dictionary.each do |word| word.strip!
      if word.length > 4 && word.length < 13 && word == word.downcase
        @possible_words << word
      end
    end
    @secret_word = @possible_words.shuffle.first

    @placeholder = "-" * @secret_word.length
  end

  def play
    @strike = 0
    until $win
      count(@strike)
      feedback(guess)
      if @strike == 10
        puts "You have lost the game. The secret word was #{@secret_word}."
        break
      end
    end
    puts "You have won. Congratulations!" if $win
  end
#Display a counter so the player knows how many more incorrect guesses they have before the game ends
  def count(turn)
    puts "********************\nYou have got #{10-@strike} guesses left."
    puts "Secret word: #{@placeholder} (#{@placeholder.length} letters)"
  end

#Every turn, allow the player to make a guess of a letter (it should be case insensitive)

  def guess
    puts "Please guess a letter."
    @guess = gets.chomp.downcase
    until @guess.match(/[a-z]/) && @guess.length == 1
      puts "You have not chosen 1 letter from the alphabet. Please try again."
      @guess = gets.chomp.downcase
    end
    @guess
  end

#Display which correct letters have already been chosen (and their position in the word, e.g. _ r o g r a _ _ i n g) and which incorrect letters have already been chosen

  def feedback(guess)
    if @secret_word.include?(guess)
      puts "Your guess '#{guess}' is included in the secret word."
      @secret_word.split("").each_with_index do |letter, idx|
        @placeholder[idx] = letter if letter == guess
      end
    else
      @incorrect_guesses << guess
      @strike += 1
    end
    puts "Incorrect: #{@incorrect_guesses.sort.join(" ")}"

    $win = true unless @placeholder.include?("-")
  end

#Update the display to reflect whether the letter was correct or incorrect
#If out of guesses, the player should lose

end

game = Game.new
game.play

#AFTER DEVELOPING THE GAME

#Instead of making a guess, the player should also have the option to save the game

#When the program first loads, allow the player to open one of their saved games, which jumps exactly back to the saved moment