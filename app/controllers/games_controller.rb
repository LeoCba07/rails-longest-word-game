require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase
    letters = params[:letters].split("")

    word_letters = @word.chars
    available_letters = letters.dup

    valid_from_letters = word_letters.all? do |letter|
      if available_letters.include?(letter)
        available_letters.delete_at(available_letters.index(letter))
        true
      else
        false
      end
    end

    if !valid_from_letters
      @message = "Sorry, #{@word} can't be built from #{letters.join(' ')}"
    else
      url = "https://dictionary.lewagon.com/#{@word}"
      response_serialized = URI.parse(url).read
      response_json = JSON.parse(response_serialized)
      if response_json['found']
        @message = "Well done!"
      else
        @message = "Not a valid word"
      end
    end
  end
end
