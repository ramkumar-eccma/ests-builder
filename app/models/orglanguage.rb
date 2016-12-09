require 'safe_attributes/base'
class Orglanguage < ActiveRecord::Base
	include SafeAttributes::Base
	self.table_name = 'language'
end
