indexing

	description:

		"XPath expression equality testers"

	library: "Gobo Eiffel XPath Library"
	copyright: "Copyright (c) 2004, Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class XM_XPATH_EXPRESSION_TESTER

inherit

	KL_EQUALITY_TESTER [XM_XPATH_EXPRESSION]
		redefine
			test
		end

feature -- Status report

	test (v, u: XM_XPATH_EXPRESSION): BOOLEAN is
			-- Are `v' and `u' considered equal?
		do
			if v = Void then
				Result := (u = Void)
			elseif u = Void then
				Result := False
			else
				Result := v.same_expression (u)
			end
		end

end