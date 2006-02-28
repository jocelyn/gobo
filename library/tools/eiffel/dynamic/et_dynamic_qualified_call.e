indexing

	description:

		"Eiffel qualified calls at run-time"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2004-2005, Eric Bezault and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ET_DYNAMIC_QUALIFIED_CALL

inherit

	ET_DYNAMIC_TARGET

feature -- Access

	static_call: ET_CALL_COMPONENT
			-- Static call

	static_feature: ET_FEATURE is
			-- Static feature of the call;
			-- Void if no such feature found
		deferred
		end

	target_type_set: ET_DYNAMIC_TYPE_SET
			-- Type of target

	current_feature: ET_DYNAMIC_FEATURE
			-- Feature where the call appears

	current_type: ET_DYNAMIC_TYPE
			-- Type to which `current_feature' belongs

	position: ET_POSITION is
			-- Position of call
		do
			Result := static_call.position
		ensure
			position_not_void: Result /= Void
		end

feature -- Measurement

	count: INTEGER
			-- Number of types in `target_type_set' when
			-- `propagate_types' was last called

feature -- Element change

	put_type (a_type: ET_DYNAMIC_TYPE; a_system: ET_SYSTEM) is
			-- Add `a_type' to current set.
		local
			l_dynamic_feature: like seeded_dynamic_feature
			l_builder: ET_DYNAMIC_TYPE_SET_BUILDER
		do
			l_dynamic_feature := seeded_dynamic_feature (static_call.name.seed, a_type, a_system)
			if l_dynamic_feature = Void then
				if a_type.conforms_to_type (target_type_set.static_type, a_system) then
						-- Internal error: there should be a feature with that seed
						-- in all descendants of `target_type_set.static_type'.
					l_builder := a_system.dynamic_type_set_builder
					l_builder.set_fatal_error
					l_builder.error_handler.report_gibea_error
				else
					-- The error has already been reported somewhere else.
				end
			else
				put_type_with_feature (a_type, l_dynamic_feature, a_system)
			end
		end

	propagate_types (a_builder: ET_DYNAMIC_TYPE_SET_BUILDER) is
			-- Propagate types from `target_type_set' using `a_builder'.
		require
			a_builder_not_void: a_builder /= Void
		local
			l_count, old_count: INTEGER
			l_type: ET_DYNAMIC_TYPE
			l_other_types: ET_DYNAMIC_TYPE_LIST
			i, nb: INTEGER
			j, nb2: INTEGER
		do
			old_count := count
			l_count := target_type_set.count
			if l_count /= old_count then
				nb := l_count - old_count
				count := l_count
				l_other_types := target_type_set.other_types
				if l_other_types /= Void then
					nb2 := l_other_types.count
					from j := nb2 until j < 1 loop
						a_builder.propagate_call_type (l_other_types.item (j), Current)
						i := i + 1
						if i < nb then
							j := j - 1
						else
							j := 0 -- Jump out of the loop.
						end
					end
				end
				if i < nb then
					l_type := target_type_set.first_type
					if l_type /= Void then
						a_builder.propagate_call_type (l_type, Current)
					else
							-- Internal error: the type counts are corrupted.
						a_builder.set_fatal_error
						a_builder.error_handler.report_gibfm_error
					end
				end
			end
		end

	propagate_type (a_type: ET_DYNAMIC_TYPE; a_builder: ET_DYNAMIC_TYPE_SET_BUILDER) is
			-- Propagate `a_type' from `target_type_set' using `a_builder'.
		require
			a_type_not_void: a_type /= Void
			a_builder_not_void: a_builder /= Void
		local
			l_dynamic_feature: like seeded_dynamic_feature
			l_system: ET_SYSTEM
		do
			l_system := a_builder.current_system
			l_dynamic_feature := seeded_dynamic_feature (static_call.name.seed, a_type, l_system)
			if l_dynamic_feature = Void then
				if a_type.conforms_to_type (target_type_set.static_type, l_system) then
						-- Internal error: there should be a feature with that seed
						-- in all descendants of `target_type_set.static_type'.
					a_builder.set_fatal_error
					a_builder.error_handler.report_gibbt_error
				else
					-- The error has already been reported somewhere else.
				end
			else
				propagate_type_with_feature (a_type, l_dynamic_feature, a_builder)
			end
		end

feature {ET_DYNAMIC_TYPE_SET_BUILDER} -- Access

	seeded_dynamic_feature (a_seed: INTEGER; a_type: ET_DYNAMIC_TYPE; a_system: ET_SYSTEM): ET_DYNAMIC_FEATURE is
			-- Run-time feature in `a_type' corresponding to current call with seed `a_seed';
			-- Void if no such feature
		require
			a_type_not_void: a_type /= Void
			a_system_not_void: a_system /= Void
		deferred
		end

feature {NONE} -- Implementation

	put_type_with_feature (a_type: ET_DYNAMIC_TYPE; a_feature: like seeded_dynamic_feature; a_system: ET_SYSTEM) is
			-- Add `a_type' to current set.
			-- `a_feature' is the feature in `a_type' corresponding to current call.
		require
			a_type_not_void: a_type /= Void
			a_feature_not_void: a_feature /= Void
			a_system_not_void: a_system /= Void
		local
			l_builder: ET_DYNAMIC_TYPE_SET_BUILDER
			l_actuals: ET_ARGUMENT_OPERANDS
			l_actual: ET_ARGUMENT_OPERAND
			l_source_argument_type_set: ET_DYNAMIC_TYPE_SET
			l_target_argument_type_sets: ET_DYNAMIC_TYPE_SET_LIST
			i, nb: INTEGER
			l_agent_type: ET_DYNAMIC_ROUTINE_TYPE
			l_open_operand_type_sets: ET_DYNAMIC_TYPE_SET_LIST
			l_manifest_tuple: ET_MANIFEST_TUPLE
		do
			a_feature.set_regular (True)
			l_actuals := static_call.arguments
			if l_actuals /= Void then
				nb := l_actuals.count
				if nb > 0 then
						-- Dynamic type sets for arguments are stored first
						-- in `dynamic_type_sets'.
					l_target_argument_type_sets := a_feature.dynamic_type_sets
					if l_target_argument_type_sets.count < nb then
							-- Internal error: it has already been checked somewhere else
							-- that there was the same number of formal arguments in
							-- feature redeclaration.
						l_builder := a_system.dynamic_type_set_builder
						l_builder.set_fatal_error
						l_builder.error_handler.report_gibeb_error
					elseif (a_feature.is_builtin_routine_call or a_feature.is_builtin_function_item) and then a_type.is_agent_type then
							-- This is something of the form:  'my_agent.call ([...])' or 'my_agent.item ([...])'
							-- Try to get the open operand type sets directly from the
							-- argument if it is a manifest tuple.
						l_agent_type ?= a_type
						if l_agent_type = Void then
								-- Internal error: it has to be an agent type.
							l_builder := a_system.dynamic_type_set_builder
							l_builder.set_fatal_error
							l_builder.error_handler.report_gibhn_error
						else
							if nb /= 1 then
									-- Internal error: 'call' or 'item' should have exactly one argument.
								l_builder := a_system.dynamic_type_set_builder
								l_builder.set_fatal_error
								l_builder.error_handler.report_gibho_error
							else
								l_actual := l_actuals.actual_argument (1)
								l_manifest_tuple ?= l_actual
								if l_manifest_tuple /= Void then
									l_open_operand_type_sets := l_agent_type.open_operand_type_sets
									nb := l_open_operand_type_sets.count
									if l_manifest_tuple.count < nb then
											-- We don't get enough operands. This will be reported
											-- by the CAT-call checking.
										nb := l_manifest_tuple.count
									end
									from i := 1 until i > nb loop
										l_source_argument_type_set := current_feature.dynamic_type_set (l_manifest_tuple.expression (i))
										if l_source_argument_type_set = Void then
												-- Internal error: the dynamic type sets of the actual
												-- arguments should be known at this stage.
											l_builder := a_system.dynamic_type_set_builder
											l_builder.set_fatal_error
											l_builder.error_handler.report_gibhp_error
										else
											l_source_argument_type_set.put_target (l_open_operand_type_sets.item (i), a_system)
										end
										i := i + 1
									end
								else
									l_source_argument_type_set := current_feature.dynamic_type_set (l_actual)
									if l_source_argument_type_set = Void then
											-- Internal error: the dynamic type sets of the actual
											-- arguments should be known at this stage.
										l_builder := a_system.dynamic_type_set_builder
										l_builder.set_fatal_error
										l_builder.error_handler.report_gibhq_error
									else
										l_source_argument_type_set.put_target (l_target_argument_type_sets.item (1), a_system)
									end
								end
							end
						end
					else
						from i := 1 until i > nb loop
							l_source_argument_type_set := current_feature.dynamic_type_set (l_actuals.actual_argument (i))
							if l_source_argument_type_set = Void then
									-- Internal error: the dynamic type sets of the actual
									-- arguments should be known at this stage.
								l_builder := a_system.dynamic_type_set_builder
								l_builder.set_fatal_error
								l_builder.error_handler.report_gibbd_error
							else
								l_source_argument_type_set.put_target (l_target_argument_type_sets.item (i), a_system)
							end
							i := i + 1
						end
					end
				end
			end
		end

	propagate_type_with_feature (a_type: ET_DYNAMIC_TYPE; a_feature: like seeded_dynamic_feature; a_builder: ET_DYNAMIC_TYPE_SET_BUILDER) is
			-- Propagate `a_type' from `target_type_set' using `a_builder'.
			-- `a_feature' is the feature in `a_type' corresponding to current call.
		require
			a_type_not_void: a_type /= Void
			a_feature_not_void: a_feature /= Void
			a_builder_not_void: a_builder /= Void
		local
			l_source_argument_type_set: ET_DYNAMIC_TYPE_SET
			l_target_argument_type_sets: ET_DYNAMIC_TYPE_SET_LIST
			l_target_argument_type_set: ET_DYNAMIC_TYPE_SET
			l_actuals: ET_ARGUMENT_OPERANDS
			l_actual: ET_ARGUMENT_OPERAND
			i, nb: INTEGER
			l_attachment: ET_DYNAMIC_ARGUMENT_ATTACHMENT
			l_agent_type: ET_DYNAMIC_ROUTINE_TYPE
			l_open_operand_type_sets: ET_DYNAMIC_TYPE_SET_LIST
			l_manifest_tuple: ET_MANIFEST_TUPLE
			l_system: ET_SYSTEM
		do
			l_system := a_builder.current_system
			a_feature.set_regular (True)
			l_actuals := static_call.arguments
			if l_actuals /= Void then
				nb := l_actuals.count
				if nb > 0 then
						-- Dynamic type sets for arguments are stored first
						-- in `dynamic_type_sets'.
					l_target_argument_type_sets := a_feature.dynamic_type_sets
					if l_target_argument_type_sets.count < nb then
							-- Internal error: it has already been checked somewhere else
							-- that there was the same number of formal arguments in
							-- feature redeclaration.
						a_builder.set_fatal_error
						a_builder.error_handler.report_gibbv_error
					elseif (a_feature.is_builtin_routine_call or a_feature.is_builtin_function_item) and then a_type.is_agent_type then
							-- This is something of the form:  'my_agent.call ([...])' or 'my_agent.item ([...])'
							-- Try to get the open operand type sets directly from the
							-- argument if it is a manifest tuple.
						l_agent_type ?= a_type
						if l_agent_type = Void then
								-- Internal error: it has to be an agent type.
							a_builder.set_fatal_error
							a_builder.error_handler.report_gibgr_error
						else
							if nb /= 1 then
									-- Internal error: 'call' or 'item' should have exactly one argument.
								a_builder.set_fatal_error
								a_builder.error_handler.report_gibgs_error
							else
								l_actual := l_actuals.actual_argument (1)
								l_manifest_tuple ?= l_actual
								if l_manifest_tuple /= Void then
									l_open_operand_type_sets := l_agent_type.open_operand_type_sets
									nb := l_open_operand_type_sets.count
									if l_manifest_tuple.count < nb then
											-- We don't get enough operands. This will be reported
											-- by the CAT-call checking.
										nb := l_manifest_tuple.count
									end
									from i := 1 until i > nb loop
										l_target_argument_type_set := l_open_operand_type_sets.item (i)
										if not l_target_argument_type_set.is_expanded then
											l_actual := l_manifest_tuple.expression (i)
											l_source_argument_type_set := current_feature.dynamic_type_set (l_actual)
											if l_source_argument_type_set = Void then
													-- Internal error: the dynamic type sets of the actual
													-- arguments should be known at this stage.
												a_builder.set_fatal_error
												a_builder.error_handler.report_gibgt_error
											else
												create l_attachment.make (l_source_argument_type_set, l_actual, current_feature, current_type)
												l_target_argument_type_set.put_source (l_attachment, l_system)
											end
										end
										i := i + 1
									end
								else
									l_target_argument_type_set := l_target_argument_type_sets.item (1)
									if not l_target_argument_type_set.is_expanded then
										l_source_argument_type_set := current_feature.dynamic_type_set (l_actual)
										if l_source_argument_type_set = Void then
												-- Internal error: the dynamic type sets of the actual
												-- arguments should be known at this stage.
											a_builder.set_fatal_error
											a_builder.error_handler.report_gibgu_error
										else
											create l_attachment.make (l_source_argument_type_set, l_actual, current_feature, current_type)
											l_target_argument_type_set.put_source (l_attachment, l_system)
										end
									end
								end
							end
						end
					else
						from i := 1 until i > nb loop
							l_target_argument_type_set := l_target_argument_type_sets.item (i)
							if not l_target_argument_type_set.is_expanded then
								l_actual := l_actuals.actual_argument (i)
								l_source_argument_type_set := current_feature.dynamic_type_set (l_actual)
								if l_source_argument_type_set = Void then
										-- Internal error: the dynamic type sets of the actual
										-- arguments should be known at this stage.
									a_builder.set_fatal_error
									a_builder.error_handler.report_gibdw_error
								else
									create l_attachment.make (l_source_argument_type_set, l_actual, current_feature, current_type)
									l_target_argument_type_set.put_source (l_attachment, l_system)
								end
							end
							i := i + 1
						end
					end
				end
			end
		end

feature -- Link

	next: like Current
			-- Next call with the same target static type

	set_next (a_next: like Current) is
			-- Set `next' to `a_next'.
		do
			next := a_next
		ensure
			next_set: next = a_next
		end

invariant

	static_call_not_void: static_call /= Void
	static_call_is_qualified: static_call.is_qualified_call
	target_type_set_not_void: target_type_set /= Void
	current_feature_not_void: current_feature /= Void
	current_type_not_void: current_type /= Void

end
