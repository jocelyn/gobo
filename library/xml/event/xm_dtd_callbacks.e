indexing

	description: 

		"Callbacks for DTD declaration"

	library: "Gobo Eiffel XML Library"
	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "Eiffel Forum License v1 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class XM_DTD_CALLBACKS

feature -- Document type definuition callbacks

	on_doctype (name: UC_STRING; an_id: XM_DTD_EXTERNAL_ID; has_internal_subset: BOOLEAN) is
			-- Document type declaration.
		require
			name_not_void: name /= Void
		deferred
		end

	on_element_declaration (a_name: UC_STRING; a_model: XM_DTD_ELEMENT_CONTENT) is
			-- Element declaration.
		require
			name_not_void: a_name /= Void
			model_not_void: a_model /= Void
		deferred
		end

	on_attribute_declaration (an_element_name, a_name: UC_STRING; a_model: XM_DTD_ATTRIBUTE_CONTENT) is
			-- Attribute declaration, one event per attribute.
		require
			element_name_not_void: an_element_name /= Void
			name_not_void: a_name /= Void
			model_not_void: a_model /= Void
		deferred
		end

	on_entity_declaration (entity_name: UC_STRING; is_parameter: BOOLEAN; value: UC_STRING; 
			an_id: XM_DTD_EXTERNAL_ID; notation_name: UC_STRING) is
			 -- Entity declaration.
		require
			entity_name_not_void: entity_name /= Void
			--internal_entity implies value /= Void
			--external_entity implies an_id /= Void
			--unparsed_entity implies an_id /= Void and notation_name /= Void
		deferred
		end

	on_notation_declaration (notation_name: UC_STRING; an_id: XM_DTD_EXTERNAL_ID) is
			-- Notation declaration.
		require
			notation_name_not_void: notation_name /= Void
			id_not_void: an_id /= Void
		deferred
		end

end
