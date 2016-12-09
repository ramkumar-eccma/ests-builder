require 'safe_attributes/base'
class Rv < ActiveRecord::Base
	self.abstract_class = true
	establish_connection("etsr_#{Rails.env}")
end
class EtsrRxmlValue < Rv
	include SafeAttributes::Base
	self.table_name = 'rxml_value'
end