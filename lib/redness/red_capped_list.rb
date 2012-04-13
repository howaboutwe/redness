class RedCappedList
  attr_accessor :key, :cap
  def initialize(key, cap)
    self.key = key
    self.cap = cap
  end

  def get
    RedList.get(key)
  end

  def add(value)
    RedList.add(key, value)
    RedList.trim_to(key, cap)
  end
end
