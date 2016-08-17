class HomeController < ApplicationController
    def index
        @organization = current_user.Organization_ID
        if params[:search]
           @vs = params[:search]
           @madein_ksa = MaterialMaster.where("organization_ID = ? AND datedeleted = ?",@organization,'0000-00-00 00:00:00').where("legacy_description like ? OR material_id like ? OR cat_id like ? OR short_description like ? OR long_description like ?","%#{@vs}%","%#{@vs}%","%#{@vs}%","%#{@vs}%","%#{@vs}%").paginate(:page => params[:page], :per_page => 12)
           @madein_count = MaterialMaster.where("legacy_description like ? OR material_id like ? OR cat_id like ? OR short_description like ? OR long_description like ?","%#{@vs}%","%#{@vs}%","%#{@vs}%","%#{@vs}%","%#{@vs}%").where("organization_ID = ? AND datedeleted = ?",@organization,'0000-00-00 00:00:00').count
        else
            @madein_ksa = MaterialMaster.where("organization_ID = ? and datedeleted = ?",@organization,'0000-00-00 00:00:00').paginate(:page => params[:page], :per_page => 12)
            @madein_count = MaterialMaster.where("organization_ID = ? and datedeleted = ?",@organization,'0000-00-00 00:00:00').count
        end        
    end

    def modalclass
        @listall = params[:listall]

        if @listall=='1'
            @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.language_code='en' and a.concept_type_ID='0161-1#CT-01#1' and a.term_content!='' ORDER BY `b`.`Class_Name` DESC Limit 100"])            

        elsif @listall=='0' 
            @class_name = params[:class_name]
            @organization = params[:organization]
            @language = params[:language]
            @query = params[:query]
            
            if @query=="like"
                if @class_name!=''  && @organization!='' && @language!=''
                   @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.language_code= ? and a.concept_type_ID= ? and a.term_content!= ? and a.term_organization_name = ? AND a.term_content like ? ORDER BY `b`.`Class_Name` DESC Limit 100",@language,'0161-1#CT-01#1','',@organization,"%#{@class_name}%"])

                elsif @class_name!='' && @organization=='' && @language==''
                    @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.concept_type_ID=? and a.term_content!=? AND a.term_content like ? ORDER BY `b`.`Class_Name` DESC Limit 100",'0161-1#CT-01#1','',"%#{@class_name}%"])

                elsif @organization!='' && @class_name=='' && @language==''
                    @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.concept_type_ID=? and a.term_content!=? AND a.term_organization_name = ? ORDER BY `b`.`Class_Name` DESC Limit 100",'0161-1#CT-01#1','',@organization])

                elsif @language!='' && @organization=='' && @class_name==''
                    @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.concept_type_ID=? and a.term_content!=? AND a.language_code = ? ORDER BY `b`.`Class_Name` DESC Limit 100",'0161-1#CT-01#1','',@language])
                
                elsif @class_name!='' && @organization!='' && @language==''
                    @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.concept_type_ID=? and a.term_content!=? AND a.term_organization_name = ? AND a.term_content like ? ORDER BY `b`.`Class_Name` DESC Limit 100",'0161-1#CT-01#1','',@organization,"%#{@class_name}%"])

                elsif @class_name!='' && @organization=='' && @language!=''
                     @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.concept_type_ID = ? and a.term_content!= ? AND a.language_code = ? AND a.term_content like ? ORDER BY `b`.`Class_Name` DESC Limit 100",'0161-1#CT-01#1','',@language,"%#{@class_name}%"])

                elsif @class_name=='' && @organization!='' && @language!=''
                    @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.concept_type_ID=? and a.term_content!=? AND a.language_code = ? AND a.term_organization_name = ? ORDER BY `b`.`Class_Name` DESC Limit 100",'0161-1#CT-01#1','',@language,@organization])

                elsif @class_name=='' && @organization=='' && @language==''
                    @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.language_code='en' and a.concept_type_ID='0161-1#CT-01#1' and a.term_content!='' ORDER BY `b`.`Class_Name` DESC Limit 100"])          
                end 
            elsif @query=="startwith"
                if @class_name!=''  && @organization!='' && @language!=''
                   @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.language_code= ? and a.concept_type_ID= ? and a.term_content!= ? and a.term_organization_name = ? AND a.term_content like ? ORDER BY `b`.`Class_Name` DESC Limit 100",@language,'0161-1#CT-01#1','',@organization,"%#{@class_name}%"])

                elsif @class_name!='' && @organization=='' && @language==''
                    @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.concept_type_ID=? and a.term_content!=? AND a.term_content like ? ORDER BY `b`.`Class_Name` DESC Limit 100",'0161-1#CT-01#1','',"#{@class_name}%"])

                elsif @organization!='' && @class_name=='' && @language==''
                    @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.concept_type_ID=? and a.term_content!=? AND a.term_organization_name = ? ORDER BY `b`.`Class_Name` DESC Limit 100",'0161-1#CT-01#1','',@organization])

                elsif @language!='' && @organization=='' && @class_name==''
                    @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.concept_type_ID=? and a.term_content!=? AND a.language_code = ? ORDER BY `b`.`Class_Name` DESC Limit 100",'0161-1#CT-01#1','',@language])
                
                elsif @class_name!='' && @organization!='' && @language==''
                    @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.concept_type_ID=? and a.term_content!=? AND a.term_organization_name = ? AND a.term_content like ? ORDER BY `b`.`Class_Name` DESC Limit 100",'0161-1#CT-01#1','',@organization,"#{@class_name}%"])

                elsif @class_name!='' && @organization=='' && @language!=''
                     @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.concept_type_ID = ? and a.term_content!= ? AND a.language_code = ? AND a.term_content like ? ORDER BY `b`.`Class_Name` DESC Limit 100",'0161-1#CT-01#1','',@language,"#{@class_name}%"])

                elsif @class_name=='' && @organization!='' && @language!=''
                    @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.concept_type_ID=? and a.term_content!=? AND a.language_code = ? AND a.term_organization_name = ? ORDER BY `b`.`Class_Name` DESC Limit 100",'0161-1#CT-01#1','',@language,@organization])

                elsif @class_name=='' && @organization=='' && @language==''
                    @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.language_code='en' and a.concept_type_ID='0161-1#CT-01#1' and a.term_content!='' ORDER BY `b`.`Class_Name` DESC Limit 100"])          
                end  
            else
                if @class_name!=''  && @organization!='' && @language!=''
                   @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.language_code= ? and a.concept_type_ID= ? and a.term_content!= ? and a.term_organization_name = ? AND a.term_content = ? ORDER BY `b`.`Class_Name` DESC Limit 100",@language,'0161-1#CT-01#1','',@organization,@class_name])

                elsif @class_name!='' && @organization=='' && @language==''
                    @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.concept_type_ID=? and a.term_content!=? AND a.term_content = ? ORDER BY `b`.`Class_Name` DESC Limit 100",'0161-1#CT-01#1','',@class_name])

                elsif @organization!='' && @class_name=='' && @language==''
                    @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.concept_type_ID=? and a.term_content!=? AND a.term_organization_name = ? ORDER BY `b`.`Class_Name` DESC Limit 100",'0161-1#CT-01#1','',@organization])

                elsif @language!='' && @organization=='' && @class_name==''
                    @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.concept_type_ID=? and a.term_content!=? AND a.language_code = ? ORDER BY `b`.`Class_Name` DESC Limit 100",'0161-1#CT-01#1','',@language])
                
                elsif @class_name!='' && @organization!='' && @language==''
                    @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.concept_type_ID=? and a.term_content!=? AND a.term_organization_name = ? AND a.term_content = ? ORDER BY `b`.`Class_Name` DESC Limit 100",'0161-1#CT-01#1','',@organization,"#{@class_name}%"])

                elsif @class_name!='' && @organization=='' && @language!=''
                     @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.concept_type_ID = ? and a.term_content!= ? AND a.language_code = ? AND a.term_content = ? ORDER BY `b`.`Class_Name` DESC Limit 100",'0161-1#CT-01#1','',@language,@class_name])

                elsif @class_name=='' && @organization!='' && @language!=''
                    @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.concept_type_ID=? and a.term_content!=? AND a.language_code = ? AND a.term_organization_name = ? ORDER BY `b`.`Class_Name` DESC Limit 100",'0161-1#CT-01#1','',@language,@organization])

                elsif @class_name=='' && @organization=='' && @language==''
                    @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.language_code='en' and a.concept_type_ID='0161-1#CT-01#1' and a.term_content!='' ORDER BY `b`.`Class_Name` DESC Limit 100"])          
                end   
            end 
        elsif @listall=='reset' 
            # @modal_class = ConceptDn.where("language_code = ? AND concept_type_ID = ? AND term_content!= ? ", 'en','0161-1#CT-01#1','').select(:term_content,:concept_ID,:term_ID,:definition_ID,:term_organization_name,:definition_content,:language_name).distinct.order(term_content: :asc).limit(100)
            @modal_class = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,a.language_code,b.Class_id FROM `concept_dn` a left join `corp_ignames` b ON a.concept_id=b.Class_id where a.language_code='en' and a.concept_type_ID='0161-1#CT-01#1' and a.term_content!='' ORDER BY `b`.`Class_Name` DESC Limit 100"])
        end

        respond_to do |format|
          format.html {render :layout => false}
        end
    end

    def modalprop
        @listprop = params[:listprop]
        if @listprop == '1'
            # @modal_prop = ConceptDn.where("language_code = ? AND concept_type_ID = ? AND term_content!= ? ", 'en','0161-1#CT-02#1','').select(:term_content,:concept_ID,:term_ID,:definition_ID,:term_organization_name,:definition_content,:language_name).distinct.order(term_content: :asc).limit(1000)        
            @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where a.language_code='en' and a.concept_type_ID='0161-1#CT-02#1' and a.term_content!='' ORDER BY `b`.`Class_Name` DESC Limit 100"])   

        elsif @listprop == '0'
            @property_name = params[:property_name]
            @organization_prop = params[:organization_prop]
            @language_prop = params[:language_prop]
            @query = params[:query]

            if params[:reject]
                @reject = params[:reject].reject(&:blank?)
                @reject = @reject.map(&:inspect).join(', ')
                # @reject = @reject.to_s.gsub('"', '')
                if @reject ==""
                   @reject = "('"+@reject+"')" 
                else
                    @reject = "("+@reject+")"  
                end  
            else 
                @reject="('')"  
            end          
            
            if @query=="like"
                if @property_name!=''  && @organization_prop!='' && @language_prop!=''
                    @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where term_content like ? AND term_organization_name = ? AND language_code = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100","%#{@property_name}%",@organization_prop,@language_prop,'0161-1#CT-02#1',''])

                elsif @property_name!='' && @organization_prop=='' && @language_prop==''
                    @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where term_content like ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100","%#{@property_name}%",'0161-1#CT-02#1',''])       

                elsif @organization_prop!='' && @property_name=='' && @language_prop==''
                   @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where term_organization_name = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100", @organization_prop,'0161-1#CT-02#1',''])       

                elsif @language_prop!='' && @organization_prop=='' && @property_name==''
                    @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where language_code = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100",@language_prop,'0161-1#CT-02#1',''])       
                elsif @property_name!='' && @organization_prop!='' && @language_prop==''
                    @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where term_content like ? AND term_organization_name = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100","%#{@property_name}%",@organization_prop,'0161-1#CT-02#1',''])       

                elsif @property_name!='' && @organization_prop=='' && @language_prop!=''
                    @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where term_content like ? AND language_code = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100","%#{@property_name}%",@language_prop,'0161-1#CT-02#1','']) 

                elsif @property_name=='' && @organization_prop!='' && @language_prop!=''
                    @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where term_content like ? AND language_code = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100","%#{@property_name}%",@language_prop,'0161-1#CT-02#1',''])  

                elsif @property_name=='' && @organization_prop=='' && @language_prop==''
                   @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where language_code = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100",'en','0161-1#CT-02#1',''])

                end    
            elsif @query=="startwith"
               if @property_name!=''  && @organization_prop!='' && @language_prop!=''
                    @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where term_content like ? AND term_organization_name = ? AND language_code = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100","#{@property_name}%",@organization_prop,@language_prop,'0161-1#CT-02#1',''])

                elsif @property_name!='' && @organization_prop=='' && @language_prop==''
                    @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where term_content like ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100","#{@property_name}%",'0161-1#CT-02#1',''])       

                elsif @organization_prop!='' && @property_name=='' && @language_prop==''
                   @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where term_organization_name = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100", @organization_prop,'0161-1#CT-02#1',''])       

                elsif @language_prop!='' && @organization_prop=='' && @property_name==''
                    @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where language_code = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100",@language_prop,'0161-1#CT-02#1',''])       
                elsif @property_name!='' && @organization_prop!='' && @language_prop==''
                    @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where term_content like ? AND term_organization_name = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100","#{@property_name}%",@organization_prop,'0161-1#CT-02#1',''])       

                elsif @property_name!='' && @organization_prop=='' && @language_prop!=''
                    @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where term_content like ? AND language_code = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100","#{@property_name}%",@language_prop,'0161-1#CT-02#1','']) 

                elsif @property_name=='' && @organization_prop!='' && @language_prop!=''
                    @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where term_content like ? AND language_code = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100","#{@property_name}%",@language_prop,'0161-1#CT-02#1',''])  

                elsif @property_name=='' && @organization_prop=='' && @language_prop==''
                   @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where language_code = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100",'en','0161-1#CT-02#1',''])

                end   
            else
                if @property_name!=''  && @organization_prop!='' && @language_prop!=''
                    @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where term_content = ? AND term_organization_name = ? AND language_code = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100",@property_name,@organization_prop,@language_prop,'0161-1#CT-02#1',''])

                elsif @property_name!='' && @organization_prop=='' && @language_prop==''
                    @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where term_content = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100",@property_name,'0161-1#CT-02#1',''])       

                elsif @organization_prop!='' && @property_name=='' && @language_prop==''
                   @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where term_organization_name = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100", @organization_prop,'0161-1#CT-02#1',''])       

                elsif @language_prop!='' && @organization_prop=='' && @property_name==''
                    @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where language_code = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100",@language_prop,'0161-1#CT-02#1',''])       
                elsif @property_name!='' && @organization_prop!='' && @language_prop==''
                    @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where term_content = ? AND term_organization_name = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100",@property_name,@organization_prop,'0161-1#CT-02#1',''])       

                elsif @property_name!='' && @organization_prop=='' && @language_prop!=''
                    @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where term_content = ? AND language_code = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100",@property_name,@language_prop,'0161-1#CT-02#1','']) 

                elsif @property_name=='' && @organization_prop!='' && @language_prop!=''
                    @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where term_content = ? AND language_code = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100",@property_name,@language_prop,'0161-1#CT-02#1',''])  

                elsif @property_name=='' && @organization_prop=='' && @language_prop==''
                   @modal_prop = ConceptDn.find_by_sql(["SELECT distinct a.term_content,a.concept_ID,a.term_ID,a.definition_ID,a.term_organization_name,a.definition_content,a.language_name,b.propertyRef FROM `concept_dn` a left join `xml_rg` b ON a.concept_id=b.propertyRef where language_code = ? AND concept_type_ID = ? AND term_content!= ? ORDER BY `b`.`Class_Name` DESC Limit 100",'en','0161-1#CT-02#1',''])

                end            
            end           
        elsif @listprop == 'reset'
            if params[:reject]
                @reject = params[:reject].reject(&:blank?)
                @reject = @reject.map(&:inspect).join(', ')
                # @reject = @reject.to_s.gsub('"', '')
                if @reject ==""
                   @reject = "('"+@reject+"')" 
                else
                    @reject = "("+@reject+")"  
                end
                @modal_prop = ConceptDn.where("language_code = ? AND concept_type_ID = ? AND term_content!= ? AND concept_ID not in #{@reject}", 'en','0161-1#CT-02#1','').select(:term_content,:concept_ID,:term_ID,:definition_ID,:term_organization_name,:definition_content,:language_name).distinct.order(term_content: :asc).limit(1000)
            else
                @modal_prop = ConceptDn.where("language_code = ? AND concept_type_ID = ? AND term_content!= ? ", 'en','0161-1#CT-02#1','').select(:term_content,:concept_ID,:term_ID,:definition_ID,:term_organization_name,:definition_content,:language_name).distinct.order(term_content: :asc).limit(1000)            
            end
                

            
            # @modal_prop = ConceptDn.where("language_code = ? AND concept_type_ID = ? AND term_content!= ? ", 'en','0161-1#CT-02#1','').select(:term_content,:concept_ID,:term_ID,:definition_ID,:term_organization_name,:definition_content,:language_name).distinct.order(term_content: :asc).limit(100)
        end
        respond_to do |format|
          format.html {render :layout => false}
          # format.json {render :layout => false, :text => @modal_prop.to_json }
        end   
    end

    def addnew
        @lang = ConceptDn.group(:language_code).select('language_code,language_name')
        @lang1 = ConceptDn.group(:language_code).select('language_code,language_name').to_sql

        @org=ConceptDn.select(:term_organization_name).distinct
        @max_no=(MaterialMaster.maximum("cmm_material_no"))
        @igid=(CorpIgname.maximum("igid"))    

        if(@max_no=='' || @max_no==nil )
          @max_no='2000001'
        else    
          @max_no = @max_no.to_i + 1
        end

        if(@igid=='' || @igid==nil )
          @igid='100001' 
        else
          @igid = @igid.to_i + 1
        end 

        @class_prop = params[:term_content]
        @template = params[:template]
        if @class_prop
            @igid = params[:igid].squish!
            @cmm = params[:cmm].squish!
            @material_id = params[:material_id]
            @term_content = params[:term_content]
            @concept_ID = params[:concept_ID]
            @term_ID = params[:term_ID]
            @definition_ID = params[:definition_ID]
            @term_organization_name = params[:term_organization_name]
            @definition_content = params[:definition_content]
            @language_name = params[:language_name]
            @legacy = params[:legacy]

            @prop_name = params[:prop_name]
            @prop_concept_ID = params[:prop_concept_ID]
            @prop_term_ID = params[:prop_term_ID]
            @prop_definition_ID = params[:prop_definition_ID]
            @prop_term_organization_name = params[:prop_term_organization_name]
            @prop_definition_content = params[:prop_definition_content]
            @prop_language_name = params[:prop_language_name]
            @prop_value = params[:prop_value]
            @prop_source = params[:prop_source]
            # @prop_seq = params[:prop_seq]
            @prop_mandatory = params[:prop_mandatory]    
            @prop_seq=params[:prop_name].length
            @prop_seq=1..@prop_seq
            @originInput=params[:originInput]
            @country_orgin=params[:country_orgin]

            @cmm=(MaterialMaster.maximum("cmm_material_no"))              
            if(@cmm=='' || @cmm==nil )
              @cmm='2000001'
            else    
              @cmm = @cmm.to_i + 1
            end
            @temp_decide = CorpIgname.where("igid = ? ",@igid).count
            
            if @temp_decide=="" || @temp_decide==nil || @temp_decide=='0'
                @igid=(CorpIgname.maximum("igid"))
                if(@igid=='' || @igid==nil )
                  @igid='100001' 
                else
                  @igid = @igid.to_i + 1
                end
            end
                @igid = @igid.to_s
                @cmm = @cmm.to_s

            # if @template == "newtemplate"
               @id1=params[:pictureInput]
                if @id1 
                  @name=@id1.original_filename.gsub("-","_")
                  n1=@cmm+"_"+@name
                  n2=@cmm+"_"+params[:pictureInput].original_filename.gsub("-","_").to_s
                  @sql=Image.create(image_name: n1,image_id: @cmm)
                  tmp=params[:pictureInput].tempfile
                  destiny_file = File.join('app','assets','ests_image',n2)
                  FileUtils.move tmp.path, destiny_file

                    if params[:upload_etsr]
                        # @pictureInput=params[:pictureInput].read
                        # if @pictureInput.size
                            url1="/assets/"
                            @etsr_cmm="ECCMA.eTSR:"+@cmm
                            @url = request.protocol + request.host+ url1 + n1
                            @sql=EtsrImage.create(image_name: @url,image: "",image_id: @etsr_cmm)
                        # end
                    end
                end
                
            # end
                
            results=ActiveRecord::Base.connection.execute("select * from `ests_db`.settings")
            results.each(:as => :hash) do |res|
                @z=res["class_prop_sep_SD"]
                @y=res["prop_value_sep_LD"]
                @x=res["class_prop_sep_LD"]
                @sh_case=res["short_desc_case"]
                @lg_case=res["long_desc_case"]
                @val_case=res["value_case"]
                @len_ld=res["length_LD"]
                @len_sd=res["length_SD"]


                @b = @prop_name.zip(@prop_value).delete_if{ |x| x[1]==""}.collect{|y| y[0]+@y+y[1]}
                @v=params[:prop_value].reject(&:blank?)
                @bs= @term_content 
                @class_1= @term_content 

                
                @v.each do |a|
                    @bs1= @bs+@z+a
                    if @bs1.length <= @len_sd.to_i
                        @bs=@bs+@z+a
                    end       
                end
                @b.each do |s|
                  @lg=@class_1+@x+s
                  if @lg.length>=@len_ld.to_i && @len_ld=='0'
                      @class_1=@class_1+@x+s

                  elsif @lg.length<=@len_ld.to_i && @len_ld!='0'
                      @class_1=@class_1+@x+s
                  end
                end   

                if @sh_case=='Lower Case'
                    @bs=@bs.downcase
                elsif @sh_case=='Sentence Case'|| @lg_case=='Not Set'
                    @bs=@bs.capitalize
                else 
                    @bs=@bs.upcase
                end

                if @lg_case=='Lower Case'
                    @class_1=@class_1.downcase
                  elsif @lg_case=='Sentence Case'|| @lg_case=='Not Set'
                    @class_1=@class_1.capitalize
                  else
                    @class_1=@class_1.upcase
                end
            end
            # a = @prop_name
            # if a.find_all { |e| a.count(e) > 1 }
            #     flash.now[:success] = 'Message sent!'
            # else 

            if @originInput!="" && @country_orgin==""
                  @nameorigin=params[:originInput].original_filename.gsub("-","_")
                  n1=@cmm+"_"+@nameorigin
                  n2=@cmm+"_"+params[:originInput].original_filename.gsub("-","_").to_s
                  # @sql=Countryorigin.create(image_name: n1,image_id: @cmm)

                   @material_master=MaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class_name: @term_content,class_id: @concept_ID,cmm_material_no: @cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,source_image: n1)

                  tmp=params[:originInput].tempfile
                  destiny_file = File.join('app','assets','ests_orgin',n2)
                  FileUtils.move tmp.path, destiny_file   
                
                    if params[:upload_etsr]
                        url1="/assets/"
                        @etsr_cmm="ECCMA.eTSR:"+@cmm
                        @url = request.protocol + request.host+ url1 + n1
                        # @sql=EtsrCountryorigin.create(,image: "",image_id: @etsr_cmm)
                        
                        @etsr_material_master=EtsrMaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @etsr_cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class: @term_content,class_id: @concept_ID,cmm_material_no: @cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,FACTORY_ID: current_user.Organization_ID,FACTORY_NAME_ECCMA: current_user.name,FACTORY_NAME_TESS: '',source_image: @url)

                        # @originInput=params[:originInput].read
                        # if @originInput.size
                        #     @etsr_cmm="ECCMA.eTSR:"+@cmm
                        #     @sql=EtsrCountryorigin.create(image: @originInput,image_id: @etsr_cmm)
                        # end
                    end
                elsif @country_orgin!="" && @originInput==""
                    # @sql=Countryorigin.create(image_name: @country_orgin,image_id: @cmm,image: "N")   
                    @material_master=MaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class_name: @term_content,class_id: @concept_ID,cmm_material_no: @cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,source_name: @country_orgin,sts: "N")

                    if params[:upload_etsr]
                        if params[:pictureInput]
                            @etsr_cmm="ECCMA.eTSR:"+@cmm
                            # @sql=EtsrCountryorigin.create(image_name: @country_orgin,image_id: @etsr_cmm,image: "N")
                             @etsr_material_master=EtsrMaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @etsr_cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class: @term_content,class_id: @concept_ID,cmm_material_no: @cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,FACTORY_ID: current_user.Organization_ID,FACTORY_NAME_ECCMA: current_user.name,FACTORY_NAME_TESS: '',source_name: @country_orgin,sts: "N")
                        end
                    end
                elsif @country_orgin!="" && @originInput!=""
                     @material_master=MaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class_name: @term_content,class_id: @concept_ID,cmm_material_no: @cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,source_name: @country_orgin,sts: "N")
                    if params[:upload_etsr]
                        if params[:pictureInput]
                            @etsr_cmm="ECCMA.eTSR:"+@cmm
                            @etsr_material_master=EtsrMaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @etsr_cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class: @term_content,class_id: @concept_ID,cmm_material_no: @cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,FACTORY_ID: current_user.Organization_ID,FACTORY_NAME_ECCMA: current_user.name,FACTORY_NAME_TESS: '',source_name: @country_orgin,sts: "N")
                        end
                    end                 
                end


            # @material_master=MaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class_name: @term_content,class_id: @concept_ID,cmm_material_no: @cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now)

            # if params[:upload_etsr]
            #     @etsr_cmm="ECCMA.eTSR:"+@cmm
            #     @etsr_material_master=EtsrMaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @etsr_cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class: @term_content,class_id: @concept_ID,cmm_material_no: @cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,FACTORY_ID: current_user.Organization_ID,FACTORY_NAME_ECCMA: current_user.name,FACTORY_NAME_TESS: '')
            # end
            if @template == "existtemplate"
                @igid = params[:igid].squish!
                @delete_xmlrg = XmlRgDelete.where("igid = ?",@igid).delete_all
                @xmlrg = XmlRg.where("igid = ?",@igid)

                @xmlrg.each do |xmlrg|
                @temp_xmlrg = XmlRgDelete.create(row: xmlrg.row,igid: xmlrg.igid,RGref: xmlrg.RGref,class_name: xmlrg.class_name,propertyRef: xmlrg.propertyRef,termID: xmlrg.termID,property: xmlrg.property,Property_Definition: xmlrg.Property_Definition,igid_ref: xmlrg.igid_ref,definitionID: xmlrg.definitionID,datecreated: xmlrg.datecreated, datedeleted: Time.now)
                end    

                @delete_xmlrg = XmlRg.where("igid = ?",@igid).delete_all

                @id1=params[:pictureInput]
                if @id1 
                  @name=@id1.original_filename.gsub("-","_")
                  n1=@cmm+"_"+@name
                  n2=@cmm+"_"+params[:pictureInput].original_filename.gsub("-","_").to_s
                  @sql=Image.create(image_name: n1,image_id: @cmm)
                  tmp=params[:pictureInput].tempfile
                  destiny_file = File.join('app','assets','ests_image',n2)
                  FileUtils.move tmp.path, destiny_file
                    if params[:upload_etsr]
                        @pictureInput=params[:pictureInput].read
                        if @pictureInput.size
                            @etsr_cmm="ECCMA.eTSR:"+@cmm
                            @sql=EtsrImage.create(image: @pictureInput,image_id: @etsr_cmm)
                        end
                    end
                end
                # @originInput=params[:originInput]
                # @country_orgin=params[:country_orgin]
                
                # if @originInput!="" && @country_orgin==""
                #   @nameorigin=params[:originInput].original_filename.gsub("-","_")
                #   n1=@cmm+"_"+@nameorigin
                #   n2=@cmm+"_"+params[:originInput].original_filename.gsub("-","_").to_s
                #   @sql=Countryorigin.where("cat_id = ?",@cmm).update_all(image_name: n1,image_id: @cmm)
                #   tmp=params[:originInput].tempfile
                #   destiny_file = File.join('app','assets','ests_orgin',n2)
                #   FileUtils.move tmp.path, destiny_file   
                #     if params[:upload_etsr]
                #         @originInput=params[:originInput].read
                #         if @originInput.size
                #             @etsr_cmm="ECCMA.eTSR:"+@cmm
                #             @sql=EtsrCountryorigin.where("cat_id = ?",@etsr_cmm).update_all(image: @originInput,image_id: @etsr_cmm)
                #         end
                #     end
                # elsif @country_orgin!="" && @originInput==""
                #     @sql=Countryorigin.where("cat_id = ?",@cmm).update_all(image_name: @country_orgin,image_id: @cmm,image: "N")   
                #     if params[:upload_etsr]
                #         if params[:pictureInput]
                #             @etsr_cmm="ECCMA.eTSR:"+@cmm
                #             @sql=EtsrCountryorigin.where("cat_id = ?",@etsr_cmm).update_all(image_name: @country_orgin,image_id: @etsr_cmm,image: "N")
                #         end
                #     end
                # elsif @country_orgin!="" && @originInput!=""
                #     @sql=Countryorigin.create(image_name: @country_orgin,image_id: @cmm,sts: "N")    
                #     if params[:upload_etsr]
                #         if params[:pictureInput]
                #             @etsr_cmm="ECCMA.eTSR:"+@cmm
                #             @sql=EtsrCountryorigin.where("cat_id = ?",@etsr_cmm).update_all(image_name: @country_orgin,image_id: @etsr_cmm,image: "N")
                #         end
                #     end                 
                # end
            end 
            @val=@prop_name.zip(@prop_value,@prop_concept_ID,@prop_seq,@prop_source,@prop_term_ID,@prop_definition_ID,@prop_definition_content).each do |a,b,c,d,e,f,g,h|
            @prop_name=a
            @prop_value=b
            @prop_concept_ID=c
            @prop_seq=d
            @prop_source=e
            @prop_term_ID=f
            @prop_definition_ID=g
            @prop_definition_content=h

            if @val_case=='Lower Case'
                @prop_value=@prop_value.downcase
            elsif @val_case=='Sentence Case'
                @prop_value=@prop_value.capitalize
            else
                @prop_value=@prop_value.upcase
            end
               
               @rxml_value = RxmlValue.create(row: @prop_seq,Seq: @prop_seq,igid: @igid,cat_id: @cmm,Class: @term_content,classref: @concept_ID,propertyRef: @prop_concept_ID,property: @prop_name,value: @prop_value,source: @prop_source,datecreated: Time.now,lastmodified: Time.now,language: @language_name)
               
               if params[:upload_etsr]
                    @etsr_cmm="ECCMA.eTSR:"+@cmm
                    @etsr_rxml_value = EtsrRxmlValue.create(row: @prop_seq,Seq: @prop_seq,igid: @igid,cat_id: @etsr_cmm,Class: @term_content,classref: @concept_ID,propertyRef: @prop_concept_ID,property: @prop_name,value: @prop_value,source: @prop_source,datecreated: Time.now,lastmodified: Time.now,language: @language_name)
               end
                
                

                if @temp_decide=="" || @temp_decide==nil || @temp_decide=='0'
                    @corp_ignames=CorpIgname.create(username: current_user.name,realname: current_user.name,igid: @igid,igversion: '',igversion: '',igref: @igid,Class_id: @concept_ID,Class_Name: @term_content,Class_Definition: @definition_content,Source: '',Source_registry: '',Source_builder: '',Uploaded_Filename: '',Private: '',igid_ref: '0',Done: '',Files_generated: '',ixml_file: '',organization_ID: current_user.Organization_ID,Copy_From: '',datecreated: Time.now)
                    @rxml_value = XmlRg.create(row: @prop_seq,igid: @igid,RGref: '',class_name: @term_content,propertyRef: @prop_concept_ID,termID: @prop_term_ID,definitionID: @prop_definition_ID,Property_Definition: @prop_definition_content,property: @prop_name,Required: 'Y',datecreated: Time.now)
                end
             
            end
            flash[:success] = "Succesfully Saved"
            redirect_to controller: 'home',action: 'view', cat_id: @cmm
        end 
        
    end

    def view
        @cat_id=params[:cat_id]        
        @len=Setting.where("organization_ID=123")
        @data=MaterialMaster.where("cat_id = ?",@cat_id)
        @data1=RxmlValue.where("cat_id = ? and datedeleted = ?",@cat_id,'0000-00-00 00:00:00').order(row: :asc)
        
        @data_count=RxmlValue.where("cat_id = ? and datedeleted = ?",@cat_id,'0000-00-00 00:00:00').select(:row,:igid).limit(1).order(row: :desc)

        # @data2=MaterialMaster.where("cat_id = ?",@cat_id).select(:igid).limit(1)
        @image=Image.where("image_id = ?",@cat_id)
        @imagecount=Image.where("image_id = ?",@cat_id).count
        @cmm="ECCMA.eTSR:"+@cat_id
        @etsr_mm=EtsrMaterialMaster.where("cat_id = ? and datedeleted = ?",@cmm,'0000-00-00 00:00:00').count

        # @imageorigin=Countryorigin.where("image_id = ?",@cat_id)
        # @imagecount=Image.where("image_id = ?",@cat_id).count

        @lang = ConceptDn.group(:language_code).select('language_code,language_name')
        @org=ConceptDn.select(:term_organization_name).distinct

    end

    def dictionary_detail
        # if session[:user_id]
        vars = request.query_parameters
        @esci = vars['esci']
        @esci = Base64.decode64(@esci)
        #@mm = User.where("id = ?", 4).select( "user_fname, user_lname")
        @mm =ConceptDn.where("concept_ID = ? ", @esci )
        #@con_dn =Concept_dn.where("concept_ID = ? AND  ", @esci)
        #@con_dn =Term_dn.where("concept_ID = ? AND term_ID = ? AND definition_ID = ? ", @esci, @term ,@definition)
        #   else
        #   render 'sessions/login'
        # end
    end

    def destroy
        @destroy = params[:id]
        @update = MaterialMaster.where('cat_id =?',@destroy).update_all(datedeleted: Time.now)
        redirect_to :back
        flash[:success] = "Deleted Successfully!"
    end

    def etsr
        @destroy = params[:id]
        @destroy= "ECCMA.eTSR:"+@destroy
        @mm = EtsrMaterialMaster.where('cat_id =?',@destroy).delete_all
        @rv = EtsrRxmlValue.where('cat_id =?',@destroy).delete_all
        # @co = EtsrCountryorigin.where('image_id =?',@destroy).delete_all
        @im = EtsrImage.where('image_id =?',@destroy).delete_all
        redirect_to :back
        flash[:success] = "Deleted Successfully!"
    end

    def update    
        if params[:delete]=='delete'  
          @seq = params[:seq]
          @cat_id = params[:cat_id]     
          check =  RxmlValue.where('cat_id=? and datedeleted=?',@cat_id,'0000-00-00 00:00:00').count 
          if check.to_i == 1
            flash[:alert] = "Sorry you can't to delete the last property"
            redirect_to controller: 'home',action: 'view',cat_id: @cat_id
          else
            @update = RxmlValue.where('cat_id =? AND Seq =?',@cat_id,@seq).update_all(datedeleted: Time.now)
            flash[:success] = "Deleted Successfully!"
            redirect_to controller: 'home',action: 'view',cat_id: @cat_id  
          end 
        end    

        if params[:update]=="UPDATE"
            @class=params[:class_name]
            @v1=params[:prop_value]
            @prop=params[:prop_name]
            @bs=@class 
            length_sd=params[:len_sd].to_i
            length_ld=params[:len_ld].to_i
            @id=params[:cmm]
            @cmm=params[:cmm]
            @source=params[:prop_source]
            @originInput=params[:originInput]
            @country_orgin=params[:country_orgin]


            results=ActiveRecord::Base.connection.execute("select * from `ests_db`.settings")
            results.each(:as => :hash) do |res|
            @z=res["class_prop_sep_SD"]
            @y=res["prop_value_sep_LD"]
            @x=res["class_prop_sep_LD"]
            @sh_case=res["short_desc_case"]
            @lg_case=res["long_desc_case"]
            @val_case=res["value_case"]
            @len_ld=res["length_LD"]
            @len_sd=res["length_SD"]

            @imagecount=Image.where("image_id = ?",@id).count
            if @imagecount==1
                @id1=params[:pictureInput]
                if @id1 
                  @im= Image.where("image_id = ?",@cmm).delete_all
                  @name=@id1.original_filename.gsub("-","_")
                  n1=@cmm+"_"+@name
                  n2=@cmm+"_"+params[:pictureInput].original_filename.gsub("-","_").to_s
                  @sql=Image.update_all(image_name: n1).where('image_id=?', @cmm)
                  tmp=params[:pictureInput].tempfile
                  destiny_file = File.join('app','assets','ests_image',n2)
                  FileUtils.move tmp.path, destiny_file

                    if params[:upload_etsr]
                        # url1="/assets/"
                        # @etsr_cmm="ECCMA.eTSR:"+@cmm
                        # @url = request.protocol + request.host+ url1 + n1
                        # @sql=EtsrImage.update_all(image_name: @url).where('image_id=?', @etsr_cmm)

                        url1="/assets/"
                        @etsr_cmm="ECCMA.eTSR:"+@cmm
                        @url = request.protocol + request.host+ url1 + n1
                        @sql=EtsrImage.create(image_name: @url,image: "",image_id: @etsr_cmm)
                    end
                end
            else
                @id1=params[:pictureInput]
                if @id1 
                  @im= Image.where("image_id = ?",@cmm).delete_all
                  @name=@id1.original_filename.gsub("-","_")
                  n1=@cmm+"_"+@name
                  n2=@cmm+"_"+params[:pictureInput].original_filename.gsub("-","_").to_s
                  @sql=Image.create(image_name: n1,image_id: @cmm)
                  tmp=params[:pictureInput].tempfile
                  destiny_file = File.join('app','assets','ests_image',n2)
                  FileUtils.move tmp.path, destiny_file

                    if params[:upload_etsr]
                        # @pictureInput=params[:pictureInput].read
                        # if @pictureInput.size
                        #     @etsr_cmm="ECCMA.eTSR:"+@cmm
                        #     @im= EtsrImage.where("image_id = ?",@etsr_cmm).delete_all
                        #     @sql=EtsrImage.create(image: @pictureInput,image_id: @etsr_cmm)
                        # end
                        url1="/assets/"
                        @etsr_cmm="ECCMA.eTSR:"+@cmm
                        @url = request.protocol + request.host+ url1 + n1
                        @sql=EtsrImage.create(image_name: @url,image: "",image_id: @etsr_cmm)
                    end
                end   
            end
                

                @v=params[:prop_value].reject(&:blank?)

                @b=@prop.zip(@v1).delete_if{ |x| x[1]==""}.collect{|y| y[0]+@y+y[1]}
                @b.each do |s|
                    @v.each do |a|
                        @bs1=@bs+@z+a
                        if @bs1.length<=@len_sd.to_i
                            @bs=@bs+@z+a
                        end       
                    end

                    @lg=@class+@x+s
                    
                    if @lg.length>=@len_ld.to_i && @len_ld=='0'
                        @class=@class+@x+s
                    elsif @lg.length<=@len_ld.to_i && @len_ld!='0'
                        @class=@class+@x+s
                    end
                end

                if @sh_case=='Lower Case'
                    @bs=@bs.downcase
                elsif @sh_case=='Sentence Case'|| @lg_case=='Not Set'
                    @bs=@bs.capitalize
                else 
                    @bs=@bs.upcase
                end

                if @lg_case=='Lower Case'
                    @class=@class.downcase
                elsif @lg_case=='Sentence Case'|| @lg_case=='Not Set'
                    @class=@class.capitalize
                else
                    @class=@class.upcase
                end
            end
            if @originInput
                  @nameorigin=params[:originInput].original_filename.gsub("-","_")
                  n1=@cmm+"_"+@nameorigin
                  n2=@cmm+"_"+params[:originInput].original_filename.gsub("-","_").to_s
                  # @sql=Countryorigin.where("image_id = ?",@cmm).update_all(image_name: n1)
                  @update1=MaterialMaster.where('cat_id = ?',@id).update_all({short_description: @bs,long_description: @class,lastmodified: Time.now,source_image: n1})
                  tmp=params[:originInput].tempfile
                  destiny_file = File.join('app','assets','ests_orgin',n2)
                  FileUtils.move tmp.path, destiny_file   
                
                    # if params[:upload_etsr]                        
                    #     url1="/assets/"
                    #     @etsr_cmm="ECCMA.eTSR:"+@cmm
                    #     @url = request.protocol + request.host+ url1 + n1
                    #     @sql=EtsrCountryorigin.create(image_name: @url,image: "",image_id: @etsr_cmm)
                    # end
                elsif @country_orgin
                    # @sql=Countryorigin.where("image_id = ?",@cmm).update_all(image_name: @country_orgin,image: "N")   
                    @update1=MaterialMaster.where('cat_id = ?',@id).update_all({short_description: @bs,long_description: @class,lastmodified: Time.now,source_name: @country_orgin,sts: "N"})
                    # if params[:upload_etsr]
                    #     # if params[:pictureInput]
                    #     #     @etsr_cmm="ECCMA.eTSR:"+@cmm
                    #     #     # @co= Countryorigin.where("image_id = ?",@etsr_cmm).delete_all
                    #     #     @sql=EtsrCountryorigin.where("image_id = ?",@etsr_cmm).update_all(image_name: @country_orgin,image: "N")
                    #     # end
                    # end        
                end            

            @id=params[:cmm]

            @a=params[:prop_seq]
            @b=params[:prop_value]
            @c=params[:prop_name]
            @d=params[:prop_source]

            for a,b,c,d in @b.zip(@c,@a,@d)
                @cs=a
                @ds=b
                @es=c
                @source=d
                if @val_case=='Lower Case'
                    @cs=@cs.downcase
                    @dc=@ds.downcase
                    @es=@es.downcase
                    # @source=@source.downcase
                elsif @val_case=='Sentence Case'
                    @cs=@cs.capitalize
                    @dc=@ds.capitalize
                    @es=@es.capitalize
                    # @source=@source.capitalize
                else
                    @cs=@cs.upcase
                    @dc=@ds.upcase
                    @es=@es.upcase
                    # @source=@source.upcase
                end
                @update=RxmlValue.where('Seq = ? AND property = ? AND cat_id = ? ',@es,@ds,@id).update_all(value: @cs,source: @source,lastmodified: Time.now)                    
            end

            if params[:upload_etsr] 
               @etsr_cmm="ECCMA.eTSR:"+@cmm               
               @check_up = EtsrMaterialMaster.where("cat_id = ? and datedeleted = ?",@etsr_cmm,'0000-00-00 00:00:00').count               
                
                if @check_up==1

                    if @originInput
                      @nameorigin=params[:originInput].original_filename.gsub("-","_")
                      n1=@cmm+"_"+@nameorigin
                      n2=@cmm+"_"+params[:originInput].original_filename.gsub("-","_").to_s
                      # @sql=Countryorigin.where("image_id = ?",@cmm).update_all(image_name: n1)
                        url1="/assets/"
                        @etsr_cmm="ECCMA.eTSR:"+@cmm
                        @url = request.protocol + request.host+ url1 + n1
                      @update1=EtsrMaterialMaster.where('cat_id = ?',@etsr_cmm).update_all({short_description: @bs,long_description: @class,lastmodified: Time.now,source_image: @url})  
                      tmp=params[:originInput].tempfile
                      destiny_file = File.join('app','assets','ests_orgin',n2)
                      FileUtils.move tmp.path, destiny_file 
                    elsif @country_orgin
                        # @sql=Countryorigin.where("image_id = ?",@cmm).update_all(image_name: @country_orgin,image: "N")   
                        @update1=EtsrMaterialMaster.where('cat_id = ?',@etsr_cmm).update_all({short_description: @bs,long_description: @class,lastmodified: Time.now,source_name: @country_orgin,sts: "N"})
                    end 
                    @update=EtsrRxmlValue.where('Seq = ? AND property = ? AND cat_id = ? ',@es,@ds,@etsr_cmm).update_all(value: @cs,source: @source,lastmodified: Time.now)

                elsif @check_up==0
                    @mm_value_up = MaterialMaster.where("cat_id = ?", @id)
                    @mm_value_up.each do |mm_value_up|                        
                        @up_mm_value_up=EtsrMaterialMaster.create(username: current_user.name,realname: current_user.name,igid: mm_value_up.igid,cat_id:@etsr_cmm,catalog_name: mm_value_up.catalog_name,material_id: mm_value_up.material_id,datecreated: Time.now,legacy_description: mm_value_up.legacy_description,short_description: mm_value_up.short_description,long_description: mm_value_up.long_description,class: mm_value_up.class,class_id: mm_value_up.class_id,cmm_material_no: mm_value_up.cmm_material_no,organization_ID: current_user.Organization_ID,approved_by: '',language: mm_value_up.language,lastmodified: Time.now,FACTORY_ID: current_user.Organization_ID,FACTORY_NAME_ECCMA: current_user.name,FACTORY_NAME_TESS: '',source_image: mm_value_up.source_image,source_name: mm_value_up.source_name,sts: mm_value_up.sts)
                    end

                    @rxml_value_up = RxmlValue.where("cat_id = ?", @id)
                    @rxml_value_up.each do |rxml_value_beta|
                        @up_rxml_value_beta = EtsrRxmlValue.create(row: rxml_value_beta.row,Seq: rxml_value_beta.Seq,igid: rxml_value_beta.igid,cat_id: @etsr_cmm,Class: rxml_value_beta.Class,classref: rxml_value_beta.classref,propertyRef: rxml_value_beta.propertyRef,property: rxml_value_beta.property,value: rxml_value_beta.value,datecreated: rxml_value_beta.datecreated,datecreated: Time.now,source: rxml_value_beta.source,language: rxml_value_beta.language)
                    end      
                end 

            end
            flash[:success] = "Succesfully Saved"
            redirect_to controller: 'home',action: 'view',cat_id: @cmm
        end

        if params[:update_prop]=="Submit"
            @template = params[:template]    
            if @template == "newtemplate"
                @igid = params[:igid].squish!
                @cmm = params[:cmm].squish!
                @material_id = params[:material_id]
                @term_content = params[:class_name]
                @concept_ID = params[:concept_ID]
                # @term_ID = params[:term_ID]
                # @definition_ID = params[:definition_ID]
                # @term_organization_name = params[:term_organization_name]
                @definition_content = params[:definition_content]
                @language_name = params[:language_name]
                @legacy = params[:legacy]

                @prop_name = params[:prop_name]
                @prop_concept_ID = params[:prop_concept_ID]
                @prop_term_ID = params[:prop_term_ID]
                @prop_definition_ID = params[:prop_definition_ID]
                # @prop_term_organization_name = params[:prop_term_organization_name]
                @prop_definition_content = params[:prop_definition_content]
                # @prop_language_name = params[:prop_language_name]
                @prop_value = params[:prop_value]
                @prop_source = params[:prop_source]
                # @prop_seq = params[:prop_seq]
                @prop_mandatory = params[:prop_mandatory]    
                @prop_seq=params[:prop_name].length
                @prop_seq=1..@prop_seq
                @originInput=params[:originInput]
                @country_orgin=params[:country_orgin]

                @cmm=(MaterialMaster.maximum("cmm_material_no"))
                @igid=(CorpIgname.maximum("igid"))    

                if(@cmm=='' || @cmm==nil )
                  @cmm='2000001'
                else    
                  @cmm = @cmm.to_i + 1
                end

                if(@igid=='' || @igid==nil )
                  @igid='100001' 
                else
                  @igid = @igid.to_i + 1
                end
                @igid = @igid
                @cmm = @cmm

                results=ActiveRecord::Base.connection.execute("select * from `ests_db`.settings")
                results.each(:as => :hash) do |res|
                    @z=res["class_prop_sep_SD"]
                    @y=res["prop_value_sep_LD"]
                    @x=res["class_prop_sep_LD"]
                    @sh_case=res["short_desc_case"]
                    @lg_case=res["long_desc_case"]
                    @val_case=res["value_case"]
                    @len_ld=res["length_LD"]
                    @len_sd=res["length_SD"]

                    @imagecount=Image.where("image_id = ?",@cmm).count

                    @id1=params[:pictureInput]
                    if @id1 
                      @name=@id1.original_filename.gsub("-","_")
                      n1=@cmm+"_"+@name
                      n2=@cmm+"_"+params[:pictureInput].original_filename.gsub("-","_").to_s
                      @sql=Image.create(image_name: n1,image_id: @cmm)
                      tmp=params[:pictureInput].tempfile
                      destiny_file = File.join('app','assets','ests_image',n2)
                      FileUtils.move tmp.path, destiny_file

                        if params[:upload_etsr]
                            url1="/assets/"
                            @etsr_cmm="ECCMA.eTSR:"+@cmm
                            @url = request.protocol + request.host+ url1 + n1
                            @sql=EtsrImage.create(image_name: @url,image: "",image_id: @etsr_cmm)
                        end
                    elsif @id1==""
                        url1="/assets/"
                        @etsr_cmm="ECCMA.eTSR:"+@cmm
                        @url = params[:imageurl]
                        @sql=EtsrImage.create(image_name: @url,image: "",image_id: @etsr_cmm)
                    end                   

                    @b = @prop_name.zip(@prop_value).delete_if{ |x| x[1]==""}.collect{|y| y[0]+@y+y[1]}
                    @v=params[:prop_value].reject(&:blank?)
                    @bs= @term_content 
                    @class_1= @term_content 

                    
                    @v.each do |a|
                        @bs1= @bs+@z+a
                        if @bs1.length <= @len_sd.to_i
                            @bs=@bs+@z+a
                        end       
                    end
                    @b.each do |s|
                      @lg=@class_1+@x+s
                      if @lg.length>=@len_ld.to_i && @len_ld=='0'
                          @class_1=@class_1+@x+s

                      elsif @lg.length<=@len_ld.to_i && @len_ld!='0'
                          @class_1=@class_1+@x+s
                      end
                    end   

                    if @sh_case=='Lower Case'
                        @bs=@bs.downcase
                    elsif @sh_case=='Sentence Case'|| @lg_case=='Not Set'
                        @bs=@bs.capitalize
                    else 
                        @bs=@bs.upcase
                    end

                    if @lg_case=='Lower Case'
                        @class_1=@class_1.downcase
                      elsif @lg_case=='Sentence Case'|| @lg_case=='Not Set'
                        @class_1=@class_1.capitalize
                      else
                        @class_1=@class_1.upcase
                    end
                end  

                 if @originInput!="" && @country_orgin==""
                      @nameorigin=params[:originInput].original_filename.gsub("-","_")
                      n1=@cmm+"_"+@nameorigin
                      n2=@cmm+"_"+params[:originInput].original_filename.gsub("-","_").to_s
                      # @sql=Countryorigin.create(image_name: n1,image_id: @cmm)
                      @material_master=MaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class_name: @term_content,class_id: @concept_ID,cmm_material_no: @cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,source_image: n1)

                      tmp=params[:originInput].tempfile
                      destiny_file = File.join('app','assets','ests_orgin',n2)
                      FileUtils.move tmp.path, destiny_file   
                        if params[:upload_etsr]
                            url1="/assets/"
                            @etsr_cmm="ECCMA.eTSR:"+@cmm
                            @url = params[:imageurlco]
                            # @sql=EtsrCountryorigin.create(image_name: @url,image: "",image_id: @etsr_cmm)        
                            @etsr_material_master=EtsrMaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @etsr_cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class: @term_content,class_id: @concept_ID,cmm_material_no: @etsr_cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,FACTORY_ID: current_user.Organization_ID,FACTORY_NAME_ECCMA: current_user.name,FACTORY_NAME_TESS: '',source_image: @url)

                        end
                    elsif @country_orgin!="" && @originInput==""
                        # @sql=Countryorigin.create(image_name: @country_orgin,image_id: @cmm,image: "N")   

                        @material_master=MaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class_name: @term_content,class_id: @concept_ID,cmm_material_no: @cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,source_name: @country_orgin,sts: "N")

                        if params[:upload_etsr]
                            if params[:pictureInput]
                                @etsr_cmm="ECCMA.eTSR:"+@cmm
                                # @sql=EtsrCountryorigin.create(image_name: @country_orgin,image_id: @etsr_cmm,image: "N")
                                @etsr_material_master=EtsrMaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @etsr_cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class: @term_content,class_id: @concept_ID,cmm_material_no: @etsr_cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,FACTORY_ID: current_user.Organization_ID,FACTORY_NAME_ECCMA: current_user.name,FACTORY_NAME_TESS: '',source_name: @country_orgin,sts: "N")
                            end
                        end
                    elsif @country_orgin!="" && @originInput!=""
                        @material_master=MaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class_name: @term_content,class_id: @concept_ID,cmm_material_no: @cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,source_name: @country_orgin,sts: "N")   
                        if params[:upload_etsr]
                            if params[:pictureInput]
                                @etsr_cmm="ECCMA.eTSR:"+@cmm
                                @etsr_material_master=EtsrMaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @etsr_cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class: @term_content,class_id: @concept_ID,cmm_material_no: @etsr_cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,FACTORY_ID: current_user.Organization_ID,FACTORY_NAME_ECCMA: current_user.name,FACTORY_NAME_TESS: '',source_name: @country_orgin,sts: "N")
                            end
                        end                 
                    end

                @corp_ignames=CorpIgname.create(username: current_user.name,realname: current_user.name,igid: @igid,igversion: '',igversion: '',igref: @igid,Class_id: @concept_ID,Class_Name: @term_content,Class_Definition: @definition_content,Source: '',Source_registry: '',Source_builder: '',Uploaded_Filename: '',Private: '',igid_ref: '0',Done: '',Files_generated: '',ixml_file: '',organization_ID: current_user.Organization_ID,Copy_From: '',datecreated: Time.now)

                @val=@prop_name.zip(@prop_value,@prop_concept_ID,@prop_seq,@prop_source,@prop_term_ID,@prop_definition_ID,@prop_definition_content).each do |a,b,c,d,e,f,g,h|
                @prop_name=a
                @prop_value=b
                @prop_concept_ID=c
                @prop_seq=d
                @prop_source=e
                @prop_term_ID=f
                @prop_definition_ID=g
                @prop_definition_content=h

                if @val_case=='Lower Case'
                    @prop_value=@prop_value.downcase
                elsif @val_case=='Sentence Case'
                    @prop_value=@prop_value.capitalize
                else
                    @prop_value=@prop_value.upcase
                end
                   
                   @rxml_value = RxmlValue.create(row: @prop_seq,Seq: @prop_seq,igid: @igid,cat_id: @cmm,Class: @term_content,classref: @concept_ID,propertyRef: @prop_concept_ID,property: @prop_name,value: @prop_value,source: @prop_source,datecreated: Time.now,lastmodified: Time.now,language: @language_name)
                   
                   if params[:upload_etsr]
                        @etsr_cmm="ECCMA.eTSR:"+@cmm.to_s
                        @etsr_rxml_value = EtsrRxmlValue.create(row: @prop_seq,Seq: @prop_seq,igid: @igid,cat_id: @etsr_cmm,Class: @term_content,classref: @concept_ID,propertyRef: @prop_concept_ID,property: @prop_name,value: @prop_value,source: @prop_source,datecreated: Time.now,lastmodified: Time.now,language: @language_name)
                   end

                   @rxml_value = XmlRg.create(row: @prop_seq,igid: @igid,RGref: '',class_name: @term_content,propertyRef: @prop_concept_ID,termID: @prop_term_ID,definitionID: @prop_definition_ID,Property_Definition: @prop_definition_content,property: @prop_name,Required: 'Y',datecreated: Time.now)
                  
                end
            flash[:success] = "Succesfully Saved"
            redirect_to controller: 'home',action: 'view',cat_id: @cmm  

            elsif @template == "existtemplate"
                @igid = params[:igid].squish!
                @cmm = params[:cmm].squish!
                @material_id = params[:material_id]
                @term_content = params[:class_name]
                @concept_ID = params[:concept_ID]
                # @term_ID = params[:term_ID]
                # @definition_ID = params[:definition_ID]
                # @term_organization_name = params[:term_organization_name]
                @definition_content = params[:definition_content]
                @language_name = params[:language_name]
                @legacy = params[:legacy]

                @prop_name = params[:prop_name]
                @prop_concept_ID = params[:prop_concept_ID]
                @prop_term_ID = params[:prop_term_ID]
                @prop_definition_ID = params[:prop_definition_ID]
                # @prop_term_organization_name = params[:prop_term_organization_name]
                @prop_definition_content = params[:prop_definition_content]
                # @prop_language_name = params[:prop_language_name]
                @prop_value = params[:prop_value]
                @prop_source = params[:prop_source]
                # @prop_seq = params[:prop_seq]
                @prop_mandatory = params[:prop_mandatory]    
                @prop_seq=params[:prop_name].length
                @prop_seq=1..@prop_seq
                @originInput=params[:originInput]
                @country_orgin=params[:country_orgin]

                results=ActiveRecord::Base.connection.execute("select * from `ests_db`.settings")
                results.each(:as => :hash) do |res|
                    @z=res["class_prop_sep_SD"]
                    @y=res["prop_value_sep_LD"]
                    @x=res["class_prop_sep_LD"]
                    @sh_case=res["short_desc_case"]
                    @lg_case=res["long_desc_case"]
                    @val_case=res["value_case"]
                    @len_ld=res["length_LD"]
                    @len_sd=res["length_SD"]

                    @imagecount=Image.where("image_id = ?",@cmm).count

                    @id1=params[:pictureInput]
                    if @id1 
                      @im= Image.where("image_id = ?",@cmm).delete_all
                      @name=@id1.original_filename.gsub("-","_")
                      n1=@cmm+"_"+@name
                      n2=@cmm+"_"+params[:pictureInput].original_filename.gsub("-","_").to_s
                      @sql=Image.create(image_name: n1,image_id: @cmm)
                      tmp=params[:pictureInput].tempfile
                      destiny_file = File.join('app','assets','ests_image',n2)
                      FileUtils.move tmp.path, destiny_file
                    elsif @id1==""
                        url1="/assets/"
                        @etsr_cmm="ECCMA.eTSR:"+@cmm
                        @url = params[:imageurl]
                        @sql=EtsrImage.create(image_name: @url,image: "",image_id: @etsr_cmm)
                    end
                    

                    @b = @prop_name.zip(@prop_value).delete_if{ |x| x[1]==""}.collect{|y| y[0]+@y+y[1]}
                    @v=params[:prop_value].reject(&:blank?)
                    @bs= @term_content 
                    @class_1= @term_content 

                    
                    @v.each do |a|
                        @bs1= @bs+@z+a
                        if @bs1.length <= @len_sd.to_i
                            @bs=@bs+@z+a
                        end       
                    end
                    @b.each do |s|
                      @lg=@class_1+@x+s
                      if @lg.length>=@len_ld.to_i && @len_ld=='0'
                          @class_1=@class_1+@x+s

                      elsif @lg.length<=@len_ld.to_i && @len_ld!='0'
                          @class_1=@class_1+@x+s
                      end
                    end   

                    if @sh_case=='Lower Case'
                        @bs=@bs.downcase
                    elsif @sh_case=='Sentence Case'|| @lg_case=='Not Set'
                        @bs=@bs.capitalize
                    else 
                        @bs=@bs.upcase
                    end

                    if @lg_case=='Lower Case'
                        @class_1=@class_1.downcase
                      elsif @lg_case=='Sentence Case'|| @lg_case=='Not Set'
                        @class_1=@class_1.capitalize
                      else
                        @class_1=@class_1.upcase
                    end
                end

                @xmlrg = XmlRg.where("igid = ?", @igid)

                @xmlrg.each do |xmlrg|
                    @temp_xmlrg = XmlRgDelete.create(row: xmlrg.row,igid: xmlrg.igid,RGref: xmlrg.RGref,class_name: xmlrg.class_name,propertyRef: xmlrg.propertyRef,termID: xmlrg.termID,property: xmlrg.property,Property_Definition: xmlrg.Property_Definition,igid_ref: xmlrg.igid_ref,definitionID: xmlrg.definitionID,datecreated: xmlrg.datecreated, datedeleted: Time.now)
                end    
               
               @delete_xmlrg = XmlRg.where("igid = ?", @igid).delete_all

               @rxml_value = RxmlValue.where("igid = ?", @igid)

                @rxml_value.each do |rxml_value|
                    @temp_rxml_value = RxmlValueDelete.create(row: rxml_value.row,Seq: rxml_value.Seq,igid: rxml_value.igid,cat_id: rxml_value.cat_id,Class: rxml_value.Class,classref: rxml_value.classref,propertyRef: rxml_value.propertyRef,property: rxml_value.property,value: rxml_value.value,datecreated: rxml_value.datecreated,datecreated: Time.now,source: rxml_value.source,language: rxml_value.language)
                end 

                @delete_rxml_value = RxmlValue.where("igid = ?", @igid).delete_all

                if params[:upload_etsr]
                    @rxml_value_beta = EtsrRxmlValue.where("igid = ?", @igid)
                    @etsr_cmm="ECCMA.eTSR:"+@cmm
                    @rxml_value_beta.each do |rxml_value_beta|
                        @temp_rxml_value_beta = EtsrRxmlValueDelete.create(row: rxml_value_beta.row,Seq: rxml_value_beta.Seq,igid: rxml_value_beta.igid,cat_id: @etsr_cmm,Class: rxml_value_beta.Class,classref: rxml_value_beta.classref,propertyRef: rxml_value_beta.propertyRef,property: rxml_value_beta.property,value: rxml_value_beta.value,datecreated: rxml_value_beta.datecreated,datecreated: Time.now,source: rxml_value_beta.source,language: rxml_value_beta.language)
                    end  
                    @delete_rxml_value_beta = EtsrRxmlValue.where("igid = ?", @igid).delete_all
                end

                if @originInput
                      @nameorigin=params[:originInput].original_filename.gsub("-","_")
                      n1=@cmm+"_"+@nameorigin
                      n2=@cmm+"_"+params[:originInput].original_filename.gsub("-","_").to_s
                      # @sql=Countryorigin.where("image_id = ?",@cmm).update_all(image_name: n1)
                       @update1=MaterialMaster.where('cat_id = ?',@cmm).update_all({short_description: @bs,long_description: @class_1,lastmodified: Time.now,source_image: n1})
                      tmp=params[:originInput].tempfile
                      destiny_file = File.join('app','assets','ests_orgin',n2)
                      FileUtils.move tmp.path, destiny_file   
                    
                        if params[:upload_etsr]
                            url1="/assets/"
                            @etsr_cmm="ECCMA.eTSR:"+@cmm
                            @url = params[:imageurlco]
                            # @sql=EtsrCountryorigin.create(image_name: @url,image: "",image_id: @etsr_cmm)
                             @update1=EtsrMaterialMaster.where('cat_id = ?',@etsr_cmm).update_all({short_description: @bs,long_description: @class,lastmodified: Time.now,source_image: @url})  
                        end
                    elsif @country_orgin
                        # @sql=Countryorigin.where("image_id = ?",@cmm).update_all(image_name: @country_orgin,image: "N")   
                        if params[:upload_etsr]
                            if params[:pictureInput]
                                @etsr_cmm="ECCMA.eTSR:"+@cmm
                                # @sql=EtsrCountryorigin.where("image_id = ?",@etsr_cmm).update_all(image_name: @country_orgin,image: "N")
                                @update1=EtsrMaterialMaster.where('cat_id = ?',@etsr_cmm).update_all({short_description: @bs,long_description: @class,lastmodified: Time.now,source_name: @country_orgin,sts: "N"})
                            end
                        end        
                    end

                @val=@prop_name.zip(@prop_value,@prop_concept_ID,@prop_seq,@prop_source,@prop_term_ID,@prop_definition_ID,@prop_definition_content).each do |a,b,c,d,e,f,g,h|
                @prop_name=a
                @prop_value=b
                @prop_concept_ID=c
                @prop_seq=d
                @prop_source=e
                @prop_term_ID=f
                @prop_definition_ID=g
                @prop_definition_content=h

                if @val_case=='Lower Case'
                    @prop_value=@prop_value.downcase
                elsif @val_case=='Sentence Case'
                    @prop_value=@prop_value.capitalize
                else
                    @prop_value=@prop_value.upcase
                end
                   
                   @rxml_value = RxmlValue.create(row: @prop_seq,Seq: @prop_seq,igid: @igid,cat_id: @cmm,Class: @term_content,classref: @concept_ID,propertyRef: @prop_concept_ID,property: @prop_name,value: @prop_value,source: @prop_source,datecreated: Time.now,lastmodified: Time.now,language: @language_name)

                    if params[:upload_etsr]
                        @etsr_cmm="ECCMA.eTSR:"+@cmm
                        @rxml_value_betains = EtsrRxmlValue.create(row: @prop_seq,Seq: @prop_seq,igid: @igid,cat_id: @etsr_cmm,Class: @term_content,classref: @concept_ID,propertyRef: @prop_concept_ID,property: @prop_name,value: @prop_value,source: @prop_source,datecreated: Time.now,lastmodified: Time.now,language: @language_name)
                    end
                   
                   @rxml_value = XmlRg.create(row: @prop_seq,igid: @igid,RGref: '',class_name: @term_content,propertyRef: @prop_concept_ID,termID: @prop_term_ID,definitionID: @prop_definition_ID,Property_Definition: @prop_definition_content,property: @prop_name,Required: 'Y',datecreated: Time.now)
                end
                flash[:success] = "Succesfully Saved"
                redirect_to controller: 'home',action: 'view',cat_id: @cmm 

            end
        end

    end
    def loadexisting
        if params[:concept_ID]
        @concept_ID = params[:concept_ID]        
            @enable = CorpIgname.where("Class_id = ? AND datedeleted = ?", @concept_ID,'0000-00-00 00').select(:Class_id).count
            
            respond_to do |format|
                format.html {render :layout => false}
            end
        end

        if params[:term_content]
            @term_content = params[:term_content]
            @igid = params[:igid].squish!
            @load = XmlRg.where("class_name = ? AND datedeleted = ? AND igid = ?", @term_content,'0000-00-00 00',@igid).select(:property,:propertyRef,:termID,:definitionID,:Property_Definition).order(row: :asc)

            @loadcount=XmlRg.where("class_name = ? AND datedeleted = ?", @term_content,'0000-00-00 00').select(:property).count

            respond_to do |format|
                format.html {render :layout => false}
            end
        end 

        if params[:backorg]
            @backorg = params[:backorg]
            respond_to do |format|
                format.html {render :layout => false}
            end
        end 
        
        if params[:newigid]
            @newigid=(CorpIgname.maximum("igid"))
            if(@newigid=='' || @newigid==nil)
              @newigid='100001'
            else
              @newigid = @newigid.to_i + 1
            end   


            @newmax_no=(MaterialMaster.maximum("cmm_material_no"))

            if(@newmax_no=='' || @newmax_no==nil)
              @newmax_no='2000001'
            else    
              @newmax_no = @newmax_no.to_i + 1
            end
            @split = @newigid.to_s + "||" + @newmax_no.to_s
            respond_to do |format|
                format.html {render :layout => false}
            end
        end    
    end
    def template_search
        @class_names=CorpIgname.order('Class_Name ASC')
   end  
    def ajax_property
        @num1 = params["query"]      
        @xml_rg = XmlRg.select("property,propertyRef,Required,Property_Definition").where("class_name = ? ",@num1)
        respond_to do |format|
            format.html {render :layout => false}
        end
    end  
end