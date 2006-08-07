indexing
	description: 

		"Options that are not flags and need a parameter"

	author: "Bernd Schoeller"
	copyright: "(c) 2006 Bernd Schoeller (bernd@fams.de) and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class AP_OPTION_WITH_PARAMETER [G]

inherit
	
	AP_OPTION
		redefine
			initialize,
			example,
			names
		end
		
feature {NONE} -- Initialization

	initialize is
			-- Perform the common initialization steps
		do
			Precursor {AP_OPTION}
			parameter_description := "arg"
		end

feature -- Access

	example: STRING is
			-- Example for the usage of the option
		do
			if is_mandatory then
				create Result.make_empty
			else
				Result := "["
			end
			Result.append_character (short_option_introduction)
			if has_short_form then
				Result.append_string (short_form.out)
				Result.append_character (' ')
				Result.append_string (parameter_description)
			else
				Result.append_character (long_option_introduction)
				Result.append_string (long_form)
				Result.append_character (long_option_parameter_introduction)
				Result.append_string (parameter_description)
			end
			if not is_mandatory then
				Result.append_character (']')
			end
		end

	names: STRING is
			-- Names of the option (short and long)
		do
			Result := Precursor {AP_OPTION}
			if has_long_form then
				Result.append_string (long_option_parameter_introduction.out)
			else
				Result.append_character (' ')			
			end
			Result.append_string (parameter_description)
		end

	parameter_description: STRING
		-- Name of the parameter

	parameter: G is
			-- Last value give to the option
		require
			was_found: was_found
		do
			Result := parameters.last
		end

	parameters: DS_LIST [G] is
			-- All parameters given to the option
		deferred
		end

	occurrences: INTEGER is
			-- Number of times this flag was encountered
		do
			Result := parameters.count
		end	

feature -- Status report

	needs_parameter: BOOLEAN is
			-- Does this option need a parameter ?
		do
			Result := True
		end
		
feature -- Status setting

	set_parameter_description (a_string: STRING) is
			-- Set the parameter name to `a_string'.
		require
			not_void: a_string /= VOid
		do
			parameter_description := a_string
		ensure
			parameter_set: parameter_description = a_string
		end

invariant

	options_needs_parameter: needs_parameter
	parameters_exist: parameters /= Void

end