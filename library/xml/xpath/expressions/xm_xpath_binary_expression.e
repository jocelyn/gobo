indexing

	description:

		"XPath Binary Expressions"

	library: "Gobo Eiffel XPath Library"
	copyright: "Copyright (c) 2004, Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class XM_XPATH_BINARY_EXPRESSION

inherit

	XM_XPATH_COMPUTED_EXPRESSION
		redefine
			promote, simplify, sub_expressions, same_expression
		end

	XM_XPATH_TOKENS

feature {NONE} -- Initialization

	make (operand_1: XM_XPATH_EXPRESSION; token: INTEGER; operand_2: XM_XPATH_EXPRESSION) is
			-- Establish invariant
		require
			operand_1_not_void: operand_1 /= Void
			operand_2_not_void: operand_2 /= Void
			-- TODO: is_binary_op?
		do
			operator := token
			create operands.make (1,2)
			operands.put (operand_1, 1)
			operands.put (operand_2, 2)
		ensure
			operator_set: operator = token
			operand_1_set: operands /= Void and then operands.item (1).same_expression (operand_1)
			operand_2_set: operands.item (2).same_expression (operand_2)
		end

feature -- Access

	sub_expressions: DS_ARRAYED_LIST [XM_XPATH_EXPRESSION] is
			-- Immediate sub-expressions of `Current'
		do
			create Result.make (2)
			Result.set_equality_tester (expression_tester)
			Result.put (operands.item (1), 1)
			Result.put (operands.item (2), 2)
		end


feature -- Status report

	is_commutative (oper: INTEGER): BOOLEAN is
			-- Is `oper' a commutative operator?
		do
			Result := oper = And_token
				or else oper = Or_token
				or else oper = Union_token
				or else oper = Intersect_token
				or else oper = Plus_token
				or else oper = Multiply_token
				or else oper = Equals_token
				or else oper = Fortran_equal_token
				or else oper = Not_equal_token
				or else oper = Fortran_not_equal_token
		end
		
feature -- Comparison

	same_expression (other: XM_XPATH_EXPRESSION): BOOLEAN is
			-- Are `Current' and `other' the same expression?
		local
			other_binary: XM_XPATH_BINARY_EXPRESSION
		do
			other_binary ?= other
			if other_binary /= Void then
				if operator = other_binary.operator then
					if operands.item (1).same_expression (other_binary.operands.item (1))
						and then operands.item (2).same_expression ( other_binary.operands.item (2)) then
						Result := True
					elseif is_commutative (operator) and then
						operands.item (1).same_expression ( other_binary.operands.item (2))
							and then operands.item (2).same_expression ( other_binary.operands.item (1)) then
							Result := True
							-- TODO: recognize associative operators (A|(B|C)) == ((A|B)|C)
							--    and inverse operators (A<B) == (B>A)
					end
				end
			end
		end
feature -- Analysis

	simplify: XM_XPATH_EXPRESSION is
			-- Simplify an expression;
			-- This performs any static optimization 
			--  (by rewriting the expression as a different expression);
		local
			binary_expression: XM_XPATH_BINARY_EXPRESSION
		do
			binary_expression := clone (Current)
			binary_expression.operands.put (operands.item (1).simplify, 1)
			binary_expression.operands.put (operands.item (2).simplify, 2)
			Result := binary_expression
		end

	analyze (env: XM_XPATH_STATIC_CONTEXT): XM_XPATH_EXPRESSION is
			-- Perform static analysis of an expression and its subexpressions;		
			-- This checks statically that the operands of the expression have the correct type;
			-- If necessary it generates code to do run-time type checking or type conversion;
			-- A static type error is reported only if execution cannot possibly succeed, that
			-- is, if a run-time type error is inevitable. The call may return a modified form of the expression;
			-- This routine is called after all references to functions and variables have been resolved
			-- to the declaration of the function or variable. However, the types of such functions and
			-- variables will only be accurately known if they have been explicitly declared
		do
			-- TODO: requires expression tool, and dynamic error handling
		end

	
	promote (offer: XM_XPATH_PROMOTION_OFFER): XM_XPATH_EXPRESSION is
			-- Offer promotion for this subexpression
			-- The offer will be accepted if the subexpression is not dependent on
			-- the factors (e.g. the context item) identified in the PromotionOffer.
			-- By default the offer is not accepted - this is appropriate in the case of simple expressions
			-- such as constant values and variable references where promotion would give no performance
			-- advantage. This method is always called at compile time.
		do
			-- TODO: requires promotion offer features
		end

feature {XM_XPATH_BINARY_EXPRESSION} -- Implementation

	operands: ARRAY [XM_XPATH_EXPRESSION]
			-- The two operands

	operator: INTEGER
			-- The operation, as a token number

feature {NONE} -- Implementation

	compute_cardinality is
			-- Compute cardinality.
		do
			create cardinalities.make (1, 3) -- All False
			cardinalities.put (True, 1)
			cardinalities.put (True, 2)
		end

invariant

	two_operands: operands /= Void and then operands.count = 2
	static_type_error: is_static_type_error implies internal_last_static_type_error /= Void and then internal_last_static_type_error.count > 0

end
	