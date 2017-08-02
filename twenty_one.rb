SUITS_AND_FACES = { d: 'Diamonds', s: 'Spades', c: 'Clubs', h: 'Hearts',
                    a: 'Ace', k: 'King', q: 'Queen', j: 'Jack' }
PERFECT_SCORE = 21
DEALER_STAY = 17
FACE_VALUE = 10
HIGH_ACE = 11

scoreboard = { 'Player' => 0, 'Dealer' => 0, 'Tie' => 0 }

def clear_screen
  system('clear') || system('cls')
end

def prompt(msg)
  puts "=> #{msg}"
end

def user_y_or_n
  entered_choice = ''
  loop do
    entered_choice = gets.downcase.chr
    break entered_choice if %w[y n].include? entered_choice
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
  card_values = %w[a 2 3 4 5 6 7 8 9 j k q]
  suits = %w[h c s d]
  suits.product(card_values).shuffle
end

def deal_cards(card_hand, deck, number_of_cards=1)
  if number_of_cards == 2
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
  card_total == PERFECT_SCORE || busted?(card_total)
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
    total -= FACE_VALUE if total > PERFECT_SCORE
  end
  total
end

def busted?(card_total)
  card_total > PERFECT_SCORE
end

def hit_or_stay
  loop do
    prompt 'Hit or Stay? (h or s)'
    choice = gets.downcase.chr
    return choice if %w[h s].include? choice
    prompt 'Invalid choice!'
  end
end

def find_winner(player_total, dealer_total)
  if player_total == PERFECT_SCORE || busted?(dealer_total)
    return 'Player'
  elsif busted?(player_total) || dealer_total > player_total
    return 'Dealer'
  elsif player_total == dealer_total
    return 'Tie. No one'
  end
  'Player'
end

def show_winner(player_total, dealer_total)
  winner = find_winner(player_total, dealer_total)
  prompt "Player has #{player_total}."
  prompt "Dealer has #{dealer_total}."
  prompt "#{winner} wins."
end

def show_both_hands(player_hand, dealer_hand, cards_up=:one)
  show_hand(player_hand)
  show_hand(dealer_hand, :dealer, cards_up)
end

def update_scoreboard(winner, scoreboard)
  if winner.eql? 'Player'
    scoreboard['Player'] += 1
  elsif winner.eql? 'Dealer'
    scoreboard['Dealer'] += 1
  else
    scoreboard['Tie'] += 1
  end
end

def reset_scoreboard(scoreboard)
  scoreboard['Player'] = scoreboard['Dealer'] = scoreboard['Tie'] = 0
end

def find_overall_winner(scoreboard)
  if scoreboard['Player'] == 5
    'Player'
  elsif scoreboard['Dealer'] == 5
    'Dealer'
  end
end

def show_overall_score(scoreboard)
  prompt "Overall - Player #{scoreboard['Player']} -" \
          " Dealer #{scoreboard['Dealer']} - Ties #{scoreboard['Tie']}."
end

def clear_screen_display_scores(player_hand, dealer_hand,
                                scoreboard, dealer_cards=:one)
  clear_screen
  show_overall_score(scoreboard)
  show_both_hands(player_hand, dealer_hand, dealer_cards)
end

loop do
  clear_screen
  player_hand = []
  dealer_hand = []
  deck = create_shuffled_deck

  deal_cards(player_hand, deck, 2)
  deal_cards(dealer_hand, deck, 2)

  player_total = hand_value(player_hand)
  dealer_total = hand_value(dealer_hand)
  clear_screen_display_scores(player_hand, dealer_hand, scoreboard)

  until hit_or_stay.eql? 's'
    if player_total == PERFECT_SCORE
      prompt "You got #{PERFECT_SCORE}!"
      sleep 1
      break
    end

    deal_cards(player_hand, deck)
    player_total = hand_value(player_hand)
    clear_screen_display_scores(player_hand, dealer_hand, scoreboard)

    if busted? player_total
      prompt 'Player Busted!'
      sleep 1
      break
    end
  end

  clear_screen_display_scores(player_hand, dealer_hand, scoreboard, :two)
  unless player_win_or_bust?(player_total)
    until dealer_total >= DEALER_STAY
      clear_screen_display_scores(player_hand, dealer_hand, scoreboard, :two)
      deal_cards(dealer_hand, deck)
      dealer_total = hand_value(dealer_hand)
      sleep 1
    end

    clear_screen_display_scores(player_hand, dealer_hand, scoreboard, :two)

    if busted?(dealer_total)
      prompt 'Dealer Busted!'
    else
      prompt 'Dealer Stays.'
    end
    sleep 1
  end

  winner = find_winner(player_total, dealer_total)

  update_scoreboard(winner, scoreboard)
  clear_screen_display_scores(player_hand, dealer_hand, scoreboard, :two)
  prompt 'Player Busted!' if busted?(player_total)
  prompt 'Dealer Busted!' if busted?(dealer_total)
  show_winner(player_total, dealer_total)

  if find_overall_winner(scoreboard)
    prompt "#{find_overall_winner(scoreboard)} wins best of 5!"
    show_overall_score(scoreboard)
    reset_scoreboard(scoreboard)
  end

  prompt 'Do you want to play again? (y/n)'
  break if user_y_or_n.eql? 'n'
end

prompt 'Thanks for playing!!'
