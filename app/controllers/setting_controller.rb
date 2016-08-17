class SettingController < ApplicationController
	def index
		@len=Setting.where("organization_ID=123")
		@length_sd=params[:length_sd]
		@length_ld=params[:length_ld]    
		@class_prop_sep_SD=params[:class_prop_sep_SD]  
		@class_prop_sep_LD=params[:class_prop_sep_LD]
		@prop_val_sep_SD=params[:prop_val_sep_SD]
		@prop_val_sep_LD=params[:prop_val_sep_LD]
		@char_sep_SD=params[:charac_sep_SD]                                                                             
		@char_sep_LD=params[:charac_sep_LD]
		@case_SD=params[:sh_case]
		@case_LD=params[:lg_case]
		@case_val=params[:Val_case]
		@settings=Setting.where("organization_ID=123")
		
		if @length_ld
			@settings=Setting.where("organization_ID=123").update_all({length_SD: @length_sd,length_LD: @length_ld,
			class_prop_sep_SD: @class_prop_sep_SD,class_prop_sep_LD: @class_prop_sep_LD,prop_value_sep_SD: @prop_val_sep_SD,
			prop_value_sep_LD: @prop_val_sep_LD,charac_sep_SD: @char_sep_SD,charac_sep_LD: @char_sep_LD,short_desc_case: @case_SD,long_desc_case: @case_LD,value_case: @case_val})  
		end
	end
end
