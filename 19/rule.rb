class BasicRule
  attr_reader :char

  def initialize(char)
    @char = char
  end

  def link_rules(_); end

  def match(str)
    return false unless str[0] == char

    [true, str[1..-1]]
  end

  def all_matching_strings
    [char]
  end
end

class Rule
  attr_reader :sub_rule_strings_1, :sub_rule_strings_2, :sub_rules_1, :sub_rules_2

  def initialize(sub_rule_strings_1, sub_rule_strings_2 = nil)
    @sub_rule_strings_1 = sub_rule_strings_1
    @sub_rule_strings_2 = sub_rule_strings_2
  end

  def link_rules(rule_map)
    @sub_rules_1 = sub_rule_strings_1.map { |rule| rule_map[rule] }
    @sub_rules_2 = sub_rule_strings_2.map { |rule| rule_map[rule] } unless sub_rule_strings_2.nil?
  end

  def all_matching_strings
    raise RuntimeError if sub_rules_1.any?(self) || sub_rules_2&.any?(self)

    sub_rules_1.map do |rule|
      matches = rule.all_matching_strings

    end


    [sub_rules_1.map(&:all_matching_strings).join('')] + [(sub_rules_2&.map(&:all_matching_strings) || []).join('')]
  end

  def match(str)
    remaining_str = str.dup
    matches = sub_rules_1.all? do |rule|
      result, remaining_str = rule.match(remaining_str)
      result
    end

    # return [matches, remaining_str] if matches || sub_rules_2.nil?
    return [matches, remaining_str] if sub_rules_2.nil?

    remaining_str_1 = remaining_str.dup

    remaining_str = str.dup
    matches_2 = sub_rules_2.all? do |rule|
      result, remaining_str = rule.match(remaining_str)
      result
    end

    if matches && matches_2
      # puts "Both branches match!"
      # puts "Sub-rules: #{sub_rule_strings_1} | #{sub_rule_strings_2}"
      # puts "Remaining strings: #{remaining_str_1} | #{remaining_str}"
      # Return both matches
      return [true, [remaining_str, remaining_str_1]]
    end

    if matches
      [matches, remaining_str_1]
    elsif matches_2
      [matches_2, remaining_str]
    else
      false
    end

    # [matches, remaining_str]
  end
end
