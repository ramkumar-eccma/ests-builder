require 'safe_attributes/base'
class Mm < ActiveRecord::Base
	self.abstract_class = true
	establish_connection("etsr_#{Rails.env}")
end
class EtsrMaterialMaster < Mm
	include SafeAttributes::Base
	self.table_name = 'material_master'
end