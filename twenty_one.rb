require 'pry'
# 1. Initialize deck
# 2. Deal cards to player and dealer
# 3. Player turn: hit or stay
#   - repeat until bust or "stay"
# 4. If player bust, dealer wins.
# 5. Dealer turn: hit or stay
#   - repeat until total >= 17
# 6. If dealer bust, player wins.
# 7. Compare cards and declare winner.

SUITS_AND_FACES = { d: 'Diamonds', s: 'Spades', c: 'Clubs', h: 'Hearts',
                    a: 'Ace', k: 'King', q: 'Queen', j: 'Jack'}

def card_name(card)
  "#{SUITS_AND_FACES[card.last.to_sym] || card.last } of " + \
  "#{SUITS_AND_FACES[card.first.to_sym]}"
end

def joinand(cards, separator=',', word='and')
  case cards.size
  when 0 then ''
  when 1 then card_name(cards.first)
  when 2 then "#{card_name(cards.first)} #{word} #{card_name(cards.last)}"
  else
    names = cards.map { |card| card_name(card) }
    cards[-1] = "#{word} #{cards.last}"
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
  deck
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

deck = create_shuffled_deck
player_hand = []
dealer_hand = []

deal_cards(player_hand, deck, true)
deal_cards(dealer_hand, deck, true)

show_hand(player_hand)
show_hand(dealer_hand, true)
show_hand(dealer_hand, true, true)

