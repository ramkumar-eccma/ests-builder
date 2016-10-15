require 'safe_attributes/base'
class Organization < ActiveRecord::Base
	include SafeAttributes::Base
	# self.table_name = 'Organization'
end
