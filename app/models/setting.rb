require 'safe_attributes/base'
class Setting < ActiveRecord::Base
	 include SafeAttributes::Base
end
