indexing

	description:

		"Interface for input streams"

	library:    "Gobo Eiffel Kernel Library"
	author:     "Eric Bezault <ericb@gobosoft.com>"
	copyright:  "Copyright (c) 2001, Eric Bezault and others"
	license:    "Eiffel Forum Freeware License v1 (see forum.txt)"
	date:       "$Date$"
	revision:   "$Revision$"

deferred class KI_INPUT_STREAM [G]

inherit

	ANY
		undefine
				-- Needed for VE.
			copy
		end

feature -- Input

	read is
			-- Read the next item in input stream.
			-- Make the result available in `last_item'.
		require
			is_open_read: is_open_read
			not_end_of_input: not end_of_input
		deferred
		end

	unread (an_item: G) is
			-- Put `an_item' back in input stream.
			-- This item will be read first by the next
			-- call to a read routine.
		require
			is_open_read: is_open_read
			an_item_valid: valid_unread_item (an_item)
		deferred
		ensure
			not_end_of_input: not end_of_input
			last_item_set: last_item = an_item
		end

	read_to_buffer (a_buffer: KI_BUFFER [G]; pos, nb: INTEGER): INTEGER is
			-- Fill `a_buffer', starting at position `pos', with
			-- at most `nb' items read from input stream.
			-- Return the number of items actually read.
		require
			is_open_read: is_open_read
			not_end_of_input: not end_of_input
			a_buffer_not_void: a_buffer /= Void
			pos_large_enough: pos >= 1
			nb_large_enough: nb > 0
			enough_space: (pos + nb - 1) <= a_buffer.count
		local
			i, end_pos: INTEGER
		do
			end_pos := pos + nb - 1
			from i := pos until i > end_pos loop
				read
				if not end_of_input then
					a_buffer.put (last_item, i)
					i := i + 1
				else
					Result := i - pos - nb
					i := end_pos + 1 -- Jump out of the loop.
				end
			end
			Result := Result + i - pos
		ensure
			nb_item_read_large_enough: Result >= 0
			nb_item_read_small_enough: Result <= nb
			not_end_of_input: not end_of_input implies Result > 0
		end

feature -- Status report

	is_open_read: BOOLEAN is
			-- Can items be read from input stream?
		deferred
		end

	end_of_input: BOOLEAN is
			-- Has the end of input stream been reached?
		require
			is_open_read: is_open_read
		deferred
		end

	valid_unread_item (an_item: G): BOOLEAN is
			-- Can `an_item' be put back in input stream?
		deferred
		end

feature -- Access

	name: STRING is
			-- Name of input stream
		deferred
		ensure
			name_not_void: Result /= Void
		end

	last_item: G is
			-- Last item read
		require
			is_open_read: is_open_read
			not_end_of_input: not end_of_input
		deferred
		end

end -- class KI_INPUT_STREAM
