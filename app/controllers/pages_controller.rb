class PagesController < ApplicationController
  def home
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

  def listen

  end
end
