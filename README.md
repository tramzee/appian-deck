# appian-deck
Appian deck implements the specification for the take-home test for an Appian job application.

## Prerequisites
To use appian-deck requires git, ruby, bundler, and a command line shell (bash, zsh, etc).

## Running
Appian-deck consists of two components a lib, which implements the deck specification in the problem statement, and a driver, which is a simple program that uses the `Appian::Deck` lib.

To begin using appian-deck perform the following commands at the command line:
```
git clone git@github.com:tramzee/appian-deck.git
cd appian-deck
bundle install
```

### Appian::Deck Lib
As specified in the problem statement the `Appian::Deck` lib implements two methods: `shuffle()` and `dealOneCard()`.

`#dealOneCard()` will return cards from the deck until the deck is exhausted at which point it will return `nil`.

`#shuffle()` will shuffle whatever cards remain in the deck.

`#reset()` will reset the deck to the full compliment of 52 cards and re-shuffle.

Note: The appian-deck specification did not specify the exact behavior of `#shuffle`. I have chose to implement it to shuffle the *remaining* cards in the deck. It could well be the intention of the spec was for `#shuffle` to collect all 52 cards into the deck and shuffle the full deck. This functionality is implemented in the `#reset` method.

#### Creating a deck
A deck is created with `Appian::Deck.new`. `Appian::Deck.new` takes an optional parameter (`ace_high`, defaults to true) that specifies whether an ace is a high value or a low value. The only effect this has is on the ordering of cards.

#### Appian::Deck::Card class
`Appian::Deck` is implemented as an array of `Appian::Deck::Card`s. `Appian::Deck::Card` instances are comparable (==, <, etc). Currently, `Appian::Deck::Card` only has the following public methods and accessors:

`#rank` returns the rank of the card as an integer. Jack is 11, queen is 12, and king is 13. For an ace-high deck an ace is 14 otherwise an ace is 1

`#suit` returns the suit of the card. One of "spade", "heart", "diamond", "club"

`#to_s` return a pretty name for the card (e.g. "3 of Diamonds", "King of Clubs")

`Appian::Deck::Card` is ready to add additional functionality as may be requested by future requirements.

### Driver
The driver is a simple blackjack playing program. To run it type
```
bundle exec bin/blackjack.rb
```

Playing the game is a simplified version of blackjack. Once you enter your name you are prompted for a bet amount for the next hand followed by playing the hand. At the end of the hand you will have either won, lost, or drawn after which you are prompted for another bet and play another hand. Bets pay even money. You are only allowed to bet up to what you currently have in earnings. A bet of 0 or less will end the game. The object is to build a hand as close to 21 in value without exceeding 21. Cards count as their face value, except that face cards count as 10 and aces count as 11 or 1. The player plays first and if they exceed 21 they immediately lose. If they stop below 21 the dealer plays and the resulting scores are compared if the dealer is at 21 or below. The dealer plays by a rigid set of rules: he must take a card if his hand total is 16 or less and he may not take a card if his hand total is 17 or more.

## Testing
Run tests by typing
```
bundle exec rspec
```
(This is run from appian-deck directory.)
