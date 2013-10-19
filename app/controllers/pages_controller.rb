class PagesController < ApplicationController
  def home
    @instrument = rand 4
    case @instrument
    when 0
      @wrapper_class = 'pink'
    when 1
      @wrapper_class = 'purple'
    when 2
      @wrapper_class = 'green'
    when 3
      @wrapper_class = 'blue'
    end
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
