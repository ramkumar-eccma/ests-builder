require 'safe_attributes/base'
class Rvd < ActiveRecord::Base
	self.abstract_class = true
	establish_connection("etsr_#{Rails.env}")
end
class EtsrRxmlValueDelete < Rvd
	include SafeAttributes::Base
	self.table_name = 'rxml_value_deletes'
end