FIRST_PLAYER = nil
EMPTY_SQUARE = ' '
PLAYER_PIECE = 'X'
COMPUTER_PIECE = 'O'
ENOUGH_MOVES_FOR_WIN = 5
PLAYER = 'Player'
COMPUTER = 'Computer'
TIE = false
CENTER = 5
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
def display_board(board, player_one, player_two, game_score)
  system 'clear'
  system 'cls'
  puts "Player is #{PLAYER_PIECE} and Computer is #{COMPUTER_PIECE}."
  print "Tournament Score: #{player_one} #{game_score[player_one]}"
  puts " - #{player_two} #{game_score[player_two]}."
  puts 'First player to five (5) wins!'
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
    prompt_user('Invalid Choice!')
  end
  board[user_choice.to_i] = PLAYER_PIECE
end

def find_at_risk_square(line, board)
  if board.values_at(*line).count(PLAYER_PIECE) == 2
    board.select { |k, v| line.include?(k) && v.eql?(EMPTY_SQUARE) }.keys.first
  end
end

def computer_winning_move(line, board)
  if board.values_at(*line).count(COMPUTER_PIECE) == 2 &&
     board.values_at(*line).include?(EMPTY_SQUARE)
    position = line.select { |pos| board[pos].eql? EMPTY_SQUARE }
    return position[0]
  end
  nil
end

def computer_places_piece!(board)
  square = nil
  WINNING_POSITIONS.each do |line|
    square = computer_winning_move(line, board)
    break if square
  end

  WINNING_POSITIONS.each do |line|
    square ||= find_at_risk_square(line, board)
    break if square
  end

  square ||= CENTER if board[CENTER].eql? EMPTY_SQUARE

  if square
    board[square] = COMPUTER_PIECE
  else
    board[empty_squares(board).sample] = COMPUTER_PIECE
  end
end

def place_piece!(board, current_player)
  if current_player.eql? PLAYER
    player_places_piece!(board)
  else
    computer_places_piece!(board)
  end
end

def board_full?(board)
  empty_squares(board).empty?
end

def number_squares_used(board)
  board.values.reject { |v| v.eql? ' ' }.size
end

def someone_won?(board)
  !!calculate_winner(board)
end

def calculate_winner(board)
  WINNING_POSITIONS.each do |line|
    if board.values_at(*line).count(PLAYER_PIECE) == 3
      return PLAYER
    elsif board.values_at(*line).count(COMPUTER_PIECE) == 3
      return COMPUTER
    end
  end
  TIE
end

def calculate_tournament_winner(game_score)
  if game_score[PLAYER] >= 5
    PLAYER
  elsif game_score[COMPUTER] >= 5
    COMPUTER
  end
end

def select_first_player
  first_player = ''
  loop do
    prompt_user 'Please select first turn ("P" for player or "C" for computer)'
    first_player = gets.chomp.downcase
    break if %w[p c].include? first_player
    prompt_user 'Invalid Choice!'
  end

  if first_player.eql? 'p'
    return PLAYER, COMPUTER
  end

  return COMPUTER, PLAYER
end

def switch_current_player(current_player)
  return PLAYER if current_player.eql? COMPUTER
  COMPUTER
end

game_score = { PLAYER => 0, COMPUTER => 0 }

system 'clear'
system 'cls'
player_one, player_two = if FIRST_PLAYER.eql? 'choose'
                           select_first_player
                         else
                           [PLAYER, COMPUTER]
                         end
current_player = player_one

loop do
  board = initialize_board

  loop do
    display_board(board, player_one, player_two, game_score)
    place_piece!(board, current_player)
    if number_squares_used(board) >= ENOUGH_MOVES_FOR_WIN
      break if someone_won?(board) || board_full?(board)
    end
    current_player = switch_current_player(current_player)
  end

  winner = calculate_winner(board)
  game_score[winner] += 1 if winner

  display_board(board, player_one, player_two, game_score)
  prompt_user "#{winner || 'No one'} won."
  current_player = player_one

  tournament_winner = calculate_tournament_winner(game_score)
  if tournament_winner
    if tournament_winner.eql? PLAYER
      prompt_user 'You won the tournament!. Play another tourney (y/n)?'
    elsif tournament_winner.eql? COMPUTER
      prompt_user 'Computer won the tournament. Play another tourney (y/n)?'
    end
    game_score.keys.each { |k| game_score[k] = 0 }
  else
    prompt_user 'Play again? (y/n)?'
  end
  break unless gets.chomp.downcase.chr.eql? 'y'

  current_player = player_one
end
