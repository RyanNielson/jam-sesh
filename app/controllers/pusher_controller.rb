class PusherController < ApplicationController
  protect_from_forgery :except => :auth # stop rails CSRF protection for this action
  
  def auth
    # if current_user
    #TODO: Added second param (hash) to authenticate (http://pusher.com/docs/authenticating_users#implementing_endpoints)
    response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
      user_id: session[:session_id]
    })
    render :json => response
    # else
    #   render :text => "Forbidden", :status => '403'
    # end
  end
end
