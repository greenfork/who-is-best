module Api
  module Github
    # Gets the publicly available data via the REST Github API v3.
    class Rest
      ACCEPT = 'application/vnd.github.v3+json'.freeze
      BASE_URL = 'https://api.github.com/repos'.freeze
      CONTRIBS_PATH = '/contributors'.freeze

      ##
      # Prepares HTTP information for future requests.
      #
      # :args: repo, oauth_token
      #
      # * +repo+ - string consisting of owner and repository name
      #   e.g. 'ruby/ruby' or '/ruby/ruby'.
      #
      # * +oauth_token+ - personal github authentication token used to
      #   increase the maximum requests per hour from 60 to 5000,
      #   requires no special access permissions.

      def initialize(repo, oauth_token = nil, client = RestClient)
        @client = client
        slash = repo[0] == '/' ? '' : '/'
        @url = BASE_URL + slash + repo
        @headers = { accept: ACCEPT }
        unless oauth_token.blank?
          @headers.merge!(authorization: "token #{oauth_token}")
        end
      end

      # Prints at most +number+ names of the most active contributors,
      # 3 by default. On any exception returns +nil+.
      def contributors(number = 3)
        url = @url + CONTRIBS_PATH
        response = @client.get(url, @headers)
        JSON.parse(response)[0...number].map { |h| h['login'] }
      rescue
        nil
      end
    end
  end
end
