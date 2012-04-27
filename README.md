# Redness

Simple data structures for Redis-backed Ruby applications

### Description

Redness extends the redis-rb client library with useful data structures. It provides higher-level access
to Redis than the client library while remaining more composable and minimal than a full-featured ORM.

### Installation
``
  gem install redness
``

### Getting Started
```ruby
  require 'redis'
  require 'json'
  require 'redness'

  $redis = Redis.new

  # RedJSON represents a set of data as JSON
  RedJSON.set("foo", {:foo => ["bar", "baz", "buzz"]})
  #=> "OK"
  RedJSON.get("foo")
  #=> {"foo"=>["bar", "baz", "buzz"]}

  # RedList represents a standard list of data
  RedList.get("users:1:viewers")
  #=> [1]
  RedList.add("users:1:viewers", 2)
  #=> 2
  RedList.get("users:1:viewers")
  #=> [2, 1]
  RedList.add("users:1:viewers", 2)
  #=> 2
  RedList.get("users:1:viewers")
  #=> [2, 2, 1]

  # RedCappedList is a list of data capped at a max length
  capped_list = RedCappedList.new("somekey", 2)
  capped_list.get
  #=> []
  capped_list.add(1)
  #=> "OK"
  capped_list.get
  #=> [1]
  capped_list.add(2)
  #=> "OK"
  capped_list.get
  #=> [2, 1]
  capped_list.add(3)
  #=> "OK"
  capped_list.get
  #=> [3, 2]
```

### TODO

* Ensure all CRUD methods exist for all classes
* Unify interfaces and method names across all classes (and remove the singleton pattern wherever it is found)

### Copyright

Copyright (c) 2012 HowAboutWe. See LICENSE.txt for further details.
