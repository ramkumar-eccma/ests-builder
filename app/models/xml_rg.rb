require 'safe_attributes/base'
class XmlRg < ActiveRecord::Base
	include SafeAttributes::Base
	self.table_name = 'xml_rg'
end
