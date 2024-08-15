module Jekyll
  module DarkVisitors
    class DarkVisitorsRobotsTxtGenerator < Jekyll::Generator
      safe true
      priority :lowest
      
      DEFAULTS = {
        'append_existing' => false,
        'agent_types' => [
          'AI Data Scraper',
          'Undocumented AI Agent'
        ],
        'disallow' => '/'
      }

      def existing_robots?()
        files = @site.pages + @site.static_files
        files.any? { |file| file.url == "/robots.txt" }
      end

      def get_robots()
        files = @site.pages + @site.static_files
        files.detect { |file| file.url == "/robots.txt" }
      end

      def kill_robots(robots_file)
        @site.pages.delete(robots_file)
        @site.static_files.delete(robots_file)
      end

      def cache
        @@cache ||= Jekyll::Cache.new('DarkVisitors::RobotsTxt')
      end

      def generate(site)
        @site = site

        @configs = {}
        DEFAULTS.each do |key, value|
          if @site.config['darkvisitors'].key?(key) 
            @configs[key] = @site.config['darkvisitors'][key]
          else
            @configs[key] = value
          end
        end

        if existing_robots? 
          unless @configs['append_existing']
            Jekyll.logger.warn '     Dark Visitors: robots.txt already exists and append_existing is false, skipping...'
          else
            @site.pages << appendedRobots()
          end
        else
          @site.pages << makeRobots()
        end
      end

      def makeRobots(prep = nil)
        rtxt = DarkVisitorsRobotsTxtPage.new(@site, '', '', 'robots.txt')
        rtxt.content = prep ? prep << "\r\n\n" : ""
        rtxt.content << fetchRobots() 
        rtxt.data['layout'] = nil
        rtxt
      end

      def appendedRobots()
        rcurrent = get_robots()
        existing_content = File.read(rcurrent.path)

        kill_robots(rcurrent)

        makeRobots(existing_content)
      end

      def fetchRobots()
        cache.getset('robotsdottxt') do
          Jekyll.logger.info '     Dark Visitors: fetching latest robots.txt'

          unless @site.config.key?('darkvisitors') and @site.config['darkvisitors'].key?('access_token')
            Jekyll.logger.error '     Dark Visitors: Missing access token in config'
            raise 'missing darkvisitors access_token in config'
          end

          bearer = @site.config['darkvisitors']['access_token']
          uri = URI('https://api.darkvisitors.com/robots-txts')
          params = {
            'agent_types': @configs['agent_types'],
            'disallow': @configs['disallow']
          }
          headers = {
            'Authorization' => "Bearer #{bearer}",
            'Content-Type' => 'application/json'
          }

          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          request = Net::HTTP::Post.new(uri.request_uri, headers)
          request.body = params.to_json
          response = http.request(request)

          unless response.is_a?(Net::HTTPSuccess)
            Jekyll.logger.error '     Dark Visitors: failed to fetch robots.txt'
            raise "#{response.code} #{response.message}: #{response.body}"
          end

          response.body
        end
      end
    end

    class DarkVisitorsRobotsTxtPage < Jekyll::Page
      def read_yaml(*)
        @data = {}
      end
    end
  end
end