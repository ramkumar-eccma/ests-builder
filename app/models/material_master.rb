require 'safe_attributes/base'
class MaterialMaster < ActiveRecord::Base
	include SafeAttributes::Base
	self.table_name = 'material_master'
end
