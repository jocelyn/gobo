indexing

	description:

		"XPath evaluation context for an expression"

	library: "Gobo Eiffel XPath Library"
	copyright: "Copyright (c) 2004, Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class XM_XPATH_CONTEXT

creation

	make

feature {NONE} -- Initialization

	make (a_controller: XM_XPATH_CONTROLLER) is
			-- Establish invariant.
		require
			controller_not_void: a_controller /= Void
		do
			controller := a_controller
			-- TODO more code
		ensure
			controller_set: controller = a_controller
		end

feature -- Access

	current_iterator: XM_XPATH_SEQUENCE_ITERATOR [XM_XPATH_ITEM]
			-- Current iterator

feature -- Evaluation

	evaluate_local_variable (slot_number: INTEGER): XM_XPATH_VALUE is
			-- Value of a local variable, identified by its slot number
		require
			strictly_positive_slot_number: slot_number > 0
		do
			-- TODO
		end
	
feature 	-- Element change

	set_current_iterator (it: XM_XPATH_SEQUENCE_ITERATOR [XM_XPATH_ITEM]) is
			-- Set `current_iterator'.
		do
			current_iterator := it
		ensure
			set: current_iterator = it
		end

feature {NONE} -- Implementation

	controller: XM_XPATH_CONTROLLER
			-- XPATH controller

invariant

	controller_not_void: controller /= Void

end


