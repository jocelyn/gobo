indexing

	description:

		"Objects that implement the XSLT generate-id() function"

	library: "Gobo Eiffel XSLT Library"
	copyright: "Copyright (c) 2004, Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class XM_XSLT_GENERATE_ID

inherit

	XM_XPATH_SYSTEM_FUNCTION
		redefine
			simplify, evaluate_item
		end

creation

	make

feature {NONE} -- Initialization

	make is
			-- Establish invariant
		do
			name := "generate-id"
			minimum_argument_count := 0
			maximum_argument_count := 1
			create arguments.make (1)
			arguments.set_equality_tester (expression_tester)
			compute_static_properties
		end

feature -- Access

	item_type: XM_XPATH_ITEM_TYPE is
			-- Data type of the expression, where known
		do
			Result := type_factory.string_type
			if Result /= Void then
				-- Bug in SE 1.0 and 1.1: Make sure that
				-- that `Result' is not optimized away.
			end
		end

feature -- Status report

	required_type (argument_number: INTEGER): XM_XPATH_SEQUENCE_TYPE is
			-- Type of argument number `argument_number'
		do
			create Result.make_optional_node
		end

feature -- Optimization

	simplify is
			-- Perform context-independent static optimizations
		do
			use_context_item_as_default
			simplify_arguments
		end

feature -- Evaluation

	evaluate_item (a_context: XM_XPATH_CONTEXT) is
			-- Evaluate as a single item
		local
			a_node: XM_XPATH_NODE
		do
			arguments.item (1).evaluate_item (a_context)
			if not arguments.item (1).last_evaluated_item.is_error then
				a_node ?= arguments.item (1).last_evaluated_item
				if a_node = Void then
					create {XM_XPATH_STRING_VALUE} last_evaluated_item.make ("")
				else
					if a_node.generated_id = Void then
						a_node.generate_id
					end
					create {XM_XPATH_STRING_VALUE} last_evaluated_item.make (a_node.generated_id)
				end
			end
		end

feature {XM_XPATH_EXPRESSION} -- Restricted

	compute_cardinality is
			-- Compute cardinality.
		do
			set_cardinality_exactly_one
		end

end
	