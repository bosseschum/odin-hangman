require 'yaml'

class Game
  ALPHABET = 26

  def initialize
    @computer = Computer.new
    @player = Player.new
    @guessed = []
    @wrong = 0
    @solution = @computer.pick_word
  end

  def user_guess
    guess = ''
    until guess.length == 1 && guess.match?(/[a-z]/)
      puts 'Your next guess: '
      guess = gets.chomp.downcase
      puts 'Please guess only one character at a time.' if guess.length > 1
    end
    if @guessed.include?(guess)
      puts 'You already guessed that one!'.colorize(:yellow)
    else
      @guessed << guess
      if @solution.include?(guess)
        puts 'Good guess!'.colorize(:green)
      else
        puts "Sorry, that one's not in there.".colorize(:red)
        @wrong += 1
      end
    end
  end

  def display_board
    @board = Array.new(@solution.length, '_ ')
    @solution.split('').each_with_index do |char, i|
      @board[i] = char if @guessed.include?(char)
    end

    wrong_letters = (@guessed - @solution.split('')).join(' ')
    puts "Wrong guesses: #{wrong_letters}".colorize(:red) unless wrong_letters.empty?
    puts ''
    puts @board.join(' ')
    puts ''
  end

  def turns_left
    puts "You have #{10 - @wrong} wrong guesses left!"
    puts ''
  end

  def winner?
    @solution.split('').uniq.all? { |char| @guessed.include?(char) }
  end

  def game_over?
    @wrong == 10
  end

  def save_game
    save = {
      guessed: @guessed,
      wrong: @wrong,
      solution: @solution
    }

    File.open('hangman_save.yaml', 'w') do |file|
      file.write(save.to_yaml)
    end
  end

  def load_game
    data = YAML.load_file('hangman_save.yaml')
    @guessed = data[:guessed]
    @wrong = data[:wrong]
    @solution = data[:solution]
  end

  def play
    if File.exist?('hangman_save.yaml')
      puts 'Found a saved game! Load it? (y/n)'
      if gets.chomp.downcase == 'y'
        load_game
        puts "Continuing game... #{@guessed.length} guesses made so far."
      end
    end

    puts '===== WELCOME TO HANGMAN ====='
    puts "Your word has #{@solution.length} letters. Get ready to guess!"

    until winner? || game_over?
      display_board
      puts '=============================='
      puts 'Do you want to save your game? (y/n/q for save & quit)'
      choice = gets.chomp.downcase
      if choice == 'y'
        save_game
        puts 'Game saved!'
      elsif choice == 'q'
        save_game
        puts 'Game saved! Goodbye!'
        return
      end
      user_guess
      turns_left
    end

    File.delete('hangman_save.yaml') if File.exist?('hangman_save.yaml')

    if winner?
      puts 'Congratulations! YOU WIN!'
      puts "The word was #{@solution.upcase}!"
      @player.score += 1
    else
      puts "The word was #{@solution}!"
      puts <<~HANGMAN
        You're DEAD!
            +---+
            |   |
            O   |
           /|/  |
           / /  |
                |
          ========
      HANGMAN
    end
  end
end
