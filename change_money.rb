require 'test/unit'
require 'active_support/inflector'
require 'active_support/core_ext/array/conversions'

class Money
    def initialize(value, name, amount)
        @value = Float(value)  
        @name = String(name)  
        @amount = Integer(amount)
    end 
    
    attr_accessor :value, :name, :amount
    
    def display  
        if amount == 1
            print "#{@amount} #{@name}"
        else
            print "#{@amount} #{@name.pluralize}"
        end
    end 

end

def initialize_all_money()
    hundred_dollar = Money.new(100, "100 dollar bill", 0)
    fifty_dollar = Money.new(50, "50 dollar bill", 0)
    twenty_dollar = Money.new(20, "20 dollar bill", 0)
    ten_dollar = Money.new(10, "10 dollar bill", 0)
    five_dollar = Money.new(5, "5 dollar bill", 0)
    dollar = Money.new(1, "1 dollar bill", 0)
    quarter = Money.new(0.25, "quarter", 0)
    dime = Money.new(0.10, "dime", 0)
    nickel = Money.new(0.05, "nickel", 0)
    penny = Money.new(0.01, "penny", 0)
    all_money = [hundred_dollar, fifty_dollar, twenty_dollar, ten_dollar, five_dollar, dollar, quarter, dime, nickel, penny]
end

def change_money(value)
    if !value.is_a? Numeric
        puts "Input must be a numeric number"
        return "Input must be a numeric number"
    end
    if value <= 0 || value > 999999999999999.93
        puts "Input must be between 0 to 999999999999999.00"
        return "Input must be between 0 to 999999999999999.00"
    end
    if value.to_s !~ /^\d+\.?\d{0,2}$/
        puts "Input format is invalid"
        return "Input format is invalid"
    end
    all_money = initialize_all_money()
    while value > 0 do
        all_money.each do |money|
            if value >= money.value
                money.amount = (value/money.value).floor
                value -= money.value*money.amount
                value = value.round(2)
            end
        end
    end
    print_change_money(all_money.select { |money| money.amount > 0 })
    return all_money
end

def print_change_money(all_money)
    if all_money.size > 0
        print "Your change is "
        to_sentence(all_money) # can modify and use to_sentence from active_support
    end
end

def to_sentence(array_to_print)
    if array_to_print.size == 0
        return
    elsif array_to_print.size == 1
        puts "#{array_to_print.first.amount} #{array_to_print.first.name}."
    else
        array_to_print.each do |element|
            if element != array_to_print.last
                element.display
                print " ,"
            else
                print "and "
                element.display
                puts "."
            end
        end
    end
end

class ChangeMoneyTest < Test::Unit::TestCase
  def mock_all_money(hundred_dollar_amount, fifty_dollar_amount, twenty_dollar_amount, ten_dollar_amount, five_dollar_amount, dollar_amount, quarter_amount, dime_amount, nickel_amount, penny_amount)
      hundred_dollar = Money.new(100, "100 dollar bill", hundred_dollar_amount)
      fifty_dollar = Money.new(50, "50 dollar bill", fifty_dollar_amount)
      twenty_dollar = Money.new(20, "20 dollar bill", twenty_dollar_amount)
      ten_dollar = Money.new(10, "10 dollar bill", ten_dollar_amount)
      five_dollar = Money.new(5, "5 dollar bill", five_dollar_amount)
      dollar = Money.new(1, "1 dollar bill", dollar_amount)
      quarter = Money.new(0.25, "quarter", quarter_amount)
      dime = Money.new(0.10, "dime", dime_amount)
      nickel = Money.new(0.05, "nickel", nickel_amount)
      penny = Money.new(0.01, "penny", penny_amount)
      all_money = [hundred_dollar, fifty_dollar, twenty_dollar, ten_dollar, five_dollar, dollar, quarter, dime, nickel, penny]
  end

  def test_exchange_string
    assert(change_money("100") == "Input must be a numeric number", "Failed")
  end

  def test_exchange_zero
    assert(change_money(0) == "Input must be between 0 to 999999999999999.00", "Failed")
  end
  
  def test_exchange_zero_with_two_decimal_points
    assert(change_money(0.00) == "Input must be between 0 to 999999999999999.00", "Failed")
  end
  
  def test_exchange_minus_number
    assert(change_money(-20) == "Input must be between 0 to 999999999999999.00", "Failed")
  end

  def test_exchange_10
    expected = mock_all_money(0,0,0,1,0,0,0,0,0,0)
    result = change_money(10)
    for i in 0..10 do
      assert(result[i].amount == expected[i].amount, "Failed")
    end
  end
  
  def test_exchange_ten_with_many_decimal_points
    expected = mock_all_money(0,0,0,1,0,0,0,0,0,0)
    result = change_money(10.00000)
    for i in 0..10 do
      assert(result[i].amount == expected[i].amount, "Failed")
    end
  end
  
  def test_exchange_100
    expected = mock_all_money(1,0,0,0,0,0,0,0,0,0)
    result = change_money(100)
    for i in 0..10 do
      assert(result[i].amount == expected[i].amount, "Failed")
    end
  end
  
  def test_exchange_999_99
    expected = mock_all_money(9,1,2,0,1,4,3,2,0,4)
    result = change_money(999.99)
    for i in 0..10 do
      assert(result[i].amount == expected[i].amount, "Failed")
    end
  end  
  
  def test_exchange_1110_29
    expected = mock_all_money(11,0,0,1,0,0,1,0,0,4)
    result = change_money(1110.29)
    for i in 0..10 do
      assert(result[i].amount == expected[i].amount, "Failed")
    end
  end
  
  def test_exchange_0_01000
    expected = mock_all_money(0,0,0,0,0,0,0,0,0,1)
    result = change_money(0.01000)
    for i in 0..10 do
      assert(result[i].amount == expected[i].amount, "Failed")
    end
  end
  
  def test_exchange_0_001
    assert(change_money(0.001) == "Input format is invalid", "Failed")
  end
  
  def test_exchange_0001
    expected = mock_all_money(0,0,0,0,0,1,0,0,0,0)
    result = change_money(0001)
    for i in 0..10 do
      assert(result[i].amount == expected[i].amount, "Failed")
    end
  end
  
  def test_exchange_100000000000000_00
    expected = mock_all_money(1000000000000,0,0,0,0,0,0,0,0,0)
    result = change_money(100000000000000.00)
    for i in 0..10 do
      assert(result[i].amount == expected[i].amount, "Failed")
    end
  end
  
  def test_exchange_999999999999999_00
    expected = mock_all_money(9999999999999,1,2,0,1,4,0,0,0,0)
    result = change_money(999999999999999.00)
    for i in 0..10 do
      assert(result[i].amount == expected[i].amount, "Failed")
    end
  end
  
  def test_exchange_999999999999999_99
    assert(change_money(999999999999999.99) == "Input must be between 0 to 999999999999999.00", "Failed")
  end
end
