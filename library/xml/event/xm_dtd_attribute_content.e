indexing

	description:

		"Declarations of attribute content in DTD"

	library: "Gobo Eiffel XML Library"
	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "Eiffel Forum License v1 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class XM_DTD_ATTRIBUTE_CONTENT

inherit

	ANY
		redefine
			out
		end

	UC_UNICODE_FACTORY
		export
			{NONE} all
		undefine
			out
		end

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		undefine
			out
		end

creation

	make

feature {NONE} -- Initialization

	make is
			-- Create a new DTD attribute content.
		do
			set_data
			set_value_implied
		ensure
			no_name: not has_name
			no_default: not has_default_value
			data: is_data
			implied: is_value_implied
		end

feature -- Output

	out: STRING is
			-- Like in DTD.
		do
				-- Name.
			if has_name then
				Result := clone (name)
			else
				Result := clone ("?")
			end
				-- Type.
			Result.append_character (' ')
			if is_data then
				Result.append_string ("CDATA")
			elseif is_id then
				Result.append_string ("ID")
			elseif is_id_ref then
				Result.append_string ("IDREF")
			elseif is_entity then
				Result.append_string ("ENTITY")
			elseif is_token then
				Result.append_string ("NMTOKEN")
			elseif is_notation then
				Result.append_string ("NOTATION")
			end
			if is_list_type then
				Result.append_string ("S")
			end
			Result.append_character (' ')
				-- Default.
			if is_value_required then
				Result.append_string ("#REQUIRED")
			elseif is_value_implied then
				Result.append_string ("#IMPLIED")
			elseif is_value_fixed then
				Result.append_string ("#FIXED ")
			end
			if has_default_value then
				Result.append_string (" %"")
				Result := STRING_.appended_string (Result, default_value)
				Result.append_character ('%"')
			end
		end

feature -- Name content type

	name: STRING
			-- Attribute name

	set_name (a_name: like name) is
			-- Set name.
		require
			a_name_not_void: a_name /= Void
		do
			name := a_name
		ensure
			name_set: name = a_name
		end

	has_name: BOOLEAN is
			-- Has name been set?
		do
			Result := name /= Void
		end

feature {NONE} -- Implementation

	type: CHARACTER
			-- Enumeration for type

	value: CHARACTER
			-- Enumeration for default value

feature -- Default value

	default_value: STRING
			-- require has_default_value
			-- ensure Result /= Void

	set_default_value (a_value: like default_value) is
			-- Set default value.
		require
			a_value_not_void: a_value /= Void
		do
			value := 'D'
			default_value := a_value
		ensure
			default_value_set: default_value = a_value
		end

	has_default_value: BOOLEAN is
			-- Is there a default value?
		do
			Result := default_value /= Void
		end

	copy_default (other: XM_DTD_ATTRIBUTE_CONTENT) is
			-- Copy default value settings from 'other'.
		require
			other_not_void: other /= Void
		do
			if other.is_value_fixed then
				set_value_fixed (other.default_value)
			elseif other.has_default_value then
				set_default_value (other.default_value)
			end
			if other.is_value_required then
				set_value_required
			elseif other.is_value_implied then
				set_value_implied
			end
		end

feature -- Defaults

	is_value_required: BOOLEAN is
			-- Is attribute value required?
		do
			Result := value = 'R'
		end

	set_value_required is
			-- Attribute value required.
		do
			value := 'R'
		ensure
			set: is_value_required
		end

	is_value_implied: BOOLEAN is
			-- Is attribute value implied?
		do
			Result := value = 'I'
		end

	set_value_implied is
			-- Attribute value implied.
		do
			value := 'I'
		ensure
			set: is_value_implied
		end

	is_value_fixed: BOOLEAN is
			-- Is value fixed?
		do
			Result := value = 'F'
		end

	set_value_fixed (a_value: like default_value) is
			-- Set fixed value.
		require
			a_value_not_void: a_value /= Void
		do
			set_default_value (a_value)
			value := 'F'
		ensure
			set: is_value_fixed
			has_default: has_default_value
		end

feature -- String content type

	is_data: BOOLEAN is
			-- CDATA, arbitrary character data?
		do
			Result := type = 'C'
		end

	set_data is
			-- CDATA.
		do
			type := 'C'
		ensure
			set: is_data
		end

feature -- Enumerated content type

	is_notation: BOOLEAN is
			-- NOTATION?
		do
			Result := type = 'N'
		end

	set_notation is
			-- NOTATION.
		do
			type := 'N'
		ensure
			set: is_notation
		end

	is_enumeration: BOOLEAN is
			-- Fixed enumeration?
		do
			Result := type = 'U'
		end

	set_enumeration is
			-- Fixed enumeration.
		do
			type := 'U'
		ensure
			set: is_enumeration
		end

feature -- Tokenized content type

	is_id: BOOLEAN is
			-- ID (identifier declaration)?
		do
			Result := type = 'I'
		end

	set_id is
			-- ID.
		do
			type := 'I'
		ensure
			set: is_id
		end

	is_id_ref: BOOLEAN is
			-- IDREF (identifier reference)?
		do
			Result := type = 'R'
		end

	set_id_ref is
			-- IDREF.
		do
			type := 'R'
		ensure
			set: is_id_ref
		end

	is_entity: BOOLEAN is
			-- ENTITY?
		do
			Result := type = 'E'
		end

	set_entity is
			-- ENTITY.
		do
			type := 'E'
		ensure
			set: is_entity
		end

	is_token: BOOLEAN is
			-- NMTOKEN?
		do
			Result := type = 'T'
		end

	set_token is
			-- NMTOKEN.
		do
			type := 'T'
		ensure
			set: is_token
		end

	is_list_type: BOOLEAN
			-- Is the type a list (NMTOKENS, ENTITIES, IDREFS)?

	set_list_type is
			-- Set type to list.
		require
			valid: is_token or is_entity or is_id_ref
		do
			is_list_type := True
		ensure
			set: is_list_type
		end

invariant

	exclusive: is_token xor is_entity xor is_id_ref xor is_id xor is_data xor is_notation xor is_enumeration
	list_ok: is_list_type implies (is_token or is_entity or is_id_ref)
	impl_type_enumeration: ("CIRETNU").has (type)
	impl_default_enumeration: ("DRIF").has (value)

end
