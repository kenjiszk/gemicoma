require 'rails_helper'

describe Github::RepositoriesController, type: :request do
  describe '#create' do
    subject { post url, params: params }

    let(:url) { '/github/repositories' }
    let(:params) { {} }

    context 'when correct params' do
      let(:params) do
        {
          user: github_user,
          repository: repository,
          public: true,
          bundle_files: bundle_files,
          commit_hash: commit_hash,
        }
      end

      let(:bundle_files) { [{ file_type: :rubygem, filepath: './' }] }
      let(:github_user) { 'ota42y' }
      let(:repository) { 'test' }
      let(:commit_hash) { SecureRandom.hex(40) }

      it do
        expect(subject).to redirect_to('/github/users/ota42y/repositories/test')
        expect(response.status).to eq 302

        user = Github::User.find_by!(name: github_user)
        github_repository = user.github_repositories.find_by!(repository: repository)

        gemfile_info = github_repository.github_ruby_gemfile_info
        expect(gemfile_info.filepath).to eq './'

        revision = github_repository.github_revisions.first
        expect(revision.commit_hash).to eq commit_hash
        expect(revision.status).to eq 'initialized'
      end
    end
  end
end
