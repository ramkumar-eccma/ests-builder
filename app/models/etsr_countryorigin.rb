require 'safe_attributes/base'
class Co < ActiveRecord::Base
	self.abstract_class = true
	establish_connection("etsr_#{Rails.env}")
end
class EtsrCountryorigin < Co
	include SafeAttributes::Base
	self.table_name = 'countryorigins'
end