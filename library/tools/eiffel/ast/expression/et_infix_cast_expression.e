indexing

	description:

		"Eiffel expressions changing the target type of infix expressions"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2004, Eric Bezault and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ET_INFIX_CAST_EXPRESSION

inherit

	ET_EXPRESSION

creation

	make

feature {NONE} -- Initialization

	make (e: like expression; a_type: like type) is
			-- Create a new infix cast expression.
		require
			e_not_void: e /= Void
			a_type_not_void: a_type /= Void
		do
			expression := e
			type := a_type
		ensure
			expression_set: expression = e
			type_set: type = a_type
		end

feature -- Access

	expression: ET_EXPRESSION
			-- Expression to be casted

	type: ET_TYPE
			-- Cast type

	position: ET_POSITION is
			-- Position of first character of
			-- current node in source code
		do
			Result := expression.position
		end

	break: ET_BREAK is
			-- Break which appears just after current node
		do
			Result := expression.break
		end

feature -- Processing

	process (a_processor: ET_AST_PROCESSOR) is
			-- Process current node.
		do
			a_processor.process_infix_cast_expression (Current)
		end

invariant

	expression_not_void: expression /= Void
	type_not_void: type /= Void

end