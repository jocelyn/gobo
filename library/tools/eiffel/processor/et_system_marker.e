indexing

	description:

		"Eiffel system markers"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2004, Eric Bezault and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ET_SYSTEM_MARKER

inherit

	ET_AST_NULL_PROCESSOR
		redefine
			process_actual_argument_list,
			process_actual_parameter_list,
			process_agent_actual_argument_list,
			process_assignment,
			process_assignment_attempt,
			process_attribute,
			process_bang_instruction,
			process_braced_type_list,
			process_call_agent,
			process_call_expression,
			process_call_instruction,
			process_check_instruction,
			process_class,
			process_class_type,
			process_compound,
			process_constant_attribute,
			process_constrained_formal_parameter,
			process_convert_feature_list,
			process_convert_function,
			process_convert_procedure,
			process_create_expression,
			process_create_instruction,
			process_debug_instruction,
			process_deferred_function,
			process_deferred_procedure,
			process_do_function,
			process_do_procedure,
			process_elseif_part,
			process_elseif_part_list,
			process_equality_expression,
			process_expression_address,
			process_external_function,
			process_external_procedure,
			process_formal_argument,
			process_formal_argument_list,
			process_formal_parameter_list,
			process_generic_class_type,
			process_if_instruction,
			process_infix_expression,
			process_inspect_instruction,
			process_invariants,
			process_local_variable,
			process_local_variable_list,
			process_loop_instruction,
			process_loop_invariants,
			process_manifest_array,
			process_manifest_tuple,
			process_old_expression,
			process_once_function,
			process_once_procedure,
			process_parent,
			process_parenthesized_expression,
			process_parent_list,
			process_postconditions,
			process_preconditions,
			process_precursor_expression,
			process_precursor_instruction,
			process_prefix_expression,
			process_qualified_braced_type,
			process_qualified_like_type,
			process_static_call_expression,
			process_static_call_instruction,
			process_tagged_assertion,
			process_tuple_type,
			process_unique_attribute,
			process_variant,
			process_when_part,
			process_when_part_list
		end

creation

	make

feature -- Processing

	build_system (a_class: ET_CLASS) is
			-- Identify the classes that `a_class' depends on (see definition
			-- in ETL page 35) and mark them as being part of the system.
		require
			a_class_not_void: a_class /= Void
		local
			a_cursor: DS_HASH_TABLE_CURSOR [ET_CLASS, ET_CLASS_NAME]
		do
			a_cursor := universe.classes.new_cursor
			from a_cursor.start until a_cursor.after loop
				a_cursor.item.set_in_system (False)
				a_cursor.forth
			end
			process_class (a_class)
		ensure
			a_class_in_system: a_class.in_system
		end

feature {ET_AST_NODE} -- Processing

	process_actual_argument_list (a_list: ET_ACTUAL_ARGUMENT_LIST) is
			-- Process `a_list'.
		local
			i, nb: INTEGER
		do
			nb := a_list.count
			from i := 1 until i > nb loop
				a_list.actual_argument (i).process (Current)
				i := i + 1
			end
		end

	process_actual_parameter_list (a_list: ET_ACTUAL_PARAMETER_LIST) is
			-- Process `a_list'.
		local
			i, nb: INTEGER
		do
			nb := a_list.count
			from i := 1 until i > nb loop
				a_list.type (i).process (Current)
				i := i + 1
			end
		end

	process_agent_actual_argument_list (a_list: ET_AGENT_ACTUAL_ARGUMENT_LIST) is
			-- Process `a_list'.
		local
			i, nb: INTEGER
		do
			nb := a_list.count
			from i := 1 until i > nb loop
				a_list.actual_argument (i).process (Current)
				i := i + 1
			end
		end

	process_assignment (an_instruction: ET_ASSIGNMENT) is
			-- Process `an_instruction'.
		do
			an_instruction.source.process (Current)
		end

	process_assignment_attempt (an_instruction: ET_ASSIGNMENT_ATTEMPT) is
			-- Process `an_instruction'.
		do
			an_instruction.source.process (Current)
		end

	process_attribute (a_feature: ET_ATTRIBUTE) is
			-- Process `a_feature'.
		do
			a_feature.type.process (Current)
		end

	process_bang_instruction (an_instruction: ET_BANG_INSTRUCTION) is
			-- Process `an_instruction'.
		local
			a_type: ET_TYPE
			a_call: ET_QUALIFIED_CALL
			an_arguments: ET_ACTUAL_ARGUMENT_LIST
		do
			a_type := an_instruction.type
			if a_type /= Void then
				a_type.process (Current)
			end
			a_call := an_instruction.creation_call
			if a_call /= Void then
				an_arguments := a_call.arguments
				if an_arguments /= Void then
					process_actual_argument_list (an_arguments)
				end
			end
		end

	process_braced_type_list (a_list: ET_BRACED_TYPE_LIST) is
			-- Process `a_list'.
		local
			i, nb: INTEGER
		do
			nb := a_list.count
			from i := 1 until i > nb loop
				a_list.type (i).process (Current)
				i := i + 1
			end
		end

	process_call_agent (an_expression: ET_CALL_AGENT) is
			-- Process `an_expression'.
		local
			a_target: ET_AGENT_TARGET
			an_arguments: ET_AGENT_ACTUAL_ARGUMENT_LIST
		do
			a_target := an_expression.target
			if a_target /= Void then
				a_target.process (Current)
			end
			an_arguments := an_expression.arguments
			if an_arguments /= Void then
				process_agent_actual_argument_list (an_arguments)
			end
		end

	process_call_expression (an_expression: ET_CALL_EXPRESSION) is
			-- Process `an_expression'.
		local
			a_target: ET_EXPRESSION
			an_arguments: ET_ACTUAL_ARGUMENT_LIST
		do
			a_target := an_expression.target
			if a_target /= Void then
				a_target.process (Current)
			end
			an_arguments := an_expression.arguments
			if an_arguments /= Void then
				process_actual_argument_list (an_arguments)
			end
		end

	process_call_instruction (an_instruction: ET_CALL_INSTRUCTION) is
			-- Process `an_instruction'.
		local
			a_target: ET_EXPRESSION
			an_arguments: ET_ACTUAL_ARGUMENT_LIST
		do
			a_target := an_instruction.target
			if a_target /= Void then
				a_target.process (Current)
			end
			an_arguments := an_instruction.arguments
			if an_arguments /= Void then
				process_actual_argument_list (an_arguments)
			end
		end

	process_check_instruction (an_instruction: ET_CHECK_INSTRUCTION) is
			-- Process `an_instruction'.
		local
			i, nb: INTEGER
		do
			nb := an_instruction.count
			from i := 1 until i > nb loop
				an_instruction.assertion (i).process (Current)
				i := i + 1
			end
		end

	process_class (a_class: ET_CLASS) is
			-- Process `a_class'.
		local
			a_formal_parameters: ET_FORMAL_PARAMETER_LIST
			a_parents: ET_PARENT_LIST
			a_convert_features: ET_CONVERT_FEATURE_LIST
			an_invariants: ET_INVARIANTS
		do
			a_class.set_in_system (True)
			a_formal_parameters := a_class.formal_parameters
			if a_formal_parameters /= Void then
				process_formal_parameter_list (a_formal_parameters)
			end
			a_parents := a_class.parents
			if a_parents /= Void then
				process_parent_list (a_parents)
			end
			a_convert_features := a_class.convert_features
			if a_convert_features /= Void then
				process_convert_feature_list (a_convert_features)
			end
			process_features (a_class)
			an_invariants := a_class.invariants
			if an_invariants /= Void then
				process_invariants (an_invariants)
			end
		end

	process_class_type (a_type: ET_CLASS_TYPE) is
			-- Process `a_type'.
		local
			a_class: ET_CLASS
		do
			a_class := a_type.direct_base_class (universe)
			if not a_class.in_system then
				process_class (a_class)
			end
		end

	process_compound (a_list: ET_COMPOUND) is
			-- Process `a_list'.
		local
			i, nb: INTEGER
		do
			nb := a_list.count
			from i := 1 until i > nb loop
				a_list.item (i).process (Current)
				i := i + 1
			end
		end

	process_constant_attribute (a_feature: ET_CONSTANT_ATTRIBUTE) is
			-- Process `a_feature'.
		do
			a_feature.type.process (Current)
		end

	process_constrained_formal_parameter (a_parameter: ET_CONSTRAINED_FORMAL_PARAMETER) is
			-- Process `a_parameter'.
		do
			a_parameter.constraint.process (Current)
		end

	process_convert_feature_list (a_list: ET_CONVERT_FEATURE_LIST) is
			-- Process `a_list'.
		local
			i, nb: INTEGER
		do
			nb := a_list.count
			from i := 1 until i > nb loop
				a_list.convert_feature (i).process (Current)
				i := i + 1
			end
		end

	process_convert_function (a_convert_function: ET_CONVERT_FUNCTION) is
			-- Process `a_convert_function'.
		do
			a_convert_function.types.process (Current)
		end

	process_convert_procedure (a_convert_procedure: ET_CONVERT_PROCEDURE) is
			-- Process `a_convert_procedure'.
		do
			a_convert_procedure.types.process (Current)
		end

	process_create_expression (an_expression: ET_CREATE_EXPRESSION) is
			-- Process `an_expression'.
		local
			a_call: ET_QUALIFIED_CALL
			an_arguments: ET_ACTUAL_ARGUMENT_LIST
		do
			an_expression.type.process (Current)
			a_call := an_expression.creation_call
			if a_call /= Void then
				an_arguments := a_call.arguments
				if an_arguments /= Void then
					process_actual_argument_list (an_arguments)
				end
			end
		end

	process_create_instruction (an_instruction: ET_CREATE_INSTRUCTION) is
			-- Process `an_instruction'.
		local
			a_type: ET_TARGET_TYPE
			a_call: ET_QUALIFIED_CALL
			an_arguments: ET_ACTUAL_ARGUMENT_LIST
		do
			a_type := an_instruction.type
			if a_type /= Void then
				a_type.process (Current)
			end
			a_call := an_instruction.creation_call
			if a_call /= Void then
				an_arguments := a_call.arguments
				if an_arguments /= Void then
					process_actual_argument_list (an_arguments)
				end
			end
		end

	process_debug_instruction (an_instruction: ET_DEBUG_INSTRUCTION) is
			-- Process `an_instruction'.
		local
			a_compound: ET_COMPOUND
			i, nb: INTEGER
		do
			a_compound := an_instruction.compound
			if a_compound /= Void then
				nb := a_compound.count
				from i := 1 until i > nb loop
					a_compound.item (i).process (Current)
					i := i + 1
				end
			end
		end

	process_deferred_function (a_feature: ET_DEFERRED_FUNCTION) is
			-- Process `a_feature'.
		local
			an_arguments: ET_FORMAL_ARGUMENT_LIST
			a_preconditions: ET_PRECONDITIONS
			a_postconditions: ET_POSTCONDITIONS
		do
			an_arguments := a_feature.arguments
			if an_arguments /= Void then
				process_formal_argument_list (an_arguments)
			end
			a_feature.type.process (Current)
			a_preconditions := a_feature.preconditions
			if a_preconditions /= Void then
				process_preconditions (a_preconditions)
			end
			a_postconditions := a_feature.postconditions
			if a_postconditions /= Void then
				process_postconditions (a_postconditions)
			end
		end

	process_deferred_procedure (a_feature: ET_DEFERRED_PROCEDURE) is
			-- Process `a_feature'.
		local
			an_arguments: ET_FORMAL_ARGUMENT_LIST
			a_preconditions: ET_PRECONDITIONS
			a_postconditions: ET_POSTCONDITIONS
		do
			an_arguments := a_feature.arguments
			if an_arguments /= Void then
				process_formal_argument_list (an_arguments)
			end
			a_preconditions := a_feature.preconditions
			if a_preconditions /= Void then
				process_preconditions (a_preconditions)
			end
			a_postconditions := a_feature.postconditions
			if a_postconditions /= Void then
				process_postconditions (a_postconditions)
			end
		end

	process_do_function (a_feature: ET_DO_FUNCTION) is
			-- Process `a_feature'.
		local
			an_arguments: ET_FORMAL_ARGUMENT_LIST
			a_preconditions: ET_PRECONDITIONS
			a_locals: ET_LOCAL_VARIABLE_LIST
			a_postconditions: ET_POSTCONDITIONS
			a_compound: ET_COMPOUND
		do
			an_arguments := a_feature.arguments
			if an_arguments /= Void then
				process_formal_argument_list (an_arguments)
			end
			a_feature.type.process (Current)
			a_preconditions := a_feature.preconditions
			if a_preconditions /= Void then
				process_preconditions (a_preconditions)
			end
			a_locals := a_feature.locals
			if a_locals /= Void then
				process_local_variable_list (a_locals)
			end
			a_compound := a_feature.compound
			if a_compound /= Void then
				process_compound (a_compound)
			end
			a_postconditions := a_feature.postconditions
			if a_postconditions /= Void then
				process_postconditions (a_postconditions)
			end
			a_compound := a_feature.rescue_clause
			if a_compound /= Void then
				process_compound (a_compound)
			end
		end

	process_do_procedure (a_feature: ET_DO_PROCEDURE) is
			-- Process `a_feature'.
		local
			an_arguments: ET_FORMAL_ARGUMENT_LIST
			a_preconditions: ET_PRECONDITIONS
			a_locals: ET_LOCAL_VARIABLE_LIST
			a_postconditions: ET_POSTCONDITIONS
			a_compound: ET_COMPOUND
		do
			an_arguments := a_feature.arguments
			if an_arguments /= Void then
				process_formal_argument_list (an_arguments)
			end
			a_preconditions := a_feature.preconditions
			if a_preconditions /= Void then
				process_preconditions (a_preconditions)
			end
			a_locals := a_feature.locals
			if a_locals /= Void then
				process_local_variable_list (a_locals)
			end
			a_compound := a_feature.compound
			if a_compound /= Void then
				process_compound (a_compound)
			end
			a_postconditions := a_feature.postconditions
			if a_postconditions /= Void then
				process_postconditions (a_postconditions)
			end
			a_compound := a_feature.rescue_clause
			if a_compound /= Void then
				process_compound (a_compound)
			end
		end

	process_elseif_part (an_elseif_part: ET_ELSEIF_PART) is
			-- Process `an_elseif_part'.
		local
			a_compound: ET_COMPOUND
		do
			an_elseif_part.expression.process (Current)
			a_compound := an_elseif_part.then_compound
			if a_compound /= Void then
				process_compound (a_compound)
			end
		end

	process_elseif_part_list (a_list: ET_ELSEIF_PART_LIST) is
			-- Process `a_list'.
		local
			i, nb: INTEGER
		do
			nb := a_list.count
			from i := 1 until i > nb loop
				a_list.item (i).process (Current)
				i := i + 1
			end
		end

	process_equality_expression (an_expression: ET_EQUALITY_EXPRESSION) is
			-- Process `an_expression'.
		do
			an_expression.left.process (Current)
			an_expression.right.process (Current)
		end

	process_expression_address (an_expression: ET_EXPRESSION_ADDRESS) is
			-- Process `an_expression'.
		do
			an_expression.expression.process (Current)
		end

	process_external_function (a_feature: ET_EXTERNAL_FUNCTION) is
			-- Process `a_feature'.
		local
			an_arguments: ET_FORMAL_ARGUMENT_LIST
			a_preconditions: ET_PRECONDITIONS
			a_postconditions: ET_POSTCONDITIONS
		do
			an_arguments := a_feature.arguments
			if an_arguments /= Void then
				process_formal_argument_list (an_arguments)
			end
			a_feature.type.process (Current)
			a_preconditions := a_feature.preconditions
			if a_preconditions /= Void then
				process_preconditions (a_preconditions)
			end
			a_postconditions := a_feature.postconditions
			if a_postconditions /= Void then
				process_postconditions (a_postconditions)
			end
		end

	process_external_procedure (a_feature: ET_EXTERNAL_PROCEDURE) is
			-- Process `a_feature'.
		local
			an_arguments: ET_FORMAL_ARGUMENT_LIST
			a_preconditions: ET_PRECONDITIONS
			a_postconditions: ET_POSTCONDITIONS
		do
			an_arguments := a_feature.arguments
			if an_arguments /= Void then
				process_formal_argument_list (an_arguments)
			end
			a_preconditions := a_feature.preconditions
			if a_preconditions /= Void then
				process_preconditions (a_preconditions)
			end
			a_postconditions := a_feature.postconditions
			if a_postconditions /= Void then
				process_postconditions (a_postconditions)
			end
		end

	process_features (a_class: ET_CLASS) is
			-- Process features of `a_class'.
		require
			a_class_not_void: a_class /= Void
		local
			a_features: ET_FEATURE_LIST
			i, nb: INTEGER
		do
			a_features := a_class.features
			nb := a_class.declared_feature_count
			from i := 1 until i > nb loop
				a_features.item (i).process (Current)
				i := i + 1
			end
		end

	process_formal_argument (an_argument: ET_FORMAL_ARGUMENT) is
			-- Process `an_argument'.
		do
			an_argument.type.process (Current)
		end

	process_formal_argument_list (a_list: ET_FORMAL_ARGUMENT_LIST) is
			-- Process `a_list'.
		local
			i, nb: INTEGER
		do
			nb := a_list.count
			from i := 1 until i > nb loop
				a_list.formal_argument (i).process (Current)
				i := i + 1
			end
		end

	process_formal_parameter_list (a_list: ET_FORMAL_PARAMETER_LIST) is
			-- Process `a_list'.
		local
			i, nb: INTEGER
		do
			nb := a_list.count
			from i := 1 until i > nb loop
				a_list.formal_parameter (i).process (Current)
				i := i + 1
			end
		end

	process_generic_class_type (a_type: ET_GENERIC_CLASS_TYPE) is
			-- Process `a_type'.
		do
			process_class_type (a_type)
			a_type.actual_parameters.process (Current)
		end

	process_if_instruction (an_instruction: ET_IF_INSTRUCTION) is
			-- Process `an_instruction'.
		local
			an_elseif_parts: ET_ELSEIF_PART_LIST
			a_compound: ET_COMPOUND
		do
			an_instruction.expression.process (Current)
			a_compound := an_instruction.then_compound
			if a_compound /= Void then
				process_compound (a_compound)
			end
			an_elseif_parts := an_instruction.elseif_parts
			if an_elseif_parts /= Void then
				process_elseif_part_list (an_elseif_parts)
			end
			a_compound := an_instruction.else_compound
			if a_compound /= Void then
				process_compound (a_compound)
			end
		end

	process_infix_expression (an_expression: ET_INFIX_EXPRESSION) is
			-- Process `an_expression'.
		do
			an_expression.left.process (Current)
			an_expression.right.process (Current)
		end

	process_inspect_instruction (an_instruction: ET_INSPECT_INSTRUCTION) is
			-- Process `an_instruction'.
		local
			a_when_parts: ET_WHEN_PART_LIST
			an_else_compound: ET_COMPOUND
		do
			an_instruction.expression.process (Current)
			a_when_parts := an_instruction.when_parts
			if a_when_parts /= Void then
				process_when_part_list (a_when_parts)
			end
			an_else_compound := an_instruction.else_compound
			if an_else_compound /= Void then
				process_compound (an_else_compound)
			end
		end

	process_invariants (a_list: ET_INVARIANTS) is
			-- Process `a_list'.
		local
			i, nb: INTEGER
		do
			nb := a_list.count
			from i := 1 until i > nb loop
				a_list.assertion (i).process (Current)
				i := i + 1
			end
		end

	process_local_variable (a_local: ET_LOCAL_VARIABLE) is
			-- Process `a_local'.
		do
			a_local.type.process (Current)
		end

	process_local_variable_list (a_list: ET_LOCAL_VARIABLE_LIST) is
			-- Process `a_list'.
		local
			i, nb: INTEGER
		do
			nb := a_list.count
			from i := 1 until i > nb loop
				a_list.local_variable (i).process (Current)
				i := i + 1
			end
		end

	process_loop_instruction (an_instruction: ET_LOOP_INSTRUCTION) is
			-- Process `an_instruction'.
		local
			an_invariant_part: ET_LOOP_INVARIANTS
			a_variant_part: ET_VARIANT
			a_compound: ET_COMPOUND
		do
			a_compound := an_instruction.from_compound
			if a_compound /= Void then
				process_compound (a_compound)
			end
			an_invariant_part := an_instruction.invariant_part
			if an_invariant_part /= Void then
				process_loop_invariants (an_invariant_part)
			end
			a_variant_part := an_instruction.variant_part
			if a_variant_part /= Void then
				process_variant (a_variant_part)
			end
			an_instruction.until_expression.process (Current)
			a_compound := an_instruction.loop_compound
			if a_compound /= Void then
				process_compound (a_compound)
			end
		end

	process_loop_invariants (a_list: ET_LOOP_INVARIANTS) is
			-- Process `a_list'.
		local
			i, nb: INTEGER
		do
			nb := a_list.count
			from i := 1 until i > nb loop
				a_list.assertion (i).process (Current)
				i := i + 1
			end
		end

	process_manifest_array (an_expression: ET_MANIFEST_ARRAY) is
			-- Process `an_expression'.
		local
			i, nb: INTEGER
		do
			nb := an_expression.count
			from i := 1 until i > nb loop
				an_expression.expression (i).process (Current)
				i := i + 1
			end
		end

	process_manifest_tuple (an_expression: ET_MANIFEST_TUPLE) is
			-- Process `an_expression'.
		local
			i, nb: INTEGER
		do
			nb := an_expression.count
			from i := 1 until i > nb loop
				an_expression.expression (i).process (Current)
				i := i + 1
			end
		end

	process_old_expression (an_expression: ET_OLD_EXPRESSION) is
			-- Process `an_expression'.
		do
			an_expression.expression.process (Current)
		end

	process_once_function (a_feature: ET_ONCE_FUNCTION) is
			-- Process `a_feature'.
		local
			an_arguments: ET_FORMAL_ARGUMENT_LIST
			a_preconditions: ET_PRECONDITIONS
			a_locals: ET_LOCAL_VARIABLE_LIST
			a_postconditions: ET_POSTCONDITIONS
			a_compound: ET_COMPOUND
		do
			an_arguments := a_feature.arguments
			if an_arguments /= Void then
				process_formal_argument_list (an_arguments)
			end
			a_feature.type.process (Current)
			a_preconditions := a_feature.preconditions
			if a_preconditions /= Void then
				process_preconditions (a_preconditions)
			end
			a_locals := a_feature.locals
			if a_locals /= Void then
				process_local_variable_list (a_locals)
			end
			a_compound := a_feature.compound
			if a_compound /= Void then
				process_compound (a_compound)
			end
			a_postconditions := a_feature.postconditions
			if a_postconditions /= Void then
				process_postconditions (a_postconditions)
			end
			a_compound := a_feature.rescue_clause
			if a_compound /= Void then
				process_compound (a_compound)
			end
		end

	process_once_procedure (a_feature: ET_ONCE_PROCEDURE) is
			-- Process `a_feature'.
		local
			an_arguments: ET_FORMAL_ARGUMENT_LIST
			a_preconditions: ET_PRECONDITIONS
			a_locals: ET_LOCAL_VARIABLE_LIST
			a_postconditions: ET_POSTCONDITIONS
			a_compound: ET_COMPOUND
		do
			an_arguments := a_feature.arguments
			if an_arguments /= Void then
				process_formal_argument_list (an_arguments)
			end
			a_preconditions := a_feature.preconditions
			if a_preconditions /= Void then
				process_preconditions (a_preconditions)
			end
			a_locals := a_feature.locals
			if a_locals /= Void then
				process_local_variable_list (a_locals)
			end
			a_compound := a_feature.compound
			if a_compound /= Void then
				process_compound (a_compound)
			end
			a_postconditions := a_feature.postconditions
			if a_postconditions /= Void then
				process_postconditions (a_postconditions)
			end
			a_compound := a_feature.rescue_clause
			if a_compound /= Void then
				process_compound (a_compound)
			end
		end

	process_parent (a_parent: ET_PARENT) is
			-- Process `a_parent'.
		do
			a_parent.type.process (Current)
		end

	process_parenthesized_expression (an_expression: ET_PARENTHESIZED_EXPRESSION) is
			-- Process `an_expression'.
		do
			an_expression.expression.process (Current)
		end

	process_parent_list (a_list: ET_PARENT_LIST) is
			-- Process `a_list'.
		local
			i, nb: INTEGER
		do
			nb := a_list.count
			from i := 1 until i > nb loop
				a_list.parent (i).process (Current)
				i := i + 1
			end
		end

	process_postconditions (a_list: ET_POSTCONDITIONS) is
			-- Process `a_list'.
		local
			i, nb: INTEGER
		do
			nb := a_list.count
			from i := 1 until i > nb loop
				a_list.assertion (i).process (Current)
				i := i + 1
			end
		end

	process_preconditions (a_list: ET_PRECONDITIONS) is
			-- Process `a_list'.
		local
			i, nb: INTEGER
		do
			nb := a_list.count
			from i := 1 until i > nb loop
				a_list.assertion (i).process (Current)
				i := i + 1
			end
		end

	process_precursor_expression (an_expression: ET_PRECURSOR_EXPRESSION) is
			-- Process `an_expression'.
		local
			an_arguments: ET_ACTUAL_ARGUMENT_LIST
		do
			an_arguments := an_expression.arguments
			if an_arguments /= Void then
				process_actual_argument_list (an_arguments)
			end
		end

	process_precursor_instruction (an_instruction: ET_PRECURSOR_INSTRUCTION) is
			-- Process `an_instruction'.
		local
			an_arguments: ET_ACTUAL_ARGUMENT_LIST
		do
			an_arguments := an_instruction.arguments
			if an_arguments /= Void then
				process_actual_argument_list (an_arguments)
			end
		end

	process_prefix_expression (an_expression: ET_PREFIX_EXPRESSION) is
			-- Process `an_expression'.
		do
			an_expression.expression.process (Current)
		end

	process_qualified_braced_type (a_type: ET_QUALIFIED_BRACED_TYPE) is
			-- Process `a_type'.
		do
			a_type.target_type.process (Current)
		end

	process_qualified_like_type (a_type: ET_QUALIFIED_LIKE_TYPE) is
			-- Process `a_type'.
		do
			a_type.target_type.process (Current)
		end

	process_static_call_expression (an_expression: ET_STATIC_CALL_EXPRESSION) is
			-- Process `an_expression'.
		local
			an_arguments: ET_ACTUAL_ARGUMENT_LIST
		do
			an_expression.type.process (Current)
			an_arguments := an_expression.arguments
			if an_arguments /= Void then
				process_actual_argument_list (an_arguments)
			end
		end

	process_static_call_instruction (an_instruction: ET_STATIC_CALL_INSTRUCTION) is
			-- Process `an_instruction'.
		local
			an_arguments: ET_ACTUAL_ARGUMENT_LIST
		do
			an_instruction.type.process (Current)
			an_arguments := an_instruction.arguments
			if an_arguments /= Void then
				process_actual_argument_list (an_arguments)
			end
		end

	process_tagged_assertion (an_assertion: ET_TAGGED_ASSERTION) is
			-- Process `an_assertion'.
		local
			an_expression: ET_EXPRESSION
		do
			an_expression := an_assertion.expression
			if an_expression /= Void then
				an_expression.process (Current)
			end
		end

	process_tuple_type (a_type: ET_TUPLE_TYPE) is
			-- Process `a_type'.
		local
			a_class: ET_CLASS
			a_parameters: ET_ACTUAL_PARAMETER_LIST
		do
			a_class := a_type.direct_base_class (universe)
			if not a_class.in_system then
				process_class (a_class)
			end
			a_parameters := a_type.actual_parameters
			if a_parameters /= Void then
				a_parameters.process (Current)
			end
		end

	process_unique_attribute (a_feature: ET_UNIQUE_ATTRIBUTE) is
			-- Process `a_feature'.
		do
			a_feature.type.process (Current)
		end

	process_variant (a_variant: ET_VARIANT) is
			-- Process `a_variant'.
		local
			an_expression: ET_EXPRESSION
		do
			an_expression := a_variant.expression
			if an_expression /= Void then
				an_expression.process (Current)
			end
		end

	process_when_part (a_when_part: ET_WHEN_PART) is
			-- Process `a_when_part'.
		local
			a_compound: ET_COMPOUND
		do
			a_compound := a_when_part.then_compound
			if a_compound /= Void then
				process_compound (a_compound)
			end
		end

	process_when_part_list (a_list: ET_WHEN_PART_LIST) is
			-- Process `a_list'.
		local
			i, nb: INTEGER
		do
			nb := a_list.count
			from i := 1 until i > nb loop
				a_list.item (i).process (Current)
				i := i + 1
			end
		end

end