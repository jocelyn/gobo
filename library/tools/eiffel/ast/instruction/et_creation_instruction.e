indexing

	description:

		"Eiffel creation instructions"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 1999-2002, Eric Bezault and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ET_CREATION_INSTRUCTION

inherit

	ET_INSTRUCTION

feature -- Access

	target: ET_WRITABLE
			-- Target of the creation

	type: ET_TYPE is
			-- Creation type
		deferred
		end

	creation_call: ET_QUALIFIED_CALL
			-- Call to creation procedure

	arguments: ET_ACTUAL_ARGUMENT_LIST is
			-- Arguments of creation call
		do
			if creation_call /= Void then
				Result := creation_call.arguments
			end
		end
		
invariant

	target_not_void: target /= Void

end
