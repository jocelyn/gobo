indexing

	description:

		"Geant tasks"

	library: "Gobo Eiffel Ant"
	copyright: "Copyright (c) 2001, Sven Ehrke and others"
	license: "Eiffel Forum License v1 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class GEANT_GEANT_TASK

inherit

	GEANT_TASK
		rename
			make as task_make
		redefine
			command
		end

creation

	make

feature {NONE} -- Initialization

	make (a_project: GEANT_PROJECT; an_xml_element: XM_ELEMENT) is
			-- Create a new task with information held in `an_element'.
		local
			a_value: STRING
		do
			!! command.make (a_project)
			task_make (command, an_xml_element)
				-- filename:
			if has_attribute (Filename_attribute_name) then
				a_value := attribute_value (Filename_attribute_name)
				if a_value.count > 0 then
					command.set_filename (a_value)
				end
			end
				-- start target:
			if has_attribute (Start_target_attribute_name) then
				a_value := attribute_value (Start_target_attribute_name)
				if a_value.count > 0 then
					command.set_start_target_name (a_value)
				end
			end
				-- reuse_variables:
			if has_attribute (Reuse_variables_attribute_name) then
				command.set_reuse_variables (boolean_value (Reuse_variables_attribute_name))
			end
		end

feature -- Access

	command: GEANT_GEANT_COMMAND
			-- Getest commands

feature {NONE} -- Constants

	Filename_attribute_name: STRING is
			-- Name of xml attribute filename.
		once
			Result := "file"
		ensure
			attribute_name_not_void: Result /= Void
			atribute_name_not_empty: Result.count > 0
		end

	Start_target_attribute_name: STRING is
			-- Name of xml attribute Start_target.
		once
			Result := "target"
		ensure
			attribute_name_not_void: Result /= Void
			atribute_name_not_empty: Result.count > 0
		end

	Reuse_variables_attribute_name: STRING is
			-- Name of xml attribute reuse_variables.
		once
			Result := "reuse_variables"
		ensure
			attribute_name_not_void: Result /= Void
			atribute_name_not_empty: Result.count > 0
		end

end
