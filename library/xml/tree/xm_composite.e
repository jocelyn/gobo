indexing

	description:

		"XML nodes that can contain other xml nodes"

	library: "Gobo Eiffel XML Library"
	copyright: "Copyright (c) 2001, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class XM_COMPOSITE

inherit

	XM_NODE
		undefine
			is_equal, copy
		end

	DS_BILINEAR [XM_NODE]
		rename
			is_first as list_is_first,
			is_last as list_is_last
		undefine
			-- Descendants will bring in the DS_LINKED_LIST versions
			has, search_forth, search_back, cursor_off, occurrences,
			-- following required by Eiffel Studio
			initialized, to_array,
			equality_tester_settable, same_equality_tester,
			set_equality_tester,
			add_traversing_cursor, remove_traversing_cursor,
			start, finish, back, forth, go_before, go_after, 
			off, before, after, go_to, 
			is_empty, item_for_iteration, valid_cursor, 
			same_items, same_position,
			list_is_first, list_is_last
		end
			
	KL_IMPORTED_STRING_ROUTINES
		undefine
			is_equal, copy
		end

feature -- Access

	element_by_name (a_name: STRING): XM_ELEMENT is
			-- Direct child element with name `a_name';
			-- If there are more than one element with that name, anyone may be returned.
			-- Return Void if no element with that name is a child of current node.
		require
			a_name_not_void: a_name /= Void
		deferred
		ensure
			element_not_void: has_element_by_name (a_name) = (Result /= Void)
			--namespace: Result /= Void implies same_namespace (Result)
		end

	element_by_qualified_name (a_uri: STRING; a_name: STRING): XM_ELEMENT is
			-- Direct child element with given qualified name;
			-- If there are more than one element with that name, anyone may be returned.
			-- Return Void if no element with that name is a child of current node.
		require
			a_uri_not_void: a_uri /= Void
			a_name_not_void: a_name /= Void
		deferred
		ensure
			element_not_void: has_element_by_qualified_name (a_uri, a_name) = (Result /= Void)
		end
		
	has_element_by_name (a_name: STRING): BOOLEAN is
			-- Has current node at least one direct child
			-- element with the name `a_name'?
		require
			a_name_not_void: a_name /= Void
		deferred
		end
		
	has_element_by_qualified_name (a_uri: STRING; a_name: STRING): BOOLEAN is
			-- Has current node at least one direct child
			-- element with given qualified name ?
		require
			a_uri_not_void: a_uri /= Void
			a_name_not_void: a_name /= Void
		deferred
		end
		
	elements: DS_LIST [XM_ELEMENT] is
			-- List of all direct child elements in current element
			-- (Create a new list at each call.)
		local
			a_cursor: like new_cursor
			typer: XM_NODE_TYPER
		do
			create typer
			create {DS_BILINKED_LIST [XM_ELEMENT]} Result.make
			a_cursor := new_cursor
			from a_cursor.start until a_cursor.after loop
				a_cursor.item.process (typer)
				if typer.is_element then
					Result.force_last (typer.element)
				end
				a_cursor.forth
			end
		ensure
			not_void: Result /= Void
		end

feature -- Text

	text: STRING is
			-- Concatenation of all texts directly found in
			-- current element; Void if no text found
			-- (Return a new string at each call.)
		local
			typer: XM_NODE_TYPER
			a_cursor: like new_cursor
		do
			create typer
			a_cursor := new_cursor
			from a_cursor.start until a_cursor.after loop
				a_cursor.item.process (typer)
				if typer.is_character_data then
					if Result = Void then
						Result := clone (typer.character_data.content)
					else
						Result := STRING_.appended_string (Result, typer.character_data.content)
					end
				end
				a_cursor.forth
			end
		end

	join_text_nodes is
			-- Join sequences of text nodes.
		deferred
		end

feature -- Namespaces

	remove_namespace_declarations_from_attributes is
			-- Remove all attributes that are namespace declarations.
			-- That is any attribute whose name starts with "xmlns".
		local
			typer: XM_NODE_TYPER
			a_cursor: like new_cursor
		do
			create typer
			a_cursor := new_cursor
			from a_cursor.start until a_cursor.after loop
				a_cursor.item.process (typer)
				if typer.is_composite then
						-- Found an element, now let's check if it has "xmlns"
						-- attributes defined.
					typer.composite.remove_namespace_declarations_from_attributes
				end
				a_cursor.forth
			end
		end

feature -- Processing

	process_children (a_processor: XM_NODE_PROCESSOR) is
			-- Process direct children.
		require
			a_processor_not_void: a_processor /= Void
		local
			a_cursor: like new_cursor
		do
			a_cursor := new_cursor
			from a_cursor.start until a_cursor.after loop
				a_cursor.item.process (a_processor)
				a_cursor.forth
			end
		end

	process_children_recursive (a_processor: XM_NODE_PROCESSOR) is
			-- Process direct and indirect children.
		require
			processor_not_void: a_processor /= Void
		local
			a_cursor: like new_cursor
			typer: XM_NODE_TYPER
		do
			create typer
			a_cursor := new_cursor
			from a_cursor.start until a_cursor.after loop
				a_cursor.item.process (a_processor)
				a_cursor.item.process (typer)
				if typer.is_element then
					typer.element.process_children_recursive (a_processor)
				end
				a_cursor.forth
			end
		end
		
end
