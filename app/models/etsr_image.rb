require 'safe_attributes/base'
class Im < ActiveRecord::Base
	self.abstract_class = true
	establish_connection("etsr_#{Rails.env}")
end
class EtsrImage < Im
	include SafeAttributes::Base
	self.table_name = 'images'
end