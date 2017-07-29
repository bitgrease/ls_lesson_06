require 'pry'
SUITS_AND_FACES = { d: 'Diamonds', s: 'Spades', c: 'Clubs', h: 'Hearts',
                    a: 'Ace', k: 'King', q: 'Queen', j: 'Jack' }

def clear_screen
  system('clear') || system('cls')
end

def user_y_or_n
  entered_choice = ''
  loop do
    entered_choice = gets.chomp.downcase.chr
    return entered_choice if %w[y n].include? entered_choice
    puts 'Invalid Choice. Choose "y" or "n".'
  end
end

def card_name(card)
  "#{SUITS_AND_FACES[card.last.to_sym] || card.last} of " \
   "#{SUITS_AND_FACES[card.first.to_sym]}"
end

def joinand(cards, separator=',', word='and')
  case cards.size
  when 0 then ''
  when 1 then card_name(cards.first)
  when 2 then "#{card_name(cards.first)} #{word} #{card_name(cards.last)}"
  else
    names = cards.map { |card| card_name(card) }
    names[-1] = "#{word} #{names.last}"
    names.join(separator + ' ')
  end
end

def create_shuffled_deck
  card_values = %w[a 1 2 3 4 5 6 7 8 9 j k q]
  suits = %w[h c s d]
  deck = []
  suits.each do |suit|
    card_values.each do |value|
      deck << [suit, value]
    end
  end
  deck.shuffle
end

def deal_cards(player_hand, deck, initial_deal=false)
  initial_deal ? 2.times { player_hand << deck.pop } : player_hand << deck.pop
end

def show_hand(player_hand, is_dealer=false, reveal=false)
  if is_dealer
    if reveal
      puts "Dealer has #{joinand(player_hand)}."
    else
      puts "Dealer has #{card_name(player_hand[0])} showing."
    end
  else
    puts "You have #{joinand(player_hand)}."
  end
end

def calculate_ace_value(hand_value_without_aces, ace_count)
  if hand_value_without_aces >= 11 || ace_count > 1
    ace_count * 1
  else
    11
  end
end

def hand_value(hand)
  ace_count = 0
  total_without_aces = 0
  values = hand.map { |card| card[1] }
  values.each do |value|
    if %w[1 2 3 4 5 6 7 8 9 10].include? value
      total_without_aces += value.to_i
    elsif %w[k q j].include? value
      total_without_aces += 10
    else
      ace_count += 1
    end
  end

  total_without_aces + calculate_ace_value(total_without_aces, ace_count)
end

def busted?(card_hand)
  hand_value(card_hand) > 21
end

def hit_or_stay(player_hand, deck)
  return if hand_value(player_hand) == 21
  choice = ''
  loop do
    loop do
      puts 'Hit or Stay? (h or s)'
      choice = gets.chomp.downcase.chr
      break if %w[h s].include? choice
      puts 'Invalid choice!'
    end
    
    if choice.eql? 's'
      puts 'You chose to stay.'
      break
    end
    player_hand << deck.pop
    clear_screen
    show_hand(player_hand)
    break if busted?(player_hand)
  end
end

def dealer_play(dealer_hand, deck)
  loop do
    if hand_value(dealer_hand) >= 17
      puts busted?(dealer_hand) ? 'Dealer Busted!' : 'Dealer Stays.'
      break
    end
    puts 'Dealer hits...'
    sleep 1
    dealer_hand << deck.pop
  end
end

def player_win_or_bust?(player_hand)
  hand_value(player_hand) == 21 || busted?(player_hand)
end

def find_winner(player_hand, dealer_hand)
  return 'Player' if hand_value(player_hand) == 21 || busted?(dealer_hand)
  return 'Dealer' if busted?(player_hand) || 
                     hand_value(dealer_hand) > hand_value(player_hand)
  'Player'
end

def show_winner(player_hand, dealer_hand)
  puts "Player has #{hand_value(player_hand)}."
  puts "Dealer has #{hand_value(dealer_hand)}."
  puts "#{find_winner(player_hand, dealer_hand)} wins."
end

loop do
  clear_screen
  deck = create_shuffled_deck
  player_hand = []
  dealer_hand = []

  deal_cards(player_hand, deck, true)
  deal_cards(dealer_hand, deck, true)
  show_hand(player_hand)
  show_hand(dealer_hand, true)
  hit_or_stay(player_hand, deck)
  show_hand(dealer_hand, true, true)
  dealer_play(dealer_hand, deck) unless player_win_or_bust?(player_hand) 
  puts "Busted!" if busted?(player_hand) || busted?(dealer_hand)
  show_winner(player_hand, dealer_hand)
  puts 'Do you want to play again? (y/n)'
  break if user_y_or_n.eql? 'n'
end



