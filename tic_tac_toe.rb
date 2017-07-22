EMPTY_SQUARE = ' '
COMPUTER_PIECE = 'O'
PLAYER_PIECE = 'X'
ENOUGH_MOVES_FOR_WIN = 5
TIE = false
WINNING_POSITIONS = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                     [1, 4, 7], [2, 5, 8], [3, 6, 9],
                     [1, 5, 9], [3, 5, 7]]

def prompt_user(str)
  puts "=> #{str}"
end

def joinor(squares, separator=',', word='or')
  case squares.size
  when 0 then ''
  when 1 then squares.first
  when 2 then squares.join(" #{word} ")
  else
    squares[-1] = "#{word} #{squares.last}"
    squares.join(separator + ' ')
  end
end

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength
def display_board(board, player_wins, computer_wins)
  system 'clear'
  system 'cls'
  puts "You are #{PLAYER_PIECE} and Computer is #{COMPUTER_PIECE}."
  puts "Tournament Score: Player #{player_wins} - Computer #{computer_wins}"
  puts ''
  puts '     |     |'
  puts "  #{board[1]}  |  #{board[2]}  |  #{board[3]}"
  puts '     |     |'
  puts '-----+-----+-----'
  puts '     |     |'
  puts "  #{board[4]}  |  #{board[5]}  |  #{board[6]}"
  puts '     |     |'
  puts '-----+-----+-----'
  puts '     |     |'
  puts "  #{board[7]}  |  #{board[8]}  |  #{board[9]}"
  puts '     |     |'
  puts ''
end
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = EMPTY_SQUARE }
  new_board
end

def empty_squares(board)
  board.keys.select { |square| board[square] == EMPTY_SQUARE }
end

def player_places_piece!(board)
  user_choice = ''
  loop do
    prompt_user("Choose a square (#{joinor(empty_squares(board))}):")
    user_choice = gets.chomp
    break if empty_squares(board).include? user_choice.to_i
    prompt_user("Try again. Pick from #{joinor(empty_squares(board))}.")
  end
  board[user_choice.to_i] = PLAYER_PIECE
end

def computer_places_piece!(board)
  board[empty_squares(board).sample] = COMPUTER_PIECE
end

def board_full?(board)
  empty_squares(board).empty?
end

def number_squares_used(board)
  board.values.select { |v| !v.eql? ' ' }.size
end

def someone_won?(board)
  !!calculate_winner(board)
end

def calculate_winner(board)
  WINNING_POSITIONS.each do |line|
    if board.values_at(*line).count(PLAYER_PIECE) == 3
      return 'Player'
    elsif board.values_at(*line).count(COMPUTER_PIECE) == 3
      return 'Computer'
    end
  end
  TIE
end

game_counter = computer_wins = player_wins = 0

loop do
  board = initialize_board


  loop do
    display_board(board, player_wins, computer_wins)
    player_places_piece!(board)
    if number_squares_used(board) >= ENOUGH_MOVES_FOR_WIN
      break if someone_won?(board) || board_full?(board)
    end
    display_board(board, player_wins, computer_wins)

    puts 'Computer choses a square'
    sleep 1
    display_board(board, player_wins, computer_wins)
    computer_places_piece!(board)
    if number_squares_used(board) >= ENOUGH_MOVES_FOR_WIN
      break if someone_won?(board)
    end
  end

  display_board(board, player_wins, computer_wins)

  winner = calculate_winner(board)
  case winner
  when 'Player'
    player_wins += 1
    game_counter += 1
  when 'Computer'
    computer_wins += 1
    game_counter += 1
  end

  prompt_user "#{winner || 'No one'} won."
  prompt_user "Player #{player_wins} - Computer #{computer_wins}"
  display_board(board, player_wins, computer_wins) # to update top of screen

  if game_counter < 5 || (computer_wins < 5 && player_wins < 5)
      prompt_user 'Play again? (y/n)'  
      break unless gets.chomp.downcase.chr.eql? 'y'
  elsif player_wins >=5 || computer_wins >= 5
    if player_wins >= 5
      prompt_user 'You won the tournament!. Play another tourney (y/n)?'
    elsif computer_wins >= 5
      prompt_user 'Computer won the tournament. Play another tourney (y/n)?'
    end
    break unless gets.chomp.downcase.chr.eql? 'y'
    game_counter = computer_wins = player_wins = 0
  end
end
