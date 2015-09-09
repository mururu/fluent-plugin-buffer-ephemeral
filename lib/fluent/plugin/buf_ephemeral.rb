module Fluent
  class EphemeralBuffer < MemoryBuffer
    Fluent::Plugin.register_buffer('ephemeral', self)

    config_param :buffer_log_level, :string, :default => 'info'

    def configure(conf)
      super

      begin
        Fluent::Log.str_to_level(@buffer_log_level)
      rescue
        raise ConfigError "Invalid buffer log level '#{@buffer_lg_level}'"
      end

      $log.warn "If failed to write a chunk once, it will be lost."
    end
    
    def write_chunk(chunk, out)
      super
    rescue => e
      $log.send(@buffer_log_level, "failed to write the chunk", chunk_key: chunk.key)
      $log.send("#{@buffer_log_level}_backtrace", e.backtrace)
    end
  end
end
