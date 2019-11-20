# frozen_string_literal: true

class AllowedSubmit
  prepend SimpleCommand

  def initialize(user_id)
    @user_id = user_id
  end

  def call
    allowed_submit
  end

  private

  def allowed_submit
    @current_contest = CurrentContest.call

    raise ExceptionHandler::ContestNotFound, "Contest Not Found" unless
              @current_contest.success? || @current_contest.result.nil?

    (won_last_contest && already_submitted_songs <= 2 ||
                      !won_last_contest && already_submitted_songs <= 1)
  end

  def won_last_contest
    WonLastContest.call(@user_id).result
  end

  def already_submitted_songs
    Song.where(submitby_user_id: @user_id)
      .where(contest_id: @current_contest.result[:id]).count
  end
end
