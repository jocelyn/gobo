indexing

	description:

		"Eiffel null attachments at run-time"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2004, Eric Bezault and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ET_NULL_DYNAMIC_ATTACHMENT

inherit

	ET_DYNAMIC_ATTACHMENT
		redefine
			is_null_attachment
		end

	ET_SHARED_TOKEN_CONSTANTS
		export {NONE} all end

creation

	make

feature {NONE} -- Initialization

	make (a_type: like source_type; a_current_feature: like current_feature; a_current_type: like current_type) is
			-- Create a new null attachment.
		require
			a_type_not_void: a_type /= Void
			a_current_feature_not_void: a_current_feature /= Void
			a_current_type_not_void: a_current_type /= Void
		do
			source_type := a_type
			current_feature := a_current_feature
			current_type := a_current_type
		ensure
			source_type_set: source_type = a_type
			current_feature_set: current_feature = a_current_feature
			current_type_set: current_type = a_current_type
		end

feature -- Status report

	is_null_attachment: BOOLEAN is True
			-- Should current attachment be ignored when reporting errors?

feature -- Access

	position: ET_POSITION is
			-- Position of attachment
		once
			Result := tokens.null_position
		end

feature -- Duplication

	cloned_attachment: like Current is
			-- Cloned version of current attachment
		do
			create Result.make (source_type, current_feature, current_type)
		end

end