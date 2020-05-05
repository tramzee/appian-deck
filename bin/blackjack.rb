#!/usr/bin/env ruby

$: << File.join(File.dirname(__FILE__), '..')

require "lib/appian/deck"

STDOUT.sync = true

# class to implement a simple game of blackjack with a dealer and a player
class Blackjack

  GOAL_HAND = 21

  def initialize(player_name)
    # make a new deck
    @deck = Appian::Deck.new
    # set up the dealer and the player
    @dealer = Dealer.new("Dealer")
    @player = Player.new(player_name)
  end


  # play one round of blackjack
  def play_a_round(bet)

    # reset the deck (makes it really hard to count!)
    @deck.reset
    # start a new hand for the player and the dealer
    @player.new_hand(@deck)
    @dealer.new_hand(@deck)
    # deal two cards to the player and one to the dealer
    @player.hit
    @player.hit
    @dealer.hit
    # show the dealers hand
    puts @dealer

    # allow the user to play the player
    pval = @player.play

    # if the players hand value is over 21 bust and lose
    if pval > GOAL_HAND
      puts "you lose #{bet}"
      @player.lose(bet)
    else
      # otherwise play the dealer
      dval = @dealer.play
      # if the dealer busts the player wins
      # if the dealer has a lower value then the player the player wins
      if dval > GOAL_HAND || dval < pval
        puts "you win #{bet}"
        @player.win(bet)
      # if the dealer hand is greater then the players the dealer wins
      elsif dval > pval
        puts "you lose #{bet}"
        @player.lose(bet)
      # get here and it is a tie, no one wins
      else
        puts "you tied"
      end
    end
    puts
  end

  # loop getting a bet and playing a hand. A bet of 0 quits
  def play
    while true do
      print "bet: (1-#{@player.earnings}}: "
      bet = STDIN.readline.chomp!.to_i
      if bet > @player.earnings
        puts "You only have #{@player.earnings}. You cannot bet more than that"
        next
      end
      break if bet <= 0
      play_a_round(bet)
    end
  end

  # class entry point. Get a player's name and run the game.
  def self.play
    print "Your name: "
    player_name = STDIN.readline.chomp!
    new(player_name).play
  end

end


# implements a player. Mostly this keeps track of a player's earnings
class Player
  INITIAL_EARNINGS = 100
  def initialize(name)
    @earnings = INITIAL_EARNINGS
    @name = name
  end

  def win(bet)
    @earnings += bet
  end

  def earnings() @earnings end

  def lose(bet)
    win(-bet)
  end

  # start a new hand with a deck
  def new_hand(deck)
    @hand = []
    @value = 0
    @has_ace = false
    @deck = deck
  end

  # deal a card to this player from the deck. Keeps track of the value
  # of the the player's hand. Returns the hand value
  def hit
    # get a card
    card = @deck.dealOneCard

    raise "ran out out cards" if card.nil?

    # add this card to the hand
    @hand << card

    # and calculate the hands value. Aces count as 11 until the hand
    # value is greater than 21
    if card.rank == @deck.ace_rank
      if @value <= 10
        @has_ace = true
        @value += 11
      else
        @value += 1
      end
    # face cards are 10
    elsif card.rank > 10
      @value += 10
    else
      @value += card.rank
    end

    # check to see if we have an ace and are over 21
    if @value > Blackjack::GOAL_HAND && @has_ace
         @value -= 10
         @has_ace = false
    end

    return @value
  end

  # This is the player's play method. Just ask the player if they
  # would like to hit until they say no or the hand total is over
  # 21. returns the hand value
  def play
    v = @value
    puts to_s
    while true do
      print "hit? (y or n) "
      ans = STDIN.readline
      if ans =~ /^[Yy]/
        v = hit
        puts to_s
        break if v >= Blackjack::GOAL_HAND
      else
        break
      end
    end
    return v
  end

  # pretty string for players hand and value
  def to_s
    s = ["#{@name}: #{@value}"]
    @hand.each {|c| s << " " + c.to_s}
    s.join("\n")
  end

end

# subclass a Player to make a Dealer. Override the #play method since
# a dealer has rigid play rules: stand on 17 or more and hit on 16 or
# less. Returns the dealer hand value.
class Dealer < Player
  DEALER_STAY = 17
  def play
    v = @value
    puts to_s
    while v < DEALER_STAY do
      v = hit
      puts to_s
    end
    return v
  end
end

Blackjack.play
