require "lib/appian/deck"

describe Appian::Deck do
  # create a deck before each test
  before(:each) do
    @deck = Appian::Deck.new
  end

  it "is valid when initialized" do
    expect(@deck.valid?).to be_truthy
  end

  it "is ordered when initialized" do
    expect(@deck.ordered?).to be_truthy
  end

  it "is not ordered when initialized and swap" do
    @deck.swap(5, 6)
    expect(@deck.ordered?).to be_falsey
  end

  it "makes the deck unordered when shuffled" do
    expect(@deck.ordered?).to be true
    @deck.shuffle()
    expect(@deck.ordered?).to be false
  end

  it "maintains a valid deck when shuffled" do
    @deck.shuffle()
    expect(@deck.valid?).to be true
  end

  it "deals out 52 cards and then nil" do
    @deck.shuffle()
    @deck.size().times do
      c = @deck.dealOneCard()
      expect(c).not_to be_nil
    end
    3.times {expect(@deck.dealOneCard()).to be_nil}
  end

  it "has a smaller size after dealing some cards" do
    num_cards = rand(20) + 3
    num_cards.times { @deck.dealOneCard() }
    expect(@deck.size()).to be Appian::Deck::DECK_SIZE - num_cards
  end

  it "is still valid after dealing out some cards" do
    num_cards = rand(20) + 3
    num_cards.times { @deck.dealOneCard() }

    expect(@deck.valid?).to be_truthy
  end

  it "has ace high" do
    expect(@deck.ace_rank).to be 14
  end

  it "has ace low" do
    @deck = Appian::Deck.new(false)
    expect(@deck.ace_rank).to be 1
  end

end
