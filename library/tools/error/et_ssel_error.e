indexing

	description:

		"SSEL errors which report that empty lines are not %
		%allowed in middle of multi-line manifest strings."

	code:       "SSEL: Syntax String Empty Line"

	library:    "Gobo Eiffel Tools Library"
	author:     "Eric Bezault <ericb@gobosoft.com>"
	copyright:  "Copyright (c) 1999, Eric Bezault and others"
	license:    "Eiffel Forum Freeware License v1 (see forum.txt)"
	date:       "$Date$"
	revision:   "$Revision$"

class ET_SSEL_ERROR

inherit

	ET_SYNTAX_ERROR

creation

	make

feature -- Access

	default_template: STRING is "SSEL: empty lines not allowed in middle %
		%of multi-line manifest strings.%N$1%N"
			-- Default template used to built the error message

	code: STRING is "SSEL"
			-- Error code

end -- class ET_SSEL_ERROR
