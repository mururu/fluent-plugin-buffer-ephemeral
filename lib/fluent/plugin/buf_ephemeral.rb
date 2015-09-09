module Fluent
  class EphemeralBuffer < MemoryBuffer
    Fluent::Plugin.register_buffer('ephemeral', self)

    def initialize
      super

      @log = $log
    end

    config_param :buffer_log_level, :default => nil
    # to set log_level of the output plugin and this plugin at once
    config_param :log_level, :defualt => nil


    def configure(conf)
      super

      if @buffer_log_level
        set_log_level(@buffer_log_level)
      elsif @log_level
        set_log_level(@log_level)
      end

      @log.warn "If failed to write a chunk once, it will be lost."
    end
    
    def write_chunk(chunk, out)
      super
    rescue => e
      @log.info("failed to write the chunk", chunk_key: chunk.key)
      @log.info_backtrace(e.backtrace)
    end

    private
    def set_log_level(log_level)
      unless @log.is_a?(Fluent::PluginLogger)
        @log = Fluent::PluginLogger.new($log)
      end
      @log.level = log_level
    end
  end
end
