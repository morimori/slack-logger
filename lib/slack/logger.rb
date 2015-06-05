require 'slack/logger/version'
require 'slack/logger/level'
require 'slack-notifier'

module Slack
  class Logger
    def initialize(username, fatal: nil, error: nil, warn: nil, info: nil, debug: nil)
      @username = username
      @urls     = {
        fatal: fatal,
        error: error,
        warn:  warn,
        info:  info,
        debug: debug,
      }
    end

    def notify(level, summary, fields: [], color: nil, icon: nil, verbose: false)
      return if @urls[level].nil?

      client = Slack::Notifier.new @urls[level], notifier_params(level, icon)
      client.ping summary, attachments: attachments(level, fields, verbose)
    end

    LEVEL.each_key do |method_name|
      define_method method_name do |summary, fields: [], color: nil, icon: nil, verbose: false|
        notify method_name, summary, fields: fields, color: color, icon: icon, verbose: verbose
      end
    end

    private
    def hostname
      @hostname ||= `hostname`.strip
    end

    def notifier_params(level, icon)
      icon ||= LEVEL[level][:emoji]
      {username: @username}.tap do |params|
        break if icon.nil?
        if icon[0] == ':' && icon[-1] == ':'
          params[:icon_emoji] = icon
        else
          params[:icon_url] = icon
        end
      end
    end

    def attachments(level, fields, verbose)
      color ||= LEVEL[level][:color]

      fields += default_fields(level, verbose)
      fields.uniq!{ |field| field[:title] }

      [{
        color: color,
        fields: fields,
      }]
    end

    def default_fields(level, verbose)
      return [] unless verbose
      [
        {
          title: 'Date',
          value: Time.now.localtime.iso8601,
          short: true,
        }, {
          title: 'From',
          value: hostname,
          short: true,
        }, {
          title: 'Level',
          value: level.to_s.upcase,
          short: true,
        },
      ]
    end
  end
end
