indexing
	
	description:
	
		"Test expression parseer"
		
	library: "Gobo Eiffel XPath Library"
	copyright: "Copyright (c) 2004, Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"
	
deferred class XM_XPATH_TEST_EXPRESSION_PARSER

inherit

	TS_TEST_CASE
		redefine
			set_up
		end

	XM_XPATH_EXPRESSION_FACTORY

	XM_XPATH_AXIS

	XM_XPATH_TOKENS

feature -- Access

	shared_pool: XM_XPATH_SHARED_NAME_POOL is
			-- The shared name pool
		once
			create Result.make
		end

	default_pool: XM_XPATH_NAME_POOL
			-- The default name pool

feature -- Test

	test_simple_filtered_path is
		local
			an_expression: XM_XPATH_EXPRESSION
			a_path: XM_XPATH_PATH_EXPRESSION
			an_axis: XM_XPATH_AXIS_EXPRESSION
			a_filter: XM_XPATH_FILTER_EXPRESSION
			a_root: XM_XPATH_ROOT_EXPRESSION
			a_comparison: XM_XPATH_GENERAL_COMPARISON
			sub_exprs, sub_exprs_2, sub_exprs_3, sub_exprs_4: DS_LIST [XM_XPATH_EXPRESSION]
			context: XM_XPATH_STAND_ALONE_CONTEXT
			tokenizer: XM_XPATH_TOKENIZER
			a_string: STRING
			a_string_value: XM_XPATH_STRING_VALUE
		do
			a_string := "//fred[@son='Jim']"
			create context.make (default_pool, False)
			an_expression := make_expression (a_string, context)
			assert ("Parse sucessful", an_expression /= Void)
			a_path ?= an_expression
			assert ("Path expression", a_path /= Void)
			sub_exprs := a_path.sub_expressions
			assert ("Sub-expression", sub_exprs /= Void)
			assert ("Two sub-expressions", sub_exprs.count = 2)
			an_expression := sub_exprs.item (1)
			assert ("First sub-expression not void", an_expression /= Void)
			a_path ?= an_expression
			assert ("Path expression 2", a_path /= Void)
			sub_exprs_2 := a_path.sub_expressions
			assert ("Sub-expression 2", sub_exprs_2 /= Void)
			assert ("Two sub-expressions 2", sub_exprs_2.count = 2)
			an_expression := sub_exprs_2.item (1)
			a_root ?= an_expression
			assert ("Root expression not void", a_root /= Void) -- /
			an_expression := sub_exprs_2.item (2)
			an_axis ?= an_expression
			assert ("Axis expression not void", an_axis /= Void)
			assert ("Descendant-or-self-axis", an_axis.axis = Descendant_or_self_axis) -- Descendant-or-self::node()
			an_expression := sub_exprs.item (2)
			assert ("Second sub-expression not void", an_expression /= Void)
			a_filter ?= an_expression
			assert ("Filter expression", a_filter /= Void) -- fred[...]
			sub_exprs_3 := a_filter.sub_expressions
			assert ("Sub-expression 3", sub_exprs_3 /= Void)
			assert ("Two sub-expressions 3", sub_exprs_3.count = 2)
			an_expression := sub_exprs_3.item (1)
			an_axis ?= an_expression
			assert ("Axis expression 2 not void", an_axis /= Void) -- child::fred
			assert ("Axis selects child::fred", an_axis.axis = Child_axis
					  and an_axis.node_test /= Void and then STRING_.same_string (an_axis.node_test.original_text, "fred")) -- child::fred
			an_expression := sub_exprs_3.item (2)
			a_comparison ?= an_expression
			assert ("General comparison", a_comparison /= Void)
			assert ("Binary equals", a_comparison.operator = Equals_token)
			sub_exprs_4 := a_comparison.sub_expressions
			assert ("Sub-expression 4", sub_exprs_4 /= Void)
			assert ("Two sub-expressions 4", sub_exprs_4.count = 2)
			an_expression := sub_exprs_4.item (1)
			an_axis ?= an_expression
			assert ("Axis expression 3 not void", an_axis /= Void) -- attribute::son
			assert ("Axis selects attribute::son", an_axis.axis = Attribute_axis
					  and an_axis.node_test /= Void and then STRING_.same_string (an_axis.node_test.original_text, "son")) -- attribute::son
			an_expression := sub_exprs_4.item (2)
			a_string_value ?= an_expression
			assert ("String-value is Jim", a_string_value /= Void and then STRING_.same_string (a_string_value.string_value, "Jim"))
			
		end

feature -- Setting

	set_up is
		do
			default_pool := shared_pool.default_pool
		end

end