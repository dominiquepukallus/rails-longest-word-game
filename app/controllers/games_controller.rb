require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    # this will display the game setting & a form
    @letters = grid
  end

  def score
    # using action above in new.html the form will be submitted
    # with post to the score action in score.html
    # create an instant variable with the response
    @word = params[:word].upcase
    @letters = params[:letters].split

    if !valid_grid(@word)
      @response = "Sorry but #{@word} can't be built out of #{@letters}"
    elsif !valid_word(@word)
      @response = "Sorry but #{@word} does not seem to be a valid English word..."
    else
      @response = "Congratulations! #{@word} is a valid English word!"
    end
  end

  private

  def grid
    @letters = ("A".."Z").to_a.sample(10).join(" ")
  end

  def valid_grid(word)
    word.each_char.all? do |letter|
      word.count(letter) <= @letters.count(letter)
    end
  end

  def valid_word(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url).read
    JSON.parse(response)["found"]
  end
end
