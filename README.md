# Redness

Simple data structures for Redis-backed Ruby applications

### Description

Redness extends the redis-rb client library with useful data structures. It provides higher-level access
to Redis than the client library while remaining more composable and minimal than a full-featured ORM.

### Installation
``
  gem install redness
``

### Playing Around  (read the tests for more examples)
```ruby
  require 'redis'
  require 'json'
  require 'redness'

  $redis = Redis.new

  # RedJSON represents a collection of data as JSON
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

  # RedSet represents a unique set of data
  RedSet.add("myset", 1)
  #=> [1]
  RedSet.add("myset", 1)
  #=> nil
  RedSet.get("myset")
  #=> [1]
  RedSet.add("myset", 2)
  RedSet.get("myset")
  #=> [2, 1]
  RedSet.remove("myset", 2)
  #=> true
  RedSet.get("myset")
  #=> [1]
  # You can specify upper and lower bounds...
  RedSet.get("myset").each { |i| RedSet.remove("myset", i) }
  RedSet.get("myset")
  #=> []
  1.upto(10).each { |i| RedSet.add("myset", i) }
  RedSet.get("myset")
  #=> [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
  RedSet.get("myset", lower: 2, upper: 7)
  #=> [8, 7, 6, 5, 4, 3]
  RedSet.count("myset")
  #=> 10

  # RedHash represents a data collection as a Ruby hash
  red_hash = RedHash.new("test")
  red_hash[:mykey]
  #=> nil
  red_hash[:mykey] = "value"
  red_hash[:mykey]
  #=> "value"
  red_hash.all
  #=> {"mykey"=>"value"}
  red_hash.remove(:mykey)
  red_hash.all
  #=> {}

  # RedSetMulti stores a collection of RedSets
  RedSet.add("razzle", 1)
  RedSet.add("razzle", 2)

  RedSet.add("dazzle", 1)
  RedSet.add("dazzle", 2)
  RedSet.add("dazzle", 3)

  multi_set = RedSetMulti.new(RedSet.get("razzle"), RedSet.get("dazzle"))
  multi_set.get
  #=> [[2, 1], [3, 2, 1]]

  # RedSetUnion represents the union of two or more RedSets
  RedSet.add("key1", 1)
  RedSet.add("key1", 2)
  RedSet.add("key1", 3)

  RedSet.add("key2", 1)
  RedSet.add("key2", 6)
  RedSet.add("key2", 7)

  RedSet.add("key3", 9)

  union = RedSetUnion.new("key1", "key2", "key3")
  union.get
  #=> [7,3,6,2,9,1]

  # TimedRedSet is a RedSet with timestamped data
  TimedRedSet.add("somekey", 1)
  TimedRedSet.add("somekey", 2)

  TimedRedSet.get("somekey")
  #=> [2, 1]

  TimedRedSet.get_with_timestamps("somekey")
  #=> [[2, 2012-05-04 14:29:57 -0400], [1, 2012-05-04 14:29:48 -0400]]
  
  TimedRedSet.since("somekey", 5.minutes.ago, lower: 1, upper: 2)
  #=> [1]

  # RedExpire expires the collection with the
  # provided key in a given number of seconds
  RedList.new("somelist")
  RedList.add("somelist", 0)
  # => 1
  RedList.get("somelist")
  #=> [1]
  # Expire the 'somelist' RedList in 1 second
  RedExpire.set("somelist", 1.second)
  #=> true
  RedList.get("somelist")
  #=> []
```

### TODO

* Ensure all CRUD methods exist for all classes
* Unify interfaces and method names across all classes (and remove the singleton pattern wherever it is found)

### Copyright

Copyright (c) 2012 HowAboutWe. See LICENSE.txt for further details.
