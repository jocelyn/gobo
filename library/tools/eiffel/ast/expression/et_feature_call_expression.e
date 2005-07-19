indexing

	description:

		"Eiffel feature call expressions"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2005, Eric Bezault and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ET_FEATURE_CALL_EXPRESSION

inherit

	ET_FEATURE_CALL
		redefine
			is_expression
		end

	ET_EXPRESSION

feature -- Status report

	is_expression: BOOLEAN is True
			-- Is current call an expression?

feature -- Conversion

	as_expression: ET_FEATURE_CALL_EXPRESSION is
			-- `Current' viewed as an expression
		do
			Result := Current
		end

	as_instruction: ET_FEATURE_CALL_INSTRUCTION is
			-- `Current' viewed as an instruction
		do
			check not_instruction: False end
		end

end
