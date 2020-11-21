#When a new game is started, load in the dictionary and randomly select a word between 5 and 12 characters long for the secret word
class Game
  def initialize
    @possible_words = []
    @dictionary = File.readlines('5desk.txt')
    @dictionary.each do |word|
      @possible_words << word if word.strip.length > 4 && word.strip.length < 13
    end
    @secret_word = @possible_words.shuffle.first
    puts @secret_word
  end


#Display a counter so the player knows how many more incorrect guesses they have before the game ends

#Display which correct letters have already been chosen (and their position in the word, e.g. _ r o g r a _ _ i n g) and which incorrect letters have already been chosen

#Every turn, allow the player to make a guess of a letter (it should be case insensitive)
  def play
    guess
  end

  def guess
    puts "Please guess a letter."
    @guess = gets.chomp.downcase
    until @guess.match(/[a-z]/) && @guess.length == 1
      puts "You have not chosen 1 letter from the alphabet. Please try again."
      @guess = gets.chomp.downcase
    end
  end

#Update the display to reflect whether the letter was correct or incorrect
#If out of guesses, the player should lose

end

game = Game.new
game.play

#AFTER DEVELOPING THE GAME

#Instead of making a guess, the player should also have the option to save the game

#When the program first loads, allow the player to open one of their saved games, which jumps exactly back to the saved moment