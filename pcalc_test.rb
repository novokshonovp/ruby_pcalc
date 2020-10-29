require "test/unit"
require_relative './pcalc'

class PolandCalculatorTest < Test::Unit::TestCase

  def test_first
    pc = PolandCalculator.new do
      decimal_selector :d_0
    end
    assert_equal 15, pc.calc('1 2 + 4 * 3.1 +'), "1st reference result"
  end

  def test_second
    pc = PolandCalculator.new do
      functions do
        f_x -> (x) { 1.0 / x }
      end
      decimal_selector :d_2
    end
    assert_equal 0.14, pc.calc('1 2 5 + * f_x'), "2nd reference result"
  end

  def test_third
    pc = PolandCalculator.new do
      functions do
        f_x -> (x) { 1.0 / x }
        f_my_function -> (x) { 0.99 + x }
      end
      decimal_selector :d_2
    end
    assert_equal 2.33, pc.calc('1 1 + f_my_function f_x 2 +'), "3rd reference result"
  end

  def test_unsupported_selector
    pc = PolandCalculator.new do
      decimal_selector :d_5
    end
    assert_raise(UnsupportedDecimalSelector) { pc.calc('1 1 +') }
  end

  def test_insufficient_arguments_op
    pc = PolandCalculator.new do
      decimal_selector :d_2
    end
    assert_raise(InsufficientArguments) { pc.calc('1 +') }
  end

  def test_insufficient_arguments_fn
    pc = PolandCalculator.new do
      functions do
        f_x -> (x) { 1.0 / x }
      end
      decimal_selector :d_2
    end
    assert_raise(InsufficientArguments) { pc.calc('f_x') }
  end

  def test_invalid_token
    pc = PolandCalculator.new do
      decimal_selector :d_2
    end
    assert_raise(InvalidToken) { pc.calc('1 2 @') }
    assert_raise(InvalidToken) { pc.calc('x y +') }
  end


  def test_invalid_expression
    pc = PolandCalculator.new do
      decimal_selector :d_2
    end
    assert_raise(InvalidExpression) { pc.calc('1 2 3 +') }
  end

end
