require 'safe_attributes/base'
class RxmlValue < ActiveRecord::Base
	include SafeAttributes::Base
	self.table_name = 'rxml_value'
end
