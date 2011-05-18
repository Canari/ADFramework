# EXTENSION FOR OO V1
# ===================


# Michael Boehm, 21.11.10


require 'Set'
require 'Singleton'


# GLOBAL FUNCTIONS FOR ASSERTION CHECKING
# =======================================

# All functions for assertion checking are based on this principle:  
# they consume 
#     a value expression (or|and) 
#     a logical expression and 
#	  an optional message 
# first the arguments (the precondition) of the check functions are checked, 
# in case of failure a special error is raised to avoid endless recursion
# in case of success, the specified value is returned 

# PRECONDITION CHECKS

# In the ubitiquios case of precondition checks, the value argument is omitted, to allow a compact notation:

# def func(...)
#     check_pre(assertion)
#     expression        
# end

# 
# INVARIANT CHECKS FOR OBJECTS

# the invariant check assumes, that the checked value implements a predicate method invariant?
# if the check is successful, the value is returned

# def func(...)
#     check_inv(self)
#     res = ...
#     check_inv(res)     
# end

# POSTCONDITION CHECKS

# postcondition checks can be written as last line 

# def func(...)
#     result = ...
#     check_post(result,assertion) 
# end


CHECK_ARG_ERROR_CLASS      = ArgumentError   
CHECK_VIOLATION_CLASS      = RuntimeError
CHECK_PRE_VIOLATION_CLASS  = RuntimeError
CHECK_POST_VIOLATION_CLASS = RuntimeError
CHECK_INV_VIOLATION_CLASS  = RuntimeError
CHECK_ABSTRACT_ERROR_CLASS = NotImplementedError 


# check precondition of checks; (Bool * Text) -> (NilClass | Raise)

def check_assertion_args(assertion,failure_message)
	if not assertion.bool? then 
		raise(CHECK_ARG_ERROR_CLASS,"Assertion expression must evaluate to a boolean, but is (Class: #{assertion.class.name.to_s} Value: #{assertion})")
	end
	if not failure_message.text? then 
		raise(CHECK_ARG_ERROR_CLASS,"Failure message must evaluate to a text, but is (Class: #{failure_message.class.name.to_s}: Value: #{failure_message.to_s})")
	end	
end


# check assertion, return value if assertion is true, 
# else raise exception of class error_class with message (mess_prefix + opt_fail_mess)
# (Any * Bool * Class * Text * Text) -> (Any | Raise)

def check_assertion(value,assertion,error_class,mess_prefix,opt_fail_mess = '')
	check_assertion_args(assertion,opt_fail_mess)
	if not assertion then 
		raise(error_class, "#{mess_prefix} #{opt_fail_mess == ''? '': ": "} #{opt_fail_mess}") 
	else value
	end	
end


# check value assertion, return value if assertion is true else raise specified exception;
# (Any * Bool * Text) -> (Any | Raise)

def check(value,assertion, failure_message = '')
	check_assertion(value,assertion,CHECK_VIOLATION_CLASS,'Assertion violated',opt_failure_message)
end

# check postcondition, return value if assertion is true else raise specified Exception
# (Any * Bool * Text) -> (Any | Raise)

def check_post(value,assertion, failure_message = '')
	check_assertion(value,assertion,CHECK_POST_VIOLATION_CLASS,'Precondition violated',opt_failure_message)
end


# check precondition; (Bool * Text) -> ( NilClass | Raise)

def check_pre(assertion,opt_failure_message = '')
	check_assertion(nil,assertion,CHECK_PRE_VIOLATION_CLASS,'Precondition violated',opt_failure_message)
end



# check invariant, return value if invariant is true else raise specified exception
# (Any * Text) -> (Any | Raise)


def check_inv(value,opt_failure_message = '')
 check_assertion(value,value.invariant?,CHECK_INV_VIOLATION_CLASS,'Class Invariant violated',opt_failure_message)
end



# EXTENSIONS TO OBJECT


# ABSTRACT METHODS

# a mechanism for explicit abstract methods is missing in Ruby
# with this extension abstract methods can be defined

#class MyAbstractClass
#	def to_a() abstract end
#end

# MORE NATURAL ELEMENT-OF PREDICATE

# instead of 

#    collection.include?(elem), the more natural (and shorter)

#    elem.in?(collection) can be used

# COMPACT DEFINITION OF HOOK-METHODS IN OBJECT FOR TYPE-PREDICATES

# type predicates should be compact and defined for all objects (total on Object) 
# this requires a large number of simple hook-methods in class object like

# class Object
#    def nat?() false end
# end 

# this is simplified with an alias-mechanism (see example below)


class Object
	
    def self.def_false(*args)
	 if not args.all?{|arg| arg.is_a?(Symbol)} then raise(CHECK_ARG_ERROR_CLASS, 'Argument is not a symbol') end 
	 args.each{|arg| alias_method arg, :false_}
	end
	
	def false_() false end
   
   def abstract
   	check_assertion(nil,false,CHECK_ABSTRACT_ERROR_CLASS,"(Class:#{self.class.name}): abstract method not implemented",'')
   end
   
   def in?(obj) obj.include?(self) end
 
end  


# DEFINE FALSE TYPE PREDICATE HOOKS


Object.def_false(:bool?, 
	             :int?, :nat?, 
                 :int_zero?, :int_non_zero?, :int_pos?, :int_neg?, 
				 :float?, :numeric?, 
                 :string?, :symbol?, :text?, 
				 :range?, :int_range?, 
				 :array?, :seq?, :list?)
				 
	 
# EXTENSIONS TO BASIC CLASSES

class TrueClass
	def bool?() true end
end

class FalseClass
	def bool?() true end
end
			

class Integer
	
   def int?()          true end
 
   def int_zero?()     self == 0 end

   def int_non_zero?() not (self.int_zero?) end

   def int_pos?()      self > 0 end

   def int_neg?()      self < 0 end
	
   def nat?(obj)       self >= 0 end
   
   def min(int)
   	   check_pre(int.int?)
	   self <= int ? self : int
   end
   
   def max(int)
	   check_pre(int.int?)
	   self >= int ? self : int
   end   
   
end

class Float
   def float?() true end
end


class String
   def string?() true end
   def text?()   true end
end

class Symbol
   def symbol?() true end
   def text?()   true end
end



# EXTENSIONS TO RANGE 

# allows to test for integer-ranges and 
# to use integer-ranges like sequences with first, rest, empty?, size

class Range
	
   def seq?() true end
   
   def range?() true end
   
   def int_range?()	first.int? and last.int? end
   
   
   def rest()
	   check_pre(self.int_range?) 
	   (self.first.succ)..(self.last)
   end
	   
   def empty?()
       self.first > self.last
   end
	   
   def size()
       check_pre(self.int_range?) 
	   self.empty? ? 0 : self.last - self.first + 1
   end   
   
   def to_l() List[*(self.to_a)] end
   
end


# EXTENSIONS TO ARRAY 

# allows to use arrays like lists with cons, first, rest, empty?


class Array
	
   def array?() true end
   
   def seq?() true end
   
   def prepend(obj) [obj] + self end
   
   def rest() 
   	check_pre((not (self.empty?)))
	[1..(self.size - 1)]
   end   
   
   def to_l() List[*self] end
   
end


# EXTENSIONS TO SET

class Set
	 
	def set?() true end	
	
	def to_l() List[*(self.to_a)] end
	
end


# GLOBAL FUNCTION CONS

# prepend an element to a sequence; Any * Seq -> Seq

def cons(obj,seq)
  check_pre(seq.seq?,'No cons to non sequences')
  seq.prepend(obj)
end




# DEFINITION OF LINKED LISTS

# these are immutable lists

#    List  =  {EMPTY} | Pair
#
#    Pair  =  Pair[first,rest]: Any x List


# ABSTRACT CLASS LIST

# lists can be written in compact form

# List[1,2,3]  == cons(1,cons(2,cons(3,EMPTY)))

# lists are enumerable



class List
	
	include Enumerable
	
	def self.[](*array)
		  if array.empty? then return EMPTY end
		  accu = EMPTY 
		  array.reverse_each{|elem| accu = cons(elem,accu)}
		  accu
		end	
	
	def seq?() true end
	
	def list?() true end
	
	def empty?() abstract end
	
	def first() abstract end
	
	def rest() abstract end
	   
	def size() abstract end	
	
	def invariant?() abstract end
	
	def prepend(obj)
	    Pair.new(obj,self)
    end	
	
	def each() abstract end
	
	def to_s() "List[#{to_a.join(',')}]" end
	
	def to_set() self.to_a.to_set end

end



# SINGLETON CLASS FOR THE SINGLE EMPTY LIST


require 'Singleton'

class EmptyList < List
	
	include Singleton
	
	def initialize() end
	
	def empty?() true end
	
	def invariant?() true end
	
	def first() 
	  check_pre(false,'List is empty: first not defined')
	end
	
	def rest() 
	  check_pre(false,'List is empty: rest not defined')
	end
	
	def size() 0 end
	
	def each() end
	
		
end


# GLOBAL CONSTANT AND FUNCTION FOR THE EMPTY LIST

EMPTY = EmptyList.instance

def empty() EMPTY end

		

# CLASS FOR THE LIST PAIRS

class Pair < List
	
	attr_reader :first, :rest

	
	def initialize(first,rest)
		check_pre(rest.list?)
		@first, @rest = first,rest
	end
	
	def first() @first end
	
	def rest() @rest end
	
	def invariant?
		rest.list?() and rest.invariant?
	end
	
	def empty?() false end
	
	def size() rest.size + 1 end
	
	def each(&block)
		yield(self.first)
		self.rest.each(&block)
	end
	
end


