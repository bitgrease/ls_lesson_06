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
  board[num] == ' '
end

def user_turn(board)
  loop do 
    prompt_user('Please choose where you want to place your mark [1-9]:')
    user_choice = gets.chomp
    if (1..9).include?(user_choice.to_i) && position_empty?(user_choice.to_i, board)
      board[user_choice.to_i] = 'X'
      break
    end
    prompt_user('Position must be unoccupied and choice must be between 1-9.')
  end
end

board = initialize_board

display_board(board)
user_turn(board)
display_board(board)