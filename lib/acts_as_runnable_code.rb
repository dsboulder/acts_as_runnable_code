# ActsAsRunnableCode
require "rubygems"
require "acts_as_wrapped_class"

module ActsAsRunnableCode
  VERSION="1.0.2"
  module InstanceMethods
    # Run the user's code in the context of a toplevel_object
    # The toplevel_object will be automatically wrapped and copied into the sandbox
    def run_code(toplevel_object = nil, options = {})
      options[:timeout] ||= self.class.runnable_code_options[:timeout] 
      s = sandbox
      if toplevel_object
        s.set(:toplevel, ActsAsWrappedClass::WrapperFinder.find_wrapper_for(toplevel_object))
        s.set(:code, self.send(self.class.source_code_field))
        result = s.eval("eval(code, toplevel.send(:binding))", options)
      else
        s.set(:code, self.send(self.class.source_code_field))        
        result = s.eval("eval(code)", options)
      end
      result.class.respond_to?(:wrapper_class?) && result.class.wrapper_class? ? result._wrapped_object : result
    end
    
    # Get the sandbox used to eval user code for this class
    # Makes sandbox references to the wrapper classes
    def sandbox
      return self.class.instance_variable_get("@sandbox") if self.class.instance_variables.include?("@sandbox")
      
      if self.class.runnable_code_options[:unsafe_sandbox]
        s = Sandbox.new
      else
        s = Sandbox.safe
      end
      
      classes = self.class.runnable_code_options[:classes] || ActsAsWrappedClass::WRAPPED_CLASSES
      
      classes.each do |c|
        name = "#{c}Wrapper"
        s.ref eval(name)
      end
      
      self.class.instance_variable_set("@sandbox", s) if self.class.runnable_code_options[:singleton_sandbox]
      s
    end
  end
  
  module ClassMethods
    attr :runnable_code_options, true
    
    def source_code_field
      (@runnable_code_options[:code_field] || "code").to_sym
    end
    
    def runnable_code?
      true
    end

    # a list of runnable classes in the format ["SomeClassWrapper", "OtherClassWraper"]
    def runnable_classes
      (runnable_code_options[:classes] || ActsAsWrappedClass::WRAPPED_CLASSES).collect { |c| "#{c}Wrapper" }
    end
        
    # a list of runnable methods in the format {"SomeClassWrapper" => ["method_a", "method_b"], "OtherClassWraper" => ["method_c", "method_d"]]
    def runnable_methods
      meths = {}
      runnable_classes.each { |c|
        klass = eval("::#{c}")
        meths[c.to_s] ||= []
        meths[c.to_s] += klass.allowed_methods if klass.respond_to?(:allowed_methods)
      }
      meths
    end
    
    # same as runnable methods but excludes all the methods of +Object
    def runnable_methods_no_object
      newv = {}
      runnable_methods.each do |k,v|
        newv[k] = v - Object.public_instance_methods
      end
      newv
    end
  end
  
  # Mark this class as containing a method which returns user generated code.
  # Options
  # * options[:classes] - contains a list of classes (unwrapped names) you want accessible in the sandbox. Default: all classes loaded and marked with acts_as_wrapped_class
  # * options[:singleton_sandbox] - only create 1 sandbox, which is always used whenever code is evaled (faster), rather than a new sandbox each time.  Default: false
  # * options[:unsafe_sandbox] - create sandbox using Sandbox.new rather than Sandbox.safe.  Default: false
  # * options[:timeout] - timeout in seconds before aborting user code.  Default: none
  # * options[:code_field] - the name of the method to call to get the user code for running.  Default: :code
  def acts_as_runnable_code(options = {})
    self.send(:include, InstanceMethods)
    self.send(:extend,ClassMethods)
    
    self.runnable_code_options = options
  end
  
  def runnable_code?
    false
  end
end

Object.send(:include, ActsAsRunnableCode)
