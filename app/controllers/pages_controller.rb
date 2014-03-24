class PagesController < ApplicationController
  def home
    @instrument = rand 9
    if params[:opt] == 'judy'
      @instrument = 4
    end
    case @instrument
    when 0, 5
      @wrapper_class = 'pink'
      @instrument = 0
    when 1, 6
      @wrapper_class = 'purple'
      @instrument = 1
    when 2, 7
      @wrapper_class = 'green'
      @instrument = 2
    when 3, 8
      @wrapper_class = 'blue'
      @instrument = 3
    when 4
      @wrapper_class = 'judy'
    end
  end

  def judy
    return self.home true
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
