require 'nokogiri'
require 'open-uri'
require 'pry'

class Shoutcast

    def initialize(options = {stream_count: 4, host: "http://dirtybass.fm:8000", password: ENV["SHOUTCAST_PASSWORD"]})
      @stream_count = options[:stream_count]
      @host = options[:host]
      @password = options[:password]
    end

    def listener_count
      all_streams.reduce(0) do |count_total, stream|
        count_total + stream.count
      end
    end

    def user_agents
      all_streams.inject([]) do |results, listener|
        listener.css('useragent').each do |user_agent|
          unless user_agent.text.empty?
            exists = results.find { |ua| ua[:label] == user_agent.text.split('/').first}
            if exists
              exists[:value] += 1
            else
              results << {label: user_agent.text.split('/').first, value: 1}
            end
          end
        end
        results
      end.sort_by { |hash| hash[:label] }
    end

    def now_playing
      summary.css('songtitle').text
    end

    def peak_listeners
      summary.css('peaklisteners').text
    end

    def stream_hits
      summary.css('streamhits').text
    end

    def ips
      all_streams.inject([]) do |results, listener|
        results + listener.css('hostname').map(&:text)
      end
    end

    private

      def all_streams
        Enumerator.new do |enum|
          (1..@stream_count).each do |stream_id|
            enum.yield parse_listeners_for_stream(stream_id)
          end
        end
      end

      def parse_listeners_for_stream(stream_id)
        listeners(stream_id).css('listener')
      end

      def summary
        @cached_noko ||= Nokogiri::HTML(summary_uri)
      end

      def summary_uri
        @cached_summary_uri ||= open("http://dirtybass.fm:8000/admin.cgi?sid=1&mode=viewxml", http_basic_authentication: ["admin", @password])
      end

      def listeners(stream_id)
        Nokogiri::HTML(listeners_uri(stream_id))
      end

      def listeners_uri(stream_id)
        open(hostname(stream_id), http_basic_authentication: ["admin", @password])
      end

      def hostname(stream_id)
        "#{@host}/admin.cgi?sid=#{stream_id}&mode=viewxml&page=3"
      end
end
