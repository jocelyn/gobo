class AA

create

	make

feature

	make is
		do
			f
		end

	f is
		local
			a: ANY
		do
			a := cc
		end

	cc: INTEGER_16 = {INTEGER_8} 0x1000
			-- 0x1000 is not representable as an INTEGER_8,
			-- even though it is representable as an INTEGER_16

end
