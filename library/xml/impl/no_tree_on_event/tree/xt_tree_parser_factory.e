class
   XT_TREE_PARSER_FACTORY
inherit
   XM_TREE_PARSER_FACTORY
creation
   make
feature
   make (a_event_parser_factory: XM_EVENT_PARSER_FACTORY) is
      require
	 a_event_parser_factory_not_void: a_event_parser_factory /= Void
      do
	 event_parser_factory := a_event_parser_factory
      ensure
	 event_parser_factory_set: event_parser_factory = a_event_parser_factory
      end
feature

   is_available: BOOLEAN is False

   new_tree_parser: XM_TREE_PARSER is
      do
      end

   new_tree_parser_imp: XI_TREE_PARSER is
      do
      end

feature {NONE} -- Implementation

   event_parser_factory: XM_EVENT_PARSER_FACTORY

end -- class XT_TREE_PARSER_FACTORY

