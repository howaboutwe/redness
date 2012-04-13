module Precisionable
  PRECISION = 100000.0

  def self.int_from_float(float)
    (float.to_f * PRECISION).round
  end

  def self.float_from_int(int)
    (int.to_f / PRECISION)
  end
end
