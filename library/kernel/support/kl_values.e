indexing

	description:

		"Values that are accessible through keys"

	library: "Gobo Eiffel Kernel Library"
	copyright: "Copyright (c) 2004, Eric Bezault and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class KL_VALUES [G, K]

feature -- Access

	value (k: K): G is
			-- Item associated with `k';
			-- Return default value if no such item
		require
			k_not_void: k /= Void 
		deferred
		end

end
