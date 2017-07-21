EMPTY_SQUARE = ' '
COMPUTER_PIECE = 'O'
PLAYER_PIECE = 'X'
ENOUGH_MOVES_FOR_WIN = 5
TIE = false
WINNING_POSITIONS = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                     [1, 4, 7], [2, 5, 8], [3, 6, 9],
                     [1, 5, 9], [3, 6, 9]]

def prompt_user(str)
  puts "=> #{str}"
end

def display_board(board)
  system 'clear'
  system 'cls'
  puts "You are #{PLAYER_PIECE} and Computer is #{COMPUTER_PIECE}."
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
    prompt_user("Choose a square (#{empty_squares(board).join(', ')}):")
    user_choice = gets.chomp
    break if empty_squares(board).include? user_choice.to_i
    prompt_user("Try again. Pick from #{empty_squares(board).join(', ')}.")
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
  WINNING_POSITIONS.each do |row_col_diag|
    line = ''
    counter = 0

    until counter.eql? row_col_diag.size
      line << board[row_col_diag[counter]]
      counter += 1
    end

    return 'Computer' if line.eql?('OOO')
    return 'Player' if line.eql?('XXX')
  end
  TIE
end

loop do
  board = initialize_board

  loop do
    display_board(board)
    player_places_piece!(board)
    if number_squares_used(board) >= ENOUGH_MOVES_FOR_WIN
      break if someone_won?(board) || board_full?(board)
    end
    display_board(board)

    puts 'Computer choses a square'
    sleep 1
    display_board(board)
    computer_places_piece!(board)
    if number_squares_used(board) >= ENOUGH_MOVES_FOR_WIN
      break if someone_won?(board)
    end
  end

  display_board(board)
  prompt_user "#{calculate_winner(board) || 'No one'} won. Play again? (y/n)"
  break unless gets.chomp.downcase.chr.eql? 'y'
end
