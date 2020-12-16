def extended_gcd(a, b)
  old_r, r = [a, b]
  old_s, s = [1, 0]
  old_t, t = [0, 1]

  while r != 0
    quotient = old_r / r
    old_r, r = [r, old_r - quotient * r]
    old_s, s = [s, old_s - quotient * s]
    old_t, t = [t, old_t - quotient * t]
  end

  [old_s, old_t, old_r]
end

