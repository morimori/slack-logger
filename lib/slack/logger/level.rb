module Slack
  class Logger
    LEVEL = {
      fatal: {
        color: '#EB2C32',
        emoji: ':sos:',
      },
      error: {
        color: '#CE0914',
        emoji: ':heavy_exclamation_mark:',
      },
      warn: {
        color: '#C9A023',
        emoji: ':warning:',
      },
      info: {
        color: '#1A1A1A',
        emoji: ':information_source:',
      },
      debug: {
        color: '#51981B',
        emoji: ':beetle:',
      },
    }.freeze
  end
end
