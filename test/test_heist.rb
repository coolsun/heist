require File.dirname(__FILE__) + "/../lib/heist"
require "test/unit"

class HeistTest < Test::Unit::TestCase
  def new_scope!
    @scope = Heist::Runtime::Scope.new
  end
  
  def test_numbers
    assert_equal 486, Heist.eval("486")
  end
  
  def test_arithmetic
    assert_equal 486,  Heist.eval("(+ 137 349)")
    assert_equal 666,  Heist.eval("(- 1000 334)")
    assert_equal 495,  Heist.eval("(* 5 99)")
    assert_equal 2,    Heist.eval("(/ 10 5)")
    assert_equal 12.7, Heist.eval("(+ 2.7 10)")
    assert_equal 75,   Heist.eval("(+ 21 35 12 7)")
    assert_equal 1200, Heist.eval("(* 25 4 12)")
    assert_equal 19,   Heist.eval("(+ (* 3 5) (- 10 6))")
    assert_equal 57,   Heist.eval("(+ (* 3 (+ (* 2 4) (+ 3 5))) (+ (- 10 7) 6))")
  end
  
  def test_define_values
    new_scope!
    @scope.eval("(define size 2)")
    assert_equal 2, @scope.eval("size")
    
    @scope.eval <<-CODE
      (define pi 3.14159)
      (define radius 10)
    CODE
    assert_equal 314.159, @scope.eval("(* pi (* radius radius))")
    
    @scope.eval("(define circumference (* 2 pi radius))")
    assert_equal 62.8318, @scope.eval("circumference")
  end
  
  def test_define_functions
    new_scope!
    @scope.eval("(define (square x) (* x x))")
    assert_equal 441, @scope.eval("(square 21)")
    assert_equal 49,  @scope.eval("(square (+ 2 5))")
    assert_equal 81,  @scope.eval("(square (square 3))")
    
    @scope.eval <<-CODE
      (define (sum-of-squares x y)
        (+ (square x) (square y)))
    CODE
    assert_equal 25, @scope.eval("(sum-of-squares 3 4)")
    
    @scope.eval <<-CODE
      (define (f a)
        (sum-of-squares (+ a 1) (* a 2)))
    CODE
    assert_equal 136, @scope.eval("(f 5)")
    assert_equal @scope.eval("(f 5)"),
        @scope.eval("((lambda (a) ((lambda (x y) (+ (square x) (square y))) (+ a 1) (* a 2))) 5)")
  end
end

