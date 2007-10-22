require "sandbox"
require 'test/unit'
require File.dirname(__FILE__) + "/../lib/acts_as_runnable_code"

class SampleClass
  acts_as_runnable_code 
  
  def code
    "'hello world'"
  end
end

class OtherClass
  acts_as_runnable_code :code_field => :data2, :unsafe_sandbox => true, :singleton_sandbox => true
  
  attr :code, true
  
  def data2
    @code || "value"
  end
end

class WrappedClass
  acts_as_wrapped_class
  
  attr_reader :value  
  
  def initialize(value)
    @value = value
  end
  
  def other
    WrappedClass.new(rand)
  end
end

class ActsAsRunnableCodeTest < Test::Unit::TestCase
  def test_source_code_field
    assert_equal :code, SampleClass.source_code_field
    assert_equal :data2, OtherClass.source_code_field
  end
  
  def test_has_run_code
    assert SampleClass.new.respond_to?(:run_code)
    assert OtherClass.new.respond_to?(:run_code)
  end
  
  def test_has_sandbox
    assert SampleClass.new.respond_to?(:sandbox)
    assert OtherClass.new.respond_to?(:sandbox)
  end
  
  def test_sandbox
    s = SampleClass.new.sandbox
    assert s.is_a?(Sandbox::Safe)
    
    s = OtherClass.new.sandbox
    assert s.is_a?(Sandbox::Full)
  end
  
  def test_singleton_sandbox
    s1 = OtherClass.new.sandbox
    s2 = OtherClass.new.sandbox
    assert s1 == s2
    s1 = SampleClass.new.sandbox
    s2 = SampleClass.new.sandbox
    assert s1 != s2
  end
  
  def test_run_code
    w = WrappedClass.new(5.5)
    assert_equal "hello world", SampleClass.new.run_code
    assert_equal 5.5, OtherClass.new.run_code(w)
    
    oc = OtherClass.new
    oc.code = "other"
    assert_equal WrappedClass, oc.run_code(w).class
  end
end
