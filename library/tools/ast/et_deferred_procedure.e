indexing

	description:

		"Eiffel deferred-procedures"

	library:    "Gobo Eiffel Tools Library"
	author:     "Eric Bezault <ericb@gobosoft.com>"
	copyright:  "Copyright (c) 1999, Eric Bezault and others"
	license:    "Eiffel Forum Freeware License v1 (see forum.txt)"
	date:       "$Date$"
	revision:   "$Revision$"

class ET_DEFERRED_PROCEDURE

inherit

	ET_PROCEDURE
		undefine
			is_deferred
		end

	ET_DEFERRED_ROUTINE

creation

	make, make_with_seeds

feature {NONE} -- Initialization

	make (a_name: like name; args: like arguments; an_obsolete: like obsolete_message;
		a_preconditions: like preconditions; a_postconditions: like postconditions;
		a_clients: like clients; a_class: like base_class) is
			-- Create a new deferred procedure.
		require
			a_name_not_void: a_name /= Void
			a_clients_not_void: a_clients /= Void
			a_class_not_void: a_class /= Void
		do
			make_with_seeds (a_name, args, an_obsolete, a_preconditions,
				a_postconditions, a_clients, a_class, new_seeds)
		ensure
			name_set: name = a_name
			arguments_set: arguments = args
			obsolete_message_set: obsolete_message = an_obsolete
			preconditions_set: preconditions = a_preconditions
			postconditions_set: postconditions = a_postconditions
			clients_set: clients = a_clients
			version_set: version = Current
			base_class_set: base_class = a_class
			implementation_class_set: implementation_class = a_class
		end

	make_with_seeds (a_name: like name; args: like arguments; an_obsolete: like obsolete_message;
		a_preconditions: like preconditions; a_postconditions: like postconditions;
		a_clients: like clients; a_class: like base_class; a_seeds: like seeds) is
			-- Create a new deferred procedure.
		require
			a_name_not_void: a_name /= Void
			a_clients_not_void: a_clients /= Void
			a_class_not_void: a_class /= Void
			a_seeds_not_void: a_seeds /= Void
			a_seeds_valid: valid_seeds (a_seeds)
		do
			name := a_name
			arguments := args
			obsolete_message := an_obsolete
			preconditions := a_preconditions
			postconditions := a_postconditions
			clients := a_clients
			version := Current
			base_class := a_class
			implementation_class := a_class
			seeds := a_seeds
		ensure
			name_set: name = a_name
			arguments_set: arguments = args
			obsolete_message_set: obsolete_message = an_obsolete
			preconditions_set: preconditions = a_preconditions
			postconditions_set: postconditions = a_postconditions
			clients_set: clients = a_clients
			version_set: version = Current
			base_class_set: base_class = a_class
			implementation_class_set: implementation_class = a_class
			seeds_set: seeds = a_seeds
		end

feature -- Duplication

	synonym (a_name: like name): like Current is
			-- Synonym feature
		do
			!! Result.make (a_name, arguments, obsolete_message,
				preconditions, postconditions, clients, base_class)
		end

feature -- Conversion

	renamed_feature (a_name: like name; a_class: like base_class): like Current is
			-- Renamed version of current feature
		do
			!! Result.make_with_seeds (a_name, arguments, obsolete_message,
				preconditions, postconditions, clients, a_class, seeds)
			Result.set_version (version)
			Result.set_implementation_class (implementation_class)
		end

end -- class ET_DEFERRED_PROCEDURE
