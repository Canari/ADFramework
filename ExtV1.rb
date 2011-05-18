

# Global Type Predicates

def bool?(obj)
   (obj == true) or (obj == false) 
end

def int?(obj)
    obj.is_a?(Integer)
end

def int_zero?(obj)
	int?(obj)and (obj == 0)
end

def int_non_zero?(obj)
	not (zero_int?(obj))
end

def int_pos?(obj)
	int?(obj) and (obj > 0)
end

def int_neg?(obj)
	int?(obj) and (obj < 0)
end
	
def nat?(obj)  
	int?(obj) and (obj >= 0)
end

def float?(obj) 
    obj.is_a?(Float)
end

def numeric?(obj)
	obj.is_a?(Numeric)
end

def string?(obj)
	obj.is_a?(String)
end

def symbol?(obj)
	obj.is_a?(Symbol)
end

def text?(obj)
	string?(obj) or symbol?(obj)
end


def int_range?(obj)
	range?(obj) and int?(obj.first) and int?(obj.last)
end

def array?(obj)
	obj.is_a?(Array)
end

def list?(obj)
	obj.is_a?(List)
end

def seq?(obj)
	array?(obj) or list?(obj)
end

CHECK_ARG_ERROR_CLASS      = ArgumentError
CHECK_VIOLATION_CLASS      = RuntimeError
CHECK_PRE_VIOLATION_CLASS  = RuntimeError
CHECK_POST_VIOLATION_CLASS = RuntimeError

# checks precondition of checks

def check_assertion_and_message(assertion,failure_message)
	if not bool?(assertion)then 
		raise(CHECK_ARG_ERROR_CLASS,"Assertion expression must evaluate to a boolean, but is #{assertion.class.name.to_s}: #{assertion.to_s}")
	end
	if not text?(failure_message)then 
		raise(CHECK_ARG_ERROR_CLASS,"Failure message must evaluate to a text, but is #{failure_message.class.name.to_s}: #{failure_message.to_s}")
	end	
end

def check_pre(assertion, failure_message = '')
	check_assertion_and_message(assertion,failure_message)
	if not assertion then raise(CHECK_PRE_VIOLATION_CLASS, "Precondition violated " + failure_message.to_s) end
end



def check(value,assertion, failure_message = '')
	check_assertion_and_message(assertion,failure_message)
	if not assertion then raise(RuntimeError,"Assertion violated " + failure_message.to_s) end
end

def check_post(result,assertion, failure_message = '')
	check_assertion_and_message(assertion,failure_message)
	if not assertion then raise(RuntimeError, "Postcondition violated " + failure_message.to_s) end
	result
end


class Range
	def rest()
		check_pre(int_range?(obj)) 
		(self.first.succ)..(self.last)
	end
	
	def empty?()
		self.first > self.last
	end
	
	def size()
		check_pre(int_range?(obj)) 
		self.empty? ? 0 : self.last - self.first + 1
	end
end

