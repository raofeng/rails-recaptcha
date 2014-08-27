class WelcomeController < ApplicationController
  def index
    puts session[:code]
  end

  def recaptcha
    img = NoisyImage.new
    session[:code] = img.code
    send_data img.image, :type => 'image/jpeg', :disposition => 'inline'
  end
end
