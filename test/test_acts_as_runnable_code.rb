require "sandbox"
require 'test/unit'
require File.dirname(__FILE__) + "/../lib/acts_as_runnable_code"

class SampleClass
  acts_as_runnable_code 
  
  attr_writer :code
  
  def code
    @code || "'hello world'"
  end
  
end

class WrappedClass2
  acts_as_wrapped_class :methods => [:safeone]
  
  def safeone
    777
  end
  
  def unsafeone
    666
  end  
end

class OtherClass
  acts_as_runnable_code :classes => ["WrappedClass2"], :code_field => :data2, :unsafe_sandbox => true, :singleton_sandbox => true
  
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
    assert_equal "hello world", SampleClass.new.run_code

    w = WrappedClass.new(5.5)    
    sc = SampleClass.new
    sc.code = "value"
    assert_equal 5.5, sc.run_code(w)
    
    sc = SampleClass.new
    sc.code = "other"
    assert_equal WrappedClass, sc.run_code(w).class
  
    w = WrappedClass2.new
    oc = OtherClass.new
    oc.code = "safeone"
    assert_equal 777, oc.run_code(w)
  end
  
  def test_arunnable_classes
    assert_equal 2, SampleClass.runnable_classes.length
    assert_equal ["WrappedClass2Wrapper"], OtherClass.runnable_classes

    assert_equal OtherClass.runnable_methods, {"WrappedClass2Wrapper" => ["safeone"]}
    assert_contents_same ["other", "value", "safeone"], SampleClass.runnable_methods_no_object.values.flatten.uniq
  end
  
  def assert_contents_same(array1, array2)
    assert_equal array1.length, array2.length, "#{array1.inspect} != #{array2.inspect}"
    array1.each { |a| assert array2.include?(a), "#{array2.inspect} does not contain #{a.inspect}" }
  end  
end
