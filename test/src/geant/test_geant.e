indexing

	description:

		"Test 'geant'"

	author:     "Sven Ehrke <sven.ehrke@web.de>"
	copyright:  "Copyright (c) 2002, Sven Ehrke and others"
	license:    "Eiffel Forum Freeware License v1 (see forum.txt)"
	date:       "$Date$"
	revision:   "$Revision$"

deferred class TEST_GEANT

inherit

	TOOL_TEST_CASE

feature -- Access

	tool: STRING is "geant"
			-- Tool name

feature -- Test

	test_geant is
			-- Test 'geant'.
		do
			compile_tool
		end

end -- class TEST_GEANT
