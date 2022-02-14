require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    generate_board
  end

  def score
    @board = params[:arr]
    @answer = params[:answer]

    @word = check_word(@answer)
    english = word_english?(@word)
    check = word_check?(@answer, @board.gsub(' ', ''))

    @result = result_check(english, check)
  end

  def generate_board
    a_to_z = ('a'..'z').map.to_a
    @arr = []

    10.times { @arr << a_to_z.sample(1)[0] }
  end

  def check_word(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt.downcase}"
    word_page = URI.open(url).read
    JSON.parse(word_page)
  end

  def word_check?(attempt, grid_str)
    attempt.chars.each do |letter|
      return false unless grid_str.downcase.include?(letter.downcase)

      grid_str = grid_str.downcase.sub(letter.downcase, '')
    end

    true
  end

  def word_english?(word_json)
    word_json['found'] == true
  end

  def result_check(english, check)
    if english && check
      "<strong>Congratulations!</strong> #{@answer.upcase} is a valid English word!"
    elsif check == false
      "Sorry but <strong>#{@answer.upcase}</strong> can't be built out of #{@board.upcase.gsub(' ', ', ')}"
    elsif english == false
      "Sorry but <strong>#{@answer.upcase}</strong> is not a valid English word..."
    end
  end
end
