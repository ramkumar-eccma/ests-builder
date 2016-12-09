class FactoryController < ApplicationController
  def new
  	language =I18n.locale
  	@factory_temp=FactoryTemplate.all.where("language = ?",language)
  end
end
