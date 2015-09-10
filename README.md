# fluent-plugin-buffer-ephemeral

[![Build Status](https://secure.travis-ci.org/mururu/fluent-plugin-buffer-ephemeral.png?branch=master)](http://travis-ci.org/mururu/fluent-plugin-buffer-ephemeral)

Fluentd memory buffer plugin to disable retry and suppress warnings on failure of output.

## Installation

```
$ fluent-gem install 'fluent-plugin-buffer-ephemeral'
```

or

```
$ td-agent-gem install fluent-plugin-buffer-ephemeral
```

## Configuration

```
<match **>
  type your_output_plugin
  buffer_type ephemeral
  buffer_log_level warn (optional)
  log_level info (optional, this could be overwitten by buffer_log_level)
</match>
```

If you want to suppress warnings on failure of output, you should set `(buffer_)log_level` as warn or over.

Options of memory buffer are available.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

