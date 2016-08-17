require 'safe_attributes/base'
class RxmlReference < ActiveRecord::Base
	include SafeAttributes::Base
	self.table_name = 'rxml_reference'
end
