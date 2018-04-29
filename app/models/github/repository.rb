# == Schema Information
#
# Table name: github_repositories
#
#  id             :bigint(8)        not null, primary key
#  github_user_id :bigint(8)        not null
#  repository     :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  user_id_repository_unique  (github_user_id,repository) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (github_user_id => github_users.id)
#

class Github::Repository < ApplicationRecord
  belongs_to :github_user, class_name: 'Github::User', inverse_of: :github_repositories

  has_one :github_ruby_gemfile_info, class_name: 'Github::Ruby::GemfileInfo',
                                     dependent: :destroy,
                                     inverse_of: :github_repository,
                                     foreign_key: :github_repository_id

  has_many :github_revisions, class_name: 'Github::Revision',
                              dependent: :destroy,
                              inverse_of: :github_repository,
                              foreign_key: :github_repository_id
end
