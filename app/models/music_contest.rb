# == Schema Information
#
# Table name: music_contest
#
#  id             :integer          not null, primary key
#  contest_status :string(1)
#  winner_user_id :integer
#  start_date     :date
#  end_date       :date
#

class MusicContest < ApplicationRecord
  self.table_name = 'music_contest'

  belongs_to :participant, class_name: 'Participant', foreign_key: :winner_user_id
  has_many :songs, class_name: 'Song'
end
