class PagesController < ApplicationController
  def home
    @instrument = rand 8
    # if params[:opt] == 'judy'
    #   @instrument = 4
    # end
    if params[:opt].to_i
      if (1..4).include?(params[:opt].to_i)
        @instrument = params[:opt].to_i - 1
      end
    end
    case @instrument
    when 0, 4
      @wrapper_class = 'pink'
      @instrument = 0
    when 1, 5
      @wrapper_class = 'purple'
      @instrument = 1
    when 2, 6
      @wrapper_class = 'green'
      @instrument = 2
    when 3, 7
      @wrapper_class = 'blue'
      @instrument = 3
    # when 4
    #   @wrapper_class = 'judy'
    end

    if cookies[:times_visited]
      cookies[:times_visited] = cookies[:times_visited].to_i + 1
    else
      cookies[:times_visited] = 1
    end

    @times_visited = cookies[:times_visited]
  end

  def submit_note
    unless params[:instrument].blank? || params[:note].blank?
      Pusher['notes'].trigger('note_played', {
        instrument: params[:instrument],
        note: params[:note],
        time: params[:time],
        decay: params[:decay]
      })
    end

    respond_to do |format|
      format.js { }
    end
  end

  def submit_accelerometer
    require 'pp'
    pp params
    unless params[:accelerometer].blank?
      Pusher['pads'].trigger('pad_change', {
        pad: params[:accelerometer]
      })
    end

    respond_to do |format|
      format.js { }
    end
  end

  def listen
  end

  def accelerometer
  end
end
