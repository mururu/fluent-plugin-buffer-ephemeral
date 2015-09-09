module Fluent
  class EphemeralBuffer < MemoryBuffer
    Fluent::Plugin.register_buffer('ephemeral', self)
    
    def write_chunk(chunk, out)
      super
    rescue
    end
  end
end
