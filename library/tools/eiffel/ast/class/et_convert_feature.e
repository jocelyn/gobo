indexing

	description:

		"Eiffel conversion features"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2003, Eric Bezault and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class ET_CONVERT_FEATURE

inherit

	ET_CONVERT_FEATURE_ITEM

feature -- Status report

	is_convert_from: BOOLEAN is
			-- Is it a conversion from another type?
		do
			-- Result := False
		end

	is_convert_to: BOOLEAN is
			-- Is it a conversion to another type?
		do
			-- Result := False
		end

feature -- Access

	name: ET_FEATURE_NAME
			-- Name of conversion feature

	types: ET_TYPE_LIST
			-- Conversion types

	position: ET_POSITION is
			-- Position of first character of
			-- current node in source code
		do
			Result := name.position
		end

	convert_feature: ET_CONVERT_FEATURE is
			-- Conversion feature in comma-separated list
		do
			Result := Current
		end

invariant

	name_not_void: name /= Void
	types_not_void: types /= Void

end