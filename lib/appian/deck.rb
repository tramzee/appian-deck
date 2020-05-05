require "set"

module Appian
  class Deck

    SUITS = ["club", "diamond", "heart", "spade"]
    SUIT_SIZE = 13
    DECK_SIZE = SUITS.length * SUIT_SIZE

    # create a new Deck. ace_high is an optional argument. If Ace high
    # is true (the default) then aces are considered higher than
    # kings. Otherwise aces are the lowest card rank.
    def initialize(ace_high = true)
      @cards = []
      @delt = []
      start_rank = 1
      @ace_rank = 1
      if ace_high
        start_rank += 1
        @ace_rank += SUIT_SIZE
      end

      # range over ranks for each suit. Either 1-13 or 2-14 (for ace_high)
      (start_rank...(start_rank + SUIT_SIZE)).each do |rank|
        SUITS.each do |suit|
          v = rank
          @cards << Card.new(suit, v)
        end
      end
    end

    # the rank of an ace for this deck
    def ace_rank() @ace_rank end

    # check to see if the deck has 52 cards and there are no duplicates
    def valid?
      return false if @cards.length + @delt.length != DECK_SIZE

      seen = Set.new

      (@cards + @delt).each do |card|
        return false if seen.member?(card)
        seen << card
      end

      return true
    end

    # check to see if the deck is "ordered". This is a utility
    # function for debugging and testing
    def ordered?
      (@cards.length - 1).times do |idx|
        return false if @cards[idx] >= @cards[idx + 1]
      end
      return true
    end

    # the current size of the deck
    def size()
      return @cards.length
    end

    # collect up all the cards and reshuffle the entire deck
    def reset()
      # add all the delt cards back into the deck
      @cards.concat(@delt)
      shuffle()
    end

    # shuffle the deck. This will only shuffle the cards remainaing in the deck
    # to shuffle the entire deck use #reset
    def shuffle()
      # only shuffle the current cards
      deck_size = size()
      # go through each card in the deck. swap it with a random card
      # below (possibly itself)
      deck_size.times do |i|
        # find a random index below the current index. Note that this
        # might be equal to i.
        swap_index = rand(deck_size - i) + i
        swap(swap_index, i)
      end
    end

    # swap two cards in the deck at positions idx1 and idx2. Idx1 and
    # idx2 may be equal
    def swap(idx1, idx2)
      raise "index out of range: #{idx1}" if idx1 >= size()
      raise "index out of range: #{idx2}" if idx2 >= size()
      @cards[idx2], @cards[idx1] = [@cards[idx1], @cards[idx2]]
    end


    # deal a card from the deck
    def dealOneCard()
      return nil if @cards.empty?
      @delt << @cards.pop
      return @delt[-1]
    end

    def peek(index)
      return nil if index >= size() || index <= 0
      return @cards[-index]
    end




    # an internal class to Deck. As we want to build more
    # functionality into Cards that implemenation would go here.
    class Card
      include Comparable

      # create a new card
      def initialize(suit, rank)
        # normalize the suit and rank
        suit = suit.to_s.downcase
        # note that a non-integerish thing here will result in a 0 rank
        # which will result in an illegal rank exception below
        rank = rank.to_i

        raise "illegal suit: #{suit}" unless SUITS.member?(suit)
        raise "illegal rank: #{rank}" if rank > 14 || rank < 1

        @suit = suit
        @rank = rank
      end

      # the suit of the card
      def suit() @suit end
      # the rank of the card
      def rank() @rank end

      def to_s
        rank = case @rank
              when 1, 14; "Ace"
              when 11; "Jack"
              when 12; "Queen"
              when 13; "King"
              else @rank.to_s
              end
        return "#{rank} of #{@suit.capitalize}s"
      end

      # define the ordering between cards. This is the classic bridge
      # ordering. A card of higher rank ranks higher than a card of
      # lower rank. If ranks are equal then suits rank (lowest to
      # highest) clubs, diamonds, hearts, spades. Returns < 0 if self
      # is less than other, 0 if self is equal to other, and 1 if self
      # is greater than other
      def <=>(other)
        return nil unless other.is_a?(Card)
        ret = rank() <=> other.rank()
        return ret if ret != 0
        return SUITS.index(suit()) <=> SUITS.index(other.suit())
      end

    end


  end
end
