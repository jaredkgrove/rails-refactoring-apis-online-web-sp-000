class GithubService
    attr_accessor :access_token
    def initialize(access_hash = {})
        @access_token = access_hash["access_token"]
    end

    def authenticate!(client_id, client_secret, code)
        response = Faraday.post "https://github.com/login/oauth/access_token", {client_id: client_id, client_secret: client_secret, code: code}, {'Accept' => 'application/json'}
        @access_token = JSON.parse(response.body)["access_token"]
        binding.pry
        @access_token
    end

    def get_username
        user_response = Faraday.get "https://api.github.com/user", {}, {'Authorization' => "token #{self.access_token}", 'Accept' => 'application/json'}
        user_json = JSON.parse(user_response.body)
        user_json["login"]    
    end

    def get_repos
        #{self.access_token}
        response = Faraday.get "https://api.github.com/user/repos", {}, {'Authorization' => "token #{self.access_token}", 'Accept' => 'application/json'}
        repos = JSON.parse(response.body).collect{|repo_hash| GithubRepo.new(repo_hash)}
    end

    def create_repo(repo_name)
        response = Faraday.post "https://api.github.com/user/repos", {name: repo_name}.to_json, {'Authorization' => "token #{self.access_token}", 'Accept' => 'application/json'}
    end
end