SUITS_AND_FACES = { d: 'Diamonds', s: 'Spades', c: 'Clubs', h: 'Hearts',
                    a: 'Ace', k: 'King', q: 'Queen', j: 'Jack' }
TWENTY_ONE = 21
DEALER_STAY = 17
FACE_VALUE = 10
HIGH_ACE = 11

def clear_screen
  system('clear') || system('cls')
end

def prompt(msg)
  puts "=> #{msg}"
end

def user_y_or_n
  entered_choice = ''
  loop do
    entered_choice = gets.chomp.downcase.chr
    return entered_choice if %w[y n].include? entered_choice
    prompt 'Invalid Choice. Choose "y" or "n".'
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

def deal_cards(card_hand, deck, deal_type=:regular)
  if deal_type.eql? :initial
    2.times { card_hand << deck.pop }
  else
    card_hand << deck.pop
  end
end

def show_hand(card_hand, player=:player, cards_up=:one)
  if player.eql? :dealer
    if cards_up.eql? :two
      prompt "Dealer has #{joinand(card_hand)}."
    else
      prompt "Dealer has #{card_name(card_hand[0])} showing."
    end
  else
    prompt "You have #{joinand(card_hand)}."
  end
end

def player_win_or_bust?(card_total)
  card_total == TWENTY_ONE || busted?(card_total)
end

def hand_value(hand)
  total = 0
  values = hand.map { |card| card[1] }
  values.each do |value|
    total += if %w[1 2 3 4 5 6 7 8 9 10].include? value
               value.to_i
             elsif %w[k q j].include? value
               FACE_VALUE
             else
               HIGH_ACE
             end
  end

  values.select { |value| value.eql? 'a' }.count.times do
    total -= FACE_VALUE if total > TWENTY_ONE
  end
  total
end

def busted?(card_total)
  card_total > TWENTY_ONE
end

def hit_or_stay
  loop do
    prompt 'Hit or Stay? (h or s)'
    choice = gets.chomp.downcase.chr
    return choice if %w[h s].include? choice
    prompt 'Invalid choice!'
  end
end

def player_turn(player_hand, dealer_hand, deck)
  loop do
    choice = hit_or_stay
    prompt 'You chose to stay.' && break if choice.eql? 's'
    player_hand << deck.pop
    card_total = hand_value(player_hand)
    clear_screen
    show_both_hands(player_hand, dealer_hand)
    if player_win_or_bust?(card_total)
      prompt card_total == TWENTY_ONE ? 'You got 21!' : 'You Bust!'
      sleep 1
      break
    end
  end
end

def dealer_turn(dealer_hand, deck)
  loop do
    card_total = hand_value(dealer_hand)
    if card_total >= DEALER_STAY
      prompt busted?(card_total) ? 'Dealer Busted!' : 'Dealer Stays.'
      sleep 1
      break
    end
    prompt 'Dealer hits...'
    sleep 1
    dealer_hand << deck.pop
    show_hand(dealer_hand, :dealer, :two)
  end
end

def find_winner(player_hand, dealer_hand)
  player_total = hand_value(player_hand)
  dealer_total = hand_value(dealer_hand)
  if player_total == TWENTY_ONE || busted?(dealer_total)
    return 'Player'
  elsif busted?(player_total) || dealer_total > player_total
    return 'Dealer'
  elsif player_total == dealer_total
    return 'Tie. No one'
  end
  'Player'
end

def show_winner(player_hand, dealer_hand)
  prompt "Player has #{hand_value(player_hand)}."
  prompt "Dealer has #{hand_value(dealer_hand)}."
  prompt "#{find_winner(player_hand, dealer_hand)} wins."
end

def show_both_hands(player_hand, dealer_hand, cards_up=:one)
  show_hand(player_hand)
  show_hand(dealer_hand, :dealer, cards_up)
end

loop do
  clear_screen
  player_hand = []
  dealer_hand = []
  deck = create_shuffled_deck

  deal_cards(player_hand, deck, :initial)
  deal_cards(dealer_hand, deck, :initial)

  if hand_value(player_hand) != TWENTY_ONE
    show_both_hands(player_hand, dealer_hand)
    player_turn(player_hand, dealer_hand, deck)
    clear_screen
    show_both_hands(player_hand, dealer_hand, :two)
    unless player_win_or_bust?(hand_value(player_hand))
      dealer_turn(dealer_hand, deck)
    end
  else
    clear_screen
    show_both_hands(player_hand, dealer_hand, :two)
    prompt 'You got 21 on the deal!'
  end

  show_winner(player_hand, dealer_hand)
  prompt 'Do you want to play again? (y/n)'
  break if user_y_or_n.eql? 'n'
end
