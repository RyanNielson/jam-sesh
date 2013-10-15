class PagesController < ApplicationController
  def home
    @instrument = rand 4
  end

  def submit_note
    unless params[:instrument].blank? || params[:note].blank?
      Pusher['notes'].trigger('note_played', {
        instrument: params[:instrument],
        note: params[:note]
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
