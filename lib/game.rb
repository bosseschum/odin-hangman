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
    until guess.length == 1
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

    puts (@guessed - @solution.split('')).join('').colorize(:red)
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

  def play
    puts '===== WELCOME TO HANGMAN ====='
    puts "Your word has #{@solution.length} letters. Get ready to guess!"

    until winner? || game_over?
      display_board
      puts '=============================='
      user_guess
      turns_left
    end

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
