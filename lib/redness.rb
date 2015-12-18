require "json" unless defined?(JSON)
require "redis" unless defined?(Redis)
require "active_support"
require "active_support/core_ext" unless defined?(ActiveSupport)

require "precisionable"

require "redness/red"
require "redness/red_list"
require "redness/red_capped_list"
require "redness/red_expire"
require "redness/red_hash"
require "redness/red_json"
require "redness/red_set"
require "redness/red_set_multi"
require "redness/red_set_union"
require "redness/timed_red_set"
