# frozen_string_literal: true

class SongsController < ApplicationController
  before_action :set_song, only: %i[show update destroy]
  before_action :current_participant, only: %i[submit_song delete_submitted_song]

  respond_to :json

  def current_contest_songs
    # TODO: mocked-up
    render json: {}, status: 200
  end

  def submit_song
    raise ExceptionHandler::UserNotFound, "Participant Not Found" unless @current_user_id.presence

    submit_allowed = AllowedSubmit.call(@current_user_id).result

    render json: {user_id: submit_allowed}, status: 200
  end

  def delete_submitted_song
    # TODO: mocked-up
    render json: {}, status: 200
  end

  def index
    @songs = Song.all
    respond_with(@songs)
  end

  def show
    respond_with(@song)
  end

  def create
    @song = Song.new(song_params)
    @song.save
    respond_with(@song)
  end

  def update
    @song.update(song_params)
    respond_with(@song)
  end

  def destroy
    @song.destroy
    respond_with(@song)
  end

  private

  def set_song
    @song = Song.find(params[:id])
  end

  def current_participant
    @current_user_id = Participant.find(params[:song][:participant_id])
  end

  def song_params
    params.require(:song).permit(:spotify_id, :spotify_url, :spotify_title,
                                 :spotify_artist, :spotify_length, :spotify_album,
                                 :spotify_cover_id, :contest_id, :submitby_user_id,
                                 :song_url, :participant_id)
  end
end
