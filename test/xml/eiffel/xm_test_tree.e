indexing

	description:

		"Test XML tree"

	library: "Gobo Eiffel XML Library"
	copyright: "Copyright (c) 2001, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class XM_TEST_TREE

inherit
	TS_TEST_CASE
	
feature

	test_simple is
			-- Simple tree.
		local
			a_root: XM_ELEMENT 
		do
			make_parser
			parser.parse_from_string ("<doc><a/><b/></doc>")
			assert ("parsing error", not tree_pipe.error.has_error)
			
			if not tree_pipe.error.has_error then
				assert_has_element (tree_pipe.document, "doc")
				a_root := tree_pipe.document.root_element
				assert_equal ("root name", a_root.name, "doc")
				assert_has_element (a_root, "a")
				assert_has_element (a_root, "b")
			end
		end
		
	test_walk is
			-- Walk through tree.
		do
			make_parser
			parser.parse_from_string ("<!-- pre -->"
				+"<doc>"
				+"  <a b='foo'></a><b/><!--inline--><c>zoo</c>"
				+"</doc>"
				+"<!-- post -->")
		
			go_root
			assert_first
			assert_document
			go_down
			assert_first
			assert_comment (" pre ")
			go_next
			assert_element ("doc")
			go_down
			assert_text_space
			go_next
			assert_element ("a")
			go_down
			assert_attribute ("b", "foo")
			assert_single
			go_up
			go_next
			assert_element ("b")
			assert_childless
			go_next
			assert_comment ("inline")
			go_next
			assert_element ("c")
			go_down
			assert_text ("zoo")
			assert_single
			go_up
			assert_last 
			go_up
			go_next
			assert_comment (" post ")
			assert_last
		end
		
	test_walk_namespaces is
			-- Walk through tree with namespaces.
		do
			make_parser
			parser.parse_from_string ("<doc xmlns='uri1'>"
				+"<a/><b xmlns='uri2'/>"
				+"<ns1:c xmlns:ns1='uri3' xmlns:ns2='uri4' a1='foo1' ns2:a2='foo2'/>"
				+"</doc>")
			
			go_root
			go_down
			assert_single
			assert_ns_element ("uri1", "doc")
			go_down
			assert_ns_element ("uri1", "a")
			go_next
			assert_ns_element ("uri2", "b")
			go_next
			assert_ns_element ("uri3", "c")
			assert_last
			go_down
			assert_first
			assert_ns_attribute ("", "a1", "foo1")
			go_next
			assert_ns_attribute ("uri4", "a2", "foo2")
			assert_last
		end
			
			
feature {NONE} -- Walk navigation

	node: XM_NODE
			-- Node.
			
	typer: XM_NODE_TYPER
	
	go_root is
			-- Go to root node.
		do
			node := tree_pipe.document
			create typer
		end
	
	go_up is
			-- Go to parent.
		do
			assert ("has parent", not node.is_root_node)
			node := node.parent
		end
	
	go_down is
			-- Go to first child.
		do
			node.process (typer)
			assert ("down: is composite", typer.is_composite)
			assert ("down: has child", typer.composite.count > 0)
			node := typer.composite.first
		end
		
	go_next is
			-- Move to next sibling, or don't 
			-- move if last sibling.
		local
			it: DS_LINEAR_CURSOR [XM_NODE]
		do
			from 
				it := node.parent.new_cursor
				it.start
			invariant
				-- exists it.item = node
			until
				it.item = node
			loop
				it.forth
			end
			
			check not_after: not it.after end
			it.forth
			if not it.after then	
				node := it.item
				it.go_after
			-- else at end so don't move
			end
			
			check out: it.after end
		end
		
feature {NONE} -- Walk assertions

	assert_document is
			-- Node is document.
		do
			node.process (typer)
			assert ("document node expected", typer.is_document)
		end
		
	assert_comment (a: STRING) is
			-- Assert current node is a comment.
		require
			a_not_void: a /= Void
		do
			node.process (typer)
			assert ("comment expected", typer.is_comment)
			assert_equal ("comment value", a, typer.comment.data)
		end
		
		
	assert_element (a_name: STRING) is
			-- Node is an element.
		require
			a_name_not_void: a_name /= Void
		do
			node.process (typer)
			assert ("element expected", typer.is_element)
			assert_equal ("element name", a_name, typer.element.name)
		end
	
	assert_ns_element (a_ns: STRING; a_name: STRING) is
			-- Node is an element (with namespace).
		require
			a_ns_not_void: a_ns /= Void
			a_name_not_void: a_name /= Void
		do
			assert_element (a_name)
			node.process (typer)
			assert_equal ("element namespace", a_ns, typer.element.namespace.uri)
		end
		
	assert_childless is
			-- Node is empty composite.
		do
			node.process (typer)
			assert ("composite expected", typer.is_composite)
			assert ("composite not empty", typer.composite.count = 0)
		end
		
	assert_attribute (a_name: STRING; a_value: STRING) is
			-- Node is an attribute.
		require
			a_named_not_void: a_name /= Void
			a_value_not_void: a_value /= Void
		local
			an_attribute: XM_ATTRIBUTE
		do
			node.process (typer)
			assert ("attribute expected", typer.is_attribute)
			an_attribute := typer.attribute
			assert_equal ("attribute name", a_name, an_attribute.name)
			assert_equal ("attribute value", a_value, an_attribute.value)
			
			assert_attribute_element (an_attribute)
		end
		
	assert_attribute_element (an_attribute: XM_ATTRIBUTE) is
			-- Checks on attributes parent element.
		require
			an_atttribute_not_void: an_attribute /= Void
		do
			an_attribute.parent.process (typer)
			assert ("parent element", typer.is_element)
			if an_attribute.namespace.is_default_namespace then
				assert ("unprefixed by name", typer.element.has_attribute_by_name (an_attribute.name))
			else
				assert ("prefixed not by name", not typer.element.has_attribute_by_name (an_attribute.name))
			end
		end
		
	assert_ns_attribute (a_ns: STRING; a_name: STRING; a_value: STRING) is
			-- Node is an attribute (with namespace).
		require
			a_ns_not_void: a_ns /= Void
			a_named_not_void: a_name /= Void
			a_value_not_void: a_value /= Void
		do
			assert_attribute (a_name, a_value)
			node.process (typer)
			assert_equal ("attribute namespace", a_ns, typer.attribute.namespace.uri)
		end
		
	assert_last is
			-- Node is last in parent.
		do
			assert ("last", node.is_last)
		end
		
	assert_first is
			-- Node is first in parent.
		do
			assert ("first", node.is_first)
		end
		
	assert_text (a: STRING) is
			-- Assert text node
		require
			a_not_void: a /= Void
		do
			node.process (typer)
			assert ("text node expected", typer.is_character_data)
			assert_equal ("text", a, typer.character_data.content)
		end
		
	assert_text_space is
			-- Assert text node with only spaces.
		local
			i: INTEGER
			a_string: STRING
			space_code: INTEGER
		do
			node.process (typer)
			assert ("text expected", typer.is_character_data)
			from
				a_string := typer.character_data.content
				space_code := (' ').code
				i := 1
			until
				i > a_string.count
			loop
				assert ("non space in character data",
						a_string.item_code (i) <= space_code)
				i := i + 1
			end
		end
	
	assert_single is
			-- Node is singleton.
		do
			assert ("singleton", node.is_first and node.is_last)
		end
		
feature {NONE} -- Implementation

	assert_has_element (a: XM_COMPOSITE; a_name: STRING) is
			-- Test element_by_name.
		require
			a_not_void: a /= Void
			a_name_not_void: a_name /= Void
		do
			assert ("has element", a.has_element_by_name (a_name))
			if a.has_element_by_name (a_name) then
				assert_equal ("element name", a.element_by_name (a_name).name, a_name)
			end
		end

feature {NONE} -- Implementation
		
	make_parser is
		do
			create parser.make
			create tree_pipe.make
			parser.set_callbacks (tree_pipe.start)
		end
		
	parser: XM_EIFFEL_PARSER
	tree_pipe: XM_TREE_CALLBACKS_PIPE
	
end
