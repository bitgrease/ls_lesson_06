# 1. Display the initial board
# 2. Ask user to mark a square
# 3. Computer marks a square
# 4. Display updated board state
# 5. If winner, display winner
# 6. If board is full, tie
# 7. If no winner and board isn't full go back to 2
# 8. Play again?
# 9. If yes, go to #1
# 10. Leave game
DEBUG = false
EMPTY_SQAURE = ' '
COMPUTER_PIECE = 'O'
PLAYER_PIECE = 'X'
require 'irb'
# use hash for board
def prompt_user(str)
  puts "=> #{str}"
end

def display_board(board)
  system 'clear'
  system 'cls'
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
  (1..9).each { |num| new_board[num] = ' ' }
  new_board
end

def position_empty?(num, board)
  board[num] == EMPTY_SQAURE
end

def empty_squares(board)
  board.keys.select { |square| board[square] == EMPTY_SQAURE }
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
  board[empty_squares(board).sample] = 'O'
end

board = initialize_board

display_board(board)
binding.irb if DEBUG
player_places_piece!(board)
display_board(board)
puts 'Computer choses a square'
sleep 1
computer_places_piece!(board)
display_board(board)
