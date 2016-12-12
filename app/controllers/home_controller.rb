class HomeController < ApplicationController
    require 'will_paginate/array'
    before_filter :setting, :only => [:index, :view, :update, :addnew]

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
        @page = params[:page]
        @per_page=10
        @startfrom= (@page.to_i-1) * @per_page;

        if @listall=='1'
            @modal_class_count = ConceptDn.count_by_sql(["SELECT count(*) from `concept_dn` WHERE  concept_type_ID = '0161-1#CT-01#1'"])
            @modal_class = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id  AND a.term_content <>  '' UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE  a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '') LIMIT #{@startfrom},#{@per_page} "])
           
        elsif @listall=='0' 
            @class_name = params[:class_name]
            @organization = params[:organization]
            @language = params[:language]
            @query = params[:query]
           
            if @query=="like"
                if @class_name!=''  && @organization!='' && @language!=''

                @modal_class_count = ConceptDn.count_by_sql(["SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-01#1' and  language_ID = ? and term_organization_name = ? and term_content like ?","#{@language}","#{@organization}","%#{@class_name}%"])

                @modal_class = ConceptDn.find_by_sql(["SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID = ?  AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content like ? AND a.term_content <>  '' AND a.term_organization_name = ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.language_ID = ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content like ? AND a.term_content <>  '' AND a.term_organization_name = ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID = ? AND a.term_content like ? AND a.term_organization_name = ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '') LIMIT #{@startfrom},#{@per_page} ","#{@language}","%#{@class_name}%","#{@organization}","#{@language}","%#{@class_name}%","#{@organization}","#{@language}","%#{@class_name}%","#{@organization}"]) 

 
                elsif @class_name!='' && @organization=='' && @language==''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-01#1' and   term_content like ?","%#{@class_name}%"])

                    @modal_class =  ConceptDn.find_by_sql(["SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID =  ? and a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content like ? AND a.term_content <>  '' UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content like ? AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b  WHERE a.language_ID =  ? and a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content like ? AND a.term_content <>  '') LIMIT  #{@startfrom},#{@per_page}","#{@language}","%#{@class_name}%","%#{@class_name}%","#{@language}","%#{@class_name}%"])


 
                elsif @organization!='' && @class_name=='' && @language==''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-01#1' and  language_ID = '0161-1#LG-000001#1'and term_organization_name = ? ","%#{@organization}%"])

                    @modal_class = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '' AND a.term_organization_name = ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content <>  ''  AND a.term_organization_name = ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID = '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  ''AND a.term_organization_name = ?) LIMIT #{@startfrom},#{@per_page} ","#{@organization}","#{@organization}","#{@organization}"]) 


                elsif @language!='' && @organization=='' && @class_name==''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-01#1' and  language_ID  = ?","#{@language}"])

                    @modal_class = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID = ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  ''  UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.language_ID =  ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID = ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '') LIMIT #{@startfrom},#{@per_page} ","#{@language}","#{@language}","#{@language}"]) 
             
                elsif @class_name!='' && @organization!='' && @language==''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-01#1' and  language_ID ='0161-1#LG-000001#1' and term_organization_name = ? and term_content like ?","#{@organization}","%#{@class_name}%"])

                    @modal_class = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content like ? AND a.term_content <>  '' AND a.term_organization_name = ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content like ? AND a.term_content <>  ''  AND a.term_organization_name = ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '' AND a.term_content like ? AND a.term_organization_name = ?) LIMIT #{@startfrom},#{@per_page} ","%#{@class_name}%","#{@organization}","%#{@class_name}%","#{@organization}","%#{@class_name}%","#{@organization}"]) 


                elsif @class_name!='' && @organization=='' && @language!=''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-01#1' and  language_ID = ? and term_content like ?","#{@language}","%#{@class_name}%"])

                     @modal_class = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content like  ? AND  a.language_ID =  ? AND a.term_content <>  '' UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content like ? AND a.language_ID = ? AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE a.term_content like  ? AND a.language_ID = ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '' ) LIMIT #{@startfrom},#{@per_page} ","%#{@class_name}%",
                         "#{@language}","%#{@class_name}%","#{@language}","%#{@class_name}%","#{@language}"]) 


                elsif @class_name=='' && @organization!='' && @language!=''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-01#1' and  language_ID ='#{@language}' and term_organization_name = ? and term_content like ?","#{@organization}","#{@class_name}%"])

                    @modal_class = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.term_organization_name = ? AND a.language_ID =  ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  ''  UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.term_organization_name = ? AND a.language_ID =  ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE  a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '' AND a.term_organization_name = ? AND a.language_ID =  ?) LIMIT #{@startfrom},#{@per_page} ","#{@organization}","#{@language}","#{@organization}","#{@language}","#{@organization}","#{@language}"]) 

       
                elsif @class_name=='' && @organization=='' && @language==''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` WHERE  concept_type_ID = '0161-1#CT-01#1'"])

                    @modal_class = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id  AND a.term_content <>  '' UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID='0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '') LIMIT #{@startfrom},#{@per_page} "]) 
   
                 
                end 
            elsif @query=="startwith"
                if @class_name!=''  && @organization!='' && @language!=''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-01#1' and language_ID = ? and term_organization_name = ? and term_content like ?","#{@language}","#{@organization}","#{@class_name}%"])

                     @modal_class = ConceptDn.find_by_sql(["SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID = ?  AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content like ? AND a.term_content <>  '' AND a.term_organization_name = ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.language_ID = ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content like ? AND a.term_content <>  '' AND a.term_organization_name = ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID = ? AND a.term_content like ? AND a.term_organization_name = ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '') LIMIT #{@startfrom},#{@per_page} ","#{@language}","#{@class_name}%","#{@organization}","#{@language}","#{@class_name}%","#{@organization}","#{@language}","#{@class_name}%","#{@organization}"]) 

                elsif @class_name!='' && @organization=='' && @language==''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-01#1' and   term_content like ?","#{@class_name}%"])

                   @modal_class =  ConceptDn.find_by_sql(["SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID =  ? and a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content like ? AND a.term_content <>  '' UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content like ? AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b  WHERE a.language_ID =  ? and a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content like ? AND a.term_content <>  '') LIMIT #{@startfrom},#{@per_page}","#{@language}","#{@class_name}%","#{@class_name}%","#{@language}","#{@class_name}%"])



                elsif @organization!='' && @class_name=='' && @language==''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-01#1' and   term_organization_name = ? ","#{@organization}"])

                         @modal_class = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '' AND a.term_organization_name = ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content <>  ''  AND a.term_organization_name = ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE  a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  ''AND a.term_organization_name = ?) LIMIT #{@startfrom},#{@per_page} ","#{@organization}","#{@organization}","#{@organization}"]) 

                elsif @language!='' && @organization=='' && @class_name==''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-01#1' and  language_ID = ?","#{@language}"])
                    
                    @modal_class = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID = ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  ''  UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.language_ID =  ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID = ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '') LIMIT #{@startfrom},#{@per_page} ","#{@language}","#{@language}","#{@language}"]) 
             
                
                elsif @class_name!='' && @organization!='' && @language==''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-01#1' and  language_ID ='0161-1#LG-000001#1' and term_organization_name = ? and term_content like ?","#{@organization}","#{@class_name}%"])

                    @modal_class = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content like ? AND a.term_content <>  '' AND a.term_organization_name = ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content like ? AND a.term_content <>  ''  AND a.term_organization_name = ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '' AND a.term_content like ? AND a.term_organization_name = ?) LIMIT #{@startfrom},#{@per_page} ","#{@class_name}%","#{@organization}","#{@class_name}%","#{@organization}","#{@class_name}%","#{@organization}"]) 


                elsif @class_name!='' && @organization=='' && @language!=''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-01#1' and  language_ID = ? and term_content like ?","#{@language}","#{@class_name}%"])

                     @modal_class = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content like  ? AND  a.language_ID =  ? AND a.term_content <>  '' UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content like ? AND a.language_ID = ? AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE a.term_content like  ? AND a.language_ID = ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '' ) LIMIT #{@startfrom},#{@per_page} ","#{@class_name}%","#{@language}%","#{@class_name}%","#{@language}","#{@class_name}%","#{@language}"])  

                elsif @class_name=='' && @organization!='' && @language!=''

                     @modal_class_count = ConceptDn.count_by_sql(["SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-01#1' and  language_ID ='#{@language}' and term_organization_name = ? and term_content like ?","#{@organization}","#{@class_name}%"])

                      @modal_class = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.term_organization_name = ? AND a.language_ID =  ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  ''  UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.term_organization_name = ? AND a.language_ID =  ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE  a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '' AND a.term_organization_name = ? AND a.language_ID =  ?) LIMIT #{@startfrom},#{@per_page} ","#{@organization}","#{@language}","#{@organization}","#{@language}","#{@organization}","#{@language}"]) 


                elsif @class_name=='' && @organization=='' && @language==''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` WHERE  concept_type_ID = '0161-1#CT-01#1'"])

                  @modal_class = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id  AND a.term_content <>  '' UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID='0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '') LIMIT #{@startfrom},#{@per_page} "])  
         
                end  
            else
                if @class_name!=''  && @organization!='' && @language!=''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-01#1' and  language_ID = ? and term_organization_name = ? and term_content = ?","#{@language}","#{@organization}","#{@class_name}"])

                   @modal_class = ConceptDn.find_by_sql(["SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID = ?  AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content = ? AND a.term_content <>  '' AND a.term_organization_name = ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.language_ID = ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content = ? AND a.term_content <>  '' AND a.term_organization_name = ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID = ? AND a.term_content = ? AND a.term_organization_name = ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '') LIMIT #{@startfrom},#{@per_page} ","#{@language}","#{@class_name}","#{@organization}","#{@language}","#{@class_name}","#{@organization}","#{@language}","#{@class_name}","#{@organization}"]) 

                elsif @class_name!='' && @organization=='' && @language==''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-01#1' and  language_ID ='0161-1#LG-000001#1' and term_content = ?","#{@class_name}"])

                   @modal_class =  ConceptDn.find_by_sql(["SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID =  '0161-1#LG-000001#1' and a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content like ? AND a.term_content <>  '' UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content = ? AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b  WHERE a.language_ID =  '0161-1#LG-000001#1' and a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content  = ? AND a.term_content <>  '') LIMIT #{@startfrom},#{@per_page}","#{@class_name}","#{@class_name}","#{@class_name}"])


                elsif @organization!='' && @class_name=='' && @language==''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-01#1' and  language_ID ='0161-1#LG-000001#1' and term_organization_name = ? ","#{@organization}"])

                            @modal_class = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '' AND a.term_organization_name = ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content <>  ''  AND a.term_organization_name = ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID = '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  ''AND a.term_organization_name = ?) LIMIT #{@startfrom},#{@per_page} ","#{@organization}","#{@organization}","#{@organization}"]) 

                elsif @language!='' && @organization=='' && @class_name==''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-01#1' and  language_ID = ? ","#{@language}"])
                      
                    @modal_class = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID = ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  ''  UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.language_ID =  ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID = ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '') LIMIT #{@startfrom},#{@per_page} ","#{@language}","#{@language}","#{@language}"]) 
             
                
                elsif @class_name!='' && @organization!='' && @language==''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-01#1' and  language_ID ='0161-1#LG-000001#1' and  term_organization_name = ? and term_content = ?","#{@organization}","#{@class_name}"])

                       @modal_class = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content = ? AND a.term_content <>  '' AND a.term_organization_name = ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content = ? AND a.term_content <>  ''  AND a.term_organization_name = ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '' AND a.term_content = ? AND a.term_organization_name = ?) LIMIT #{@startfrom},#{@per_page} ","#{@class_name}","#{@organization}","#{@class_name}","#{@organization}","#{@class_name}","#{@organization}"]) 


                elsif @class_name!='' && @organization=='' && @language!=''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-01#1' and  language_ID = ? and term_content = ?","#{@language}","#{@class_name}"])

                        @modal_class = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content =  ? AND  a.language_ID =  ? AND a.term_content <>  '' UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content = ? AND a.language_ID = ? AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE a.term_content =  ? AND a.language_ID = ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '' ) LIMIT #{@startfrom},#{@per_page} ","#{@class_name}","#{@language}","#{@class_name}","#{@language}","#{@class_name}","#{@language}"]) 


                elsif @class_name=='' && @organization!='' && @language!=''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-01#1' and  language_ID = ? and term_organization_name = ? ","#{@language}","#{@organization}"])

                     @modal_class = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.term_organization_name = ? AND a.language_ID =  ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  ''  UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.term_organization_name = ? AND a.language_ID =  ? AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE  a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '' AND a.term_organization_name = ? AND a.language_ID =  ?) LIMIT #{@startfrom},#{@per_page} ","#{@organization}","#{@language}","#{@organization}","#{@language}","#{@organization}","#{@language}"]) 

                elsif @class_name=='' && @organization=='' && @language==''

                     @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` WHERE  concept_type_ID = '0161-1#CT-01#1'"])

                    @modal_class = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id  AND a.term_content <>  '' UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID='0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '') LIMIT #{@startfrom},#{@per_page} "])       
                end   
            end 
        elsif @listall=='reset' 

            @modal_class_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` WHERE  concept_type_ID = '0161-1#CT-01#1'"])

                  @modal_class = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'s' FROM  `concept_dn` a,  `corp_ignames` b WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id  AND a.term_content <>  '' UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,a.language_ID,'y' FROM  `concept_dn` a WHERE a.concept_type_ID =  '0161-1#CT-01#1' AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `corp_ignames` b WHERE a.language_ID='0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-01#1' AND a.concept_id = b.Class_id AND a.term_content <>  '') LIMIT #{@startfrom},#{@per_page} "])
        end                    
            
        respond_to do |format|
          format.html {render :layout => false}
        end
    end

    def modalprop
        @listprop = params[:listprop]
        @page = params[:page]
        @per_page=10
        @startfrom= (@page.to_i-1) * @per_page;  
         
        if @listprop == '1'
            @modal_prop_count=ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID='0161-1#CT-02#1'"])
            @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE  a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE  a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE  a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '') LIMIT  #{@startfrom},#{@per_page} "])  

        elsif @listprop == '0'
            @property_name = params[:property_name]
            @organization_prop = params[:organization_prop]
            @language_prop = params[:language_prop]
            @query = params[:query_prop]
            
            if @query=="like"
              

                if @property_name!=''  && @organization_prop!='' && @language_prop!=''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where  concept_type_ID = '0161-1#CT-02#1' and  language_ID = ? and term_organization_name = ? and term_content like ?","#{@language_prop}","#{@organization_prop}","%#{@property_name}%"])

                    @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name =? AND language_ID = ? AND term_content like ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND term_organization_name = ? AND language_ID = ? AND term_content like ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name =? AND language_ID = ? AND term_content like ?) LIMIT #{@startfrom},#{@per_page}","#{@organization_prop}","#{@language_prop}","%#{@property_name}%","#{@organization_prop}","#{@language_prop}","%#{@property_name}%","#{@organization_prop}","#{@language_prop}","%#{@property_name}%",])  


                elsif @property_name!='' && @organization_prop=='' && @language_prop==''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1' and  term_content like ?","%#{@property_name}%"])

                    @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  ? AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  ''  AND term_content like ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  ''  AND term_content like ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  ? AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_content like ?) LIMIT #{@startfrom},#{@per_page}","#{@language_prop}","%#{@property_name}%","%#{@property_name}%","#{@language_prop}","%#{@property_name}%"])  

                elsif @organization_prop!='' && @property_name=='' && @language_prop==''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1' and language_ID ='0161-1#LG-000001#1' and term_organization_name = ? ","#{@organization_prop}"])

                    @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name = ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND term_organization_name = ?  AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name = ?) LIMIT #{@startfrom},#{@per_page}","%#{@organization_prop}%","%#{@organization_prop}%","%#{@organization_prop}%"])         

                elsif @language_prop!='' && @organization_prop=='' && @property_name==''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1' and language_ID = ?","%#{@language_prop}%"])

                     @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND language_ID = ?  UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND language_ID = ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  ''  AND language_ID = ? ) LIMIT #{@startfrom},#{@per_page}","#{@language_prop}","#{@language_prop}","#{@language_prop}"])  

                elsif @property_name!='' && @organization_prop!='' && @language_prop==''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1' and language_ID ='0161-1#LG-000001#1' and term_organization_name = ? and term_content like ?","#{@organization_prop}","%#{@property_name}%"])

                     @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name = ?  AND term_content like ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND term_organization_name = ? AND term_content like ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name = ?  AND term_content like ?) LIMIT #{@startfrom},#{@per_page}","#{@organization_prop}","%#{@property_name}%","#{@organization_prop}","%#{@property_name}%","#{@organization_prop}","%#{@property_name}%"])      

                elsif @property_name!='' && @organization_prop=='' && @language_prop!=''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1' and language_ID = ?  and term_content like ?","#{@language_prop}","%#{@property_name}%"])

                     @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND language_ID =? AND term_content like ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND  language_ID = ? AND term_content like ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND language_ID =? AND term_content like ?) LIMIT #{@startfrom},#{@per_page}","#{@language_prop}","%#{@property_name}%","#{@language_prop}","%#{@property_name}%","#{@language_prop}","%#{@property_name}%"])  

                elsif @property_name=='' && @organization_prop!='' && @language_prop!=''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1' and language_ID ='#{@language_prop}' and term_organization_name = ? and term_content like ?","#{@organization_prop}","#{@property_name}%"])

                     @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name = ? AND language_ID = ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND term_organization_name = ? AND language_ID = ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name = ? AND language_ID = ?) LIMIT #{@startfrom},#{@per_page}","#{@organization_prop}","#{@language_prop}","#{@organization_prop}","#{@language_prop}","#{@organization_prop}","#{@language_prop}"])   

                elsif @property_name=='' && @organization_prop=='' && @language_prop==''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1'"])

                   @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '') LIMIT #{@startfrom},#{@per_page}"]) 
                end    
            elsif @query=="startwith"
               if @property_name!=''  && @organization_prop!='' && @language_prop!=''

                         @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1' and language_ID = ? and term_organization_name = ? and term_content like ?","#{@language_prop}","#{@organization_prop}","#{@property_name}%"])

                        @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name = ? AND language_ID = ? AND term_content like ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND term_organization_name = ? AND language_ID = ? AND term_content like ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name = ? AND language_ID = ? AND term_content like ?) LIMIT #{@startfrom},#{@per_page}","#{@organization_prop}","#{@language_prop}","#{@property_name}%","#{@organization_prop}","#{@language_prop}","#{@property_name}%","#{@organization_prop}","#{@language_prop}","#{@property_name}%"]) 

                elsif @property_name!='' && @organization_prop=='' && @language_prop==''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1' and language_ID ='0161-1#LG-000001#1' and  term_content like ?","#{@property_name}%"])

                      @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  ''  AND term_content like ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  ''  AND term_content like ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_content like ?) LIMIT #{@startfrom},#{@per_page}","#{@property_name}%","#{@property_name}%","#{@property_name}%"])        

                elsif @organization_prop!='' && @property_name=='' && @language_prop==''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1' and  term_organization_name = ? ","#{@organization_prop}"])

                     @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE  a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name = ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND term_organization_name = ?  AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE  a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name = ?) LIMIT #{@startfrom},#{@per_page}","#{@organization_prop}","#{@organization_prop}","#{@organization_prop}"])        

                elsif @language_prop!='' && @organization_prop=='' && @property_name==''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1' and language_ID = ? ","#{@language_prop}"])

                    @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  ? AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND language_ID = ?  UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.language_ID =  ? AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND language_ID = ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  ? AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND language_ID = ?) LIMIT #{@startfrom},#{@per_page}","#{@language_prop}","#{@language_prop}","#{@language_prop}","#{@language_prop}","#{@language_prop}","#{@language_prop}"]) 

                elsif @property_name!='' && @organization_prop!='' && @language_prop==''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1' and language_ID ='0161-1#LG-000001#1' and term_organization_name = ? and term_content like ?","#{@organization_prop}","#{@property_name}%"])

                    @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name = ?  AND term_content like ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND term_organization_name = ? AND term_content like ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name = ?  AND term_content like ?) LIMIT #{@startfrom},#{@per_page}","#{@organization_prop}","#{@property_name}%","#{@organization_prop}","#{@property_name}%","#{@organization_prop}","#{@property_name}%"])   

                elsif @property_name!='' && @organization_prop=='' && @language_prop!=''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1' and language_ID = ? and term_content like ?","#{@language_prop}","#{@property_name}%"])

                   @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_content like? AND language_ID = ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND term_content like ? AND language_ID = ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_content like ? AND language_ID = ?) LIMIT #{@startfrom},#{@per_page}","#{@property_name}%","#{@language_prop}","#{@property_name}%","#{@language_prop}","#{@property_name}%","#{@language_prop}"])   

                elsif @property_name=='' && @organization_prop!='' && @language_prop!=''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1' and language_ID = ? and term_organization_name like ?","#{@language_prop}","#{@organization_prop}"])

                      @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  ? AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name = ? AND language_ID = ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.language_ID =  ? AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND term_organization_name = ? AND language_ID = ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  ? AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name = ? AND language_ID = ?) LIMIT #{@startfrom},#{@per_page}","#{@organization_prop}","#{@language_prop}","#{@organization_prop}","#{@language_prop}","#{@organization_prop}","#{@language_prop}","#{@language_prop}","#{@language_prop}","#{@language_prop}"])  


                elsif @property_name=='' && @organization_prop=='' && @language_prop==''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1'"])

                      @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE  a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE  a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE  a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '') LIMIT #{@startfrom},#{@per_page}"]) 
                end   
            else
                if @property_name!=''  && @organization_prop!='' && @language_prop!=''

                         @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1' and language_ID = ? and term_organization_name = ? and term_content = ?","#{@language_prop}","#{@organization_prop}","#{@property_name}"])

                        @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name = ? AND language_ID = ? AND term_content = ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND term_organization_name = ? AND language_ID = ? AND term_content = ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name = ? AND language_ID = ? AND term_content = ? ) LIMIT #{@startfrom},#{@per_page}","#{@organization_prop}","#{@language_prop}","#{@property_name}","#{@organization_prop}","#{@language_prop}","#{@property_name}","#{@organization_prop}","#{@language_prop}","#{@property_name}"])  

                elsif @property_name!='' && @organization_prop=='' && @language_prop==''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1' and  term_content = ?","#{@property_name}"])

                      @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE  a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  ''  AND term_content = ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE  a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  ''  AND term_content = ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE  a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  ''  AND term_content = ? ) LIMIT #{@startfrom},#{@per_page}","#{@property_name}","#{@property_name}","#{@property_name}"])       

                elsif @organization_prop!='' && @property_name=='' && @language_prop==''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1' and language_ID ='0161-1#LG-000001#1' and term_organization_name = ? ","#{@organization_prop}"])

                         @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name = ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND term_organization_name = ?  AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  ''  AND term_organization_name = ? ) LIMIT #{@startfrom},#{@per_page}","#{@organization_prop}","#{@organization_prop}","#{@organization_prop}"])          

                elsif @language_prop!='' && @organization_prop=='' && @property_name==''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1' and language_ID = ?","#{@language_prop}"])

                     @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND language_ID = ?  UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND language_ID = ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  ''AND language_ID = ?) LIMIT #{@startfrom},#{@per_page}","#{@language_prop}","#{@language_prop}","#{@language_prop}"]) 

                elsif @property_name!='' && @organization_prop!='' && @language_prop==''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1' and language_ID ='0161-1#LG-000001#1' and term_organization_name = ? and term_content = ?","#{@organization_prop}","#{@property_name}"])

                      @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name = ?  AND term_content = ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND term_organization_name = ? AND term_content = ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name = ?  AND term_content = ? ) LIMIT #{@startfrom},#{@per_page}","#{@organization_prop}","#{@property_name}","#{@organization_prop}","#{@property_name}","#{@organization_prop}","#{@property_name}"])    

                elsif @property_name!='' && @organization_prop=='' && @language_prop!=''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1' and language_ID = ? and term_content = ?","#{@language_prop}","#{@property_name}"])

                    @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_content = ? AND language_ID = ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND term_content = ? AND language_ID = ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  ''  AND term_content = ? AND language_ID = ?) LIMIT #{@startfrom},#{@per_page}","#{@property_name}","#{@language_prop}","#{@property_name}","#{@language_prop}","#{@property_name}","#{@language_prop}"])   

                elsif @property_name=='' && @organization_prop!='' && @language_prop!=''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1' and language_ID = ? and term_organization_name = ? ","#{@language_prop}","#{@organization_prop}"])

                      @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' AND term_organization_name = ? AND language_ID = ? UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND term_organization_name = ? AND language_ID = ? AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  ''  AND term_organization_name = ? AND language_ID = ?) LIMIT #{@startfrom},#{@per_page}","#{@organization_prop}","#{@language_prop}","#{@organization_prop}","#{@language_prop}","#{@organization_prop}","#{@language_prop}"])      

                elsif @property_name=='' && @organization_prop=='' && @language_prop==''

                     @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID = '0161-1#CT-02#1'"])

                      @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.language_ID =  '0161-1#LG-000001#1' AND a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '') LIMIT #{@startfrom},#{@per_page}"]) 

                end            
            end           
        elsif @listprop == 'reset'

             @modal_prop_count = ConceptDn.count_by_sql([" SELECT count(*) from `concept_dn` where concept_type_ID='0161-1#CT-02#1'"])

                   @modal_prop = ConceptDn.find_by_sql([" SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'s' FROM  `concept_dn` a,  `xml_rg` b WHERE  a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '' UNION SELECT DISTINCT a.term_content, a.concept_ID, a.term_ID, a.definition_ID, a.term_organization_name, a.definition_content, a.language_name,'y' FROM  `concept_dn` a WHERE  a.concept_type_ID =  '0161-1#CT-02#1' AND a.term_content <>  '' AND a.concept_ID not in (SELECT DISTINCT a.concept_ID FROM  `concept_dn` a,  `xml_rg` b WHERE a.concept_type_ID =  '0161-1#CT-02#1' AND a.concept_id = b.propertyRef AND a.term_content <>  '') LIMIT #{@startfrom},#{@per_page}"]) 

           
        end
        respond_to do |format|
          format.html {render :layout => false}
        end   
    end

    def addnew
        @lang = Orglanguage.select('language_ID, language_name').where("avilable=?",'y')
        @org = Organization.select('Legal_name').where("avilable = ?",'y')

        @max_no=(MaterialMaster.maximum("cmm_material_no"))

        if(@max_no=='' || @max_no==nil )
          @max_no='2000001'
        else    
          @max_no = @max_no.to_i + 1
        end

        @igid=CorpIgname.find_by_sql(["SELECT max(igid) as igid FROM `corp_ignames`"])
        @igid.map {|i| @igid=i.igid }
        
         if(@igid=='' || @igid==nil )
          @igid='100001'
        else    
          @igid=@igid[10,6]
          @igid=@igid.to_i + 1;
        end
        @igid='0161-1#'+'IG-'+@igid.to_s+'#1'



        @class_prop = params[:term_content]
        @template = params[:template]
        if @class_prop
            @class_igid=params[:class_igid]
            @igid1=params[:igid]
            if @class_igid==0
                @igid = params[:igid].squish!
            elsif @class_igid==@igid1 
                @igid = params[:igid].squish! 
            elsif  @class_igid!=@igid1  && @igid1!=''
                @igid = params[:class_igid] 
            else
              
                @igid=CorpIgname.find_by_sql(["SELECT max(igid) as igid FROM `corp_ignames`"])
                @igid.map {|i| @igid=i.igid }
                
                 if(@igid=='' || @igid==nil )
                  @igid='100001'
                else    
                  @igid=@igid[10,6]
                  @igid=@igid.to_i + 1;
                end
                @igid='0161-1#'+'IG-'+@igid.to_s+'#1'
            end
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
          
            
            if  @temp_decide==0
                @igid=CorpIgname.find_by_sql(["SELECT max(igid) as igid FROM `corp_ignames`"])
                @igid.map {|i| @igid=i.igid }
                
                 if(@igid=='' || @igid==nil )
                  @igid='100001'
                else    
                  @igid=@igid[10,6]
                  @igid=@igid.to_i + 1;
                end
                @igid='0161-1#'+'IG-'+@igid.to_s+'#1'
            end
                @igid = @igid.to_s
                @cmm = @cmm.to_s

               @id1=params[:pictureInput]
                if @id1
                  @name=@id1.original_filename.gsub("-","_")
                  n1=@cmm+"_"+@name
                  n2=@cmm+"_"+params[:pictureInput].original_filename.gsub("-","_").to_s
                  @sql=Image.create(image_name: n1,image_id: @cmm)
                  tmp=params[:pictureInput].tempfile
                  destiny_file = File.join('public','images','ests_images',n2)
                  FileUtils.move tmp.path, destiny_file

                    if params[:upload_etsr]
                     
                            url1="/images/ests_images/"
                            @etsr_cmm="ECCMA.eTSR:"+@cmm
                            @url = request.protocol + request.host+ url1 + n1
                            @sql=EtsrImage.create(image_name: @url,image: "",image_id: @etsr_cmm)
                  
                    end
                end           

                @b = @prop_name.zip(@prop_value).delete_if{ |x| x[1]==""}.collect{|y| y[0]+@y+y[1]}
                @v=params[:prop_value].reject(&:blank?)
                @bs= @term_content 
                @class_1= @term_content 
                    
                
                @v.each do |a|
                    @bs1= @bs+@z+a
                    if @bs1.length <= @len_sd.to_i
                        @bs=@bs+@z+a
                    elsif @len_sd==0
                        @bs=@bs+@z+a
                    end       
                end

                @b.each do |s|
                      @lg=@class_1+@x+s
                    
                       if @lg.length<=@len_ld.to_i
                         @class_1=@class_1+@x.to_s+s

                        elsif @len_ld.to_i==0
                            @class_1=@class_1+@x+s
                        end
                    end   

                

                if @sh_case=='Lower Case'
                    @bs=@bs.downcase
                elsif @sh_case=='Sentence Case'|| @sh_case=='Not Set'
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

        

            if @originInput!="" && @country_orgin==""
                  @nameorigin=params[:originInput].original_filename.gsub("-","_")
                  n1=@cmm+"_"+@nameorigin
                  n2=@cmm+"_"+params[:originInput].original_filename.gsub("-","_").to_s

                   @material_master=MaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class_name: @term_content,class_id: @concept_ID,cmm_material_no: @cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,source_image: n1)

                  tmp=params[:originInput].tempfile
                  destiny_file = File.join('public','images','ests_orgin',n2)
                  FileUtils.move tmp.path, destiny_file   
                
                if params[:upload_etsr]
                    url1="/images/ests_orgin/"
                    @etsr_cmm="ECCMA.eTSR:"+@cmm
                    @url = request.protocol + request.host+ url1 + n1                    
                    if @url
                    @etsr_material_master=EtsrMaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @etsr_cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class: @term_content,class_id: @concept_ID,cmm_material_no: @cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,FACTORY_ID: current_user.Organization_ID,FACTORY_NAME_ECCMA: current_user.name,FACTORY_NAME_TESS: '',source_image: @url,source_name:'')
                    else
                    @etsr_material_master=EtsrMaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @etsr_cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class: @term_content,class_id: @concept_ID,cmm_material_no: @cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,FACTORY_ID: current_user.Organization_ID,FACTORY_NAME_ECCMA: current_user.name,FACTORY_NAME_TESS: '',source_image: '',source_name:'')

                    end

                end
            elsif @country_orgin!="" && @originInput==""
                @material_master=MaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class_name: @term_content,class_id: @concept_ID,cmm_material_no: @cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,source_image:'',source_name: @country_orgin,sts: "N")

                if params[:upload_etsr]
                        @etsr_cmm="ECCMA.eTSR:"+@cmm
                         @etsr_material_master=EtsrMaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @etsr_cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class: @term_content,class_id: @concept_ID,cmm_material_no: @cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,FACTORY_ID: current_user.Organization_ID,FACTORY_NAME_ECCMA: current_user.name,FACTORY_NAME_TESS: '',source_name: @country_orgin,source_image:'',sts: "N")
                end
            elsif @country_orgin!="" && @originInput!=""
                 @material_master=MaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class_name: @term_content,class_id: @concept_ID,cmm_material_no: @cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,source_image:'',source_name: @country_orgin,sts: "N")

                if params[:upload_etsr]
                        @etsr_cmm="ECCMA.eTSR:"+@cmm
                        @etsr_material_master=EtsrMaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @etsr_cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class: @term_content,class_id: @concept_ID,cmm_material_no: @cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,FACTORY_ID: current_user.Organization_ID,FACTORY_NAME_ECCMA: current_user.name,FACTORY_NAME_TESS: '',source_name: @country_orgin,source_image:'',sts: "N")
                end                 
            end

            if @template == "existtemplate"
                @igid = params[:igid].squish!
                @delete_xmlrg = XmlRgDelete.where("igid = ?",@igid).delete_all
                @xmlrg = XmlRg.where("igid = ?",@igid)

                @xmlrg.each do |xmlrg|
                @temp_xmlrg = XmlRgDelete.create(row: xmlrg.row,igid: xmlrg.igid,RGref: xmlrg.RGref,class_name: xmlrg.class_name,propertyRef: xmlrg.propertyRef,termID: xmlrg.termID,property: xmlrg.property,Property_Definition: xmlrg.Property_Definition,igid_ref: xmlrg.igid_ref,definitionID: xmlrg.definitionID,datecreated: xmlrg.datecreated, datedeleted: Time.now)
                end    
                 

                @delete_xmlrg = XmlRg.where("igid = ?",@igid).delete_all

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

                if @temp_decide==0 || @template=="existtemplate"
                    @rxml_value = XmlRg.create(row: @prop_seq,igid: @igid,RGref: '',class_name: @term_content,propertyRef: @prop_concept_ID,termID: @prop_term_ID,definitionID: @prop_definition_ID,Property_Definition: @prop_definition_content,property: @prop_name,Required: 'Y',datecreated: Time.now)
                end
            end
             
            if @temp_decide==0                  
            @corp_ignames=CorpIgname.create(username: current_user.name,realname: current_user.name,igid: @igid,igversion: '',igref: @igid,Class_id: @concept_ID,Class_Name: @term_content,Class_Definition: @definition_content,Source: '',Source_registry: '',Source_builder: '',Uploaded_Filename: '',Private: '',igid_ref: '0',Done: '',Files_generated: '',ixml_file: '',organization_ID: current_user.Organization_ID,Copy_From: '',datecreated: Time.now)
            end     
            flash[:success] = "Successfully Saved"
            redirect_to controller: 'home',action: 'view', cat_id: @cmm
        end         
    end

    def view        

        @cat_id=params[:cat_id]        
        @len=Setting.where("organization_ID=123")
        @data=MaterialMaster.where("cat_id = ?",@cat_id)
        @data1=RxmlValue.where("cat_id = ? and datedeleted = ?",@cat_id,'0000-00-00 00:00:00').order(row: :asc)
        
        @data_count=RxmlValue.where("cat_id = ? and datedeleted = ?",@cat_id,'0000-00-00 00:00:00').select(:row,:igid).limit(1).order(row: :desc)

        @image=Image.where("image_id = ?",@cat_id)
        @imagecount=Image.where("image_id = ?",@cat_id).count
        @cmm="ECCMA.eTSR:"+@cat_id
        @etsr_mm=EtsrMaterialMaster.where("cat_id = ? and datedeleted = ?",@cmm,'0000-00-00 00:00:00').count
        @lang = Orglanguage.select('language_ID, language_name').where("avilable=?",'y')
        @org = Organization.select('Legal_name').where("avilable = ?",'y')
    end

    def dictionary_detail
        vars = request.query_parameters
        @esci = vars['esci']
        @esci = Base64.decode64(@esci)
        @mm =ConceptDn.where("concept_ID = ? ", @esci )

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

            @imagecount=Image.where("image_id = ?",@id).count
            if @imagecount==1
                @id1=params[:pictureInput]
                if @id1 
                  @name=@id1.original_filename.gsub("-","_")
                  n1=@cmm+"_"+@name
                  n2=@cmm+"_"+params[:pictureInput].original_filename.gsub("-","_").to_s
                   
                  @sql=Image.where('image_id=?', @cmm).update_all(image_name: n1)
                  tmp=params[:pictureInput].tempfile
                  destiny_file = File.join('public','images','ests_images',n2)
                  FileUtils.move tmp.path, destiny_file

                    if params[:upload_etsr]
                          url1="/images/ests_images/"
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
                  destiny_file = File.join('public','images','ests_images',n2)
                  FileUtils.move tmp.path, destiny_file

                    if params[:upload_etsr]
                      
                        url1= "/images/ests_images/"
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
                        @bs1= @bs+@z+a
                        if @bs1.length <= @len_sd.to_i
                            @bs=@bs+@z+a
                        elsif @len_sd==0
                            @bs=@bs+@z+a
                        end       
                    end

                    @lg=@class+@x+s
                    if @lg.length<=@len_ld.to_i
                         @class=@class+@x.to_s+s

                    elsif @len_ld.to_i==0
                        @class=@class+@x.to_s+s                        
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
            if @originInput
                  @nameorigin=params[:originInput].original_filename.gsub("-","_")
                  n1=@cmm+"_"+@nameorigin
                  n2=@cmm+"_"+params[:originInput].original_filename.gsub("-","_").to_s
                  @update1=MaterialMaster.where('cat_id = ?',@id).update_all({short_description: @bs,long_description: @class,lastmodified: Time.now,source_image: n1})
                  tmp=params[:originInput].tempfile
                  destiny_file = File.join('public','images','ests_orgin',n2)
                  FileUtils.move tmp.path, destiny_file   
            
                elsif @country_orgin
                    @update1=MaterialMaster.where('cat_id = ?',@id).update_all({short_description: @bs,long_description: @class,lastmodified: Time.now,source_name: @country_orgin,sts: "N"})
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
                    @ds=@ds.downcase
                    @es=@es.downcase
                elsif @val_case=='Sentence Case' || @val_case=='Not Set'
                    @cs=@cs.capitalize
                    @ds=@ds.capitalize
                    @es=@es.capitalize
                else
                    @cs=@cs.upcase
                    @ds=@ds.upcase
                    @es=@es.upcase
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
                        url1="/images/ests_orgin"
                        @etsr_cmm="ECCMA.eTSR:"+@cmm
                        @url = request.protocol + request.host+ url1 + n1
                      @update1=EtsrMaterialMaster.where('cat_id = ?',@etsr_cmm).update_all({short_description: @bs,long_description: @class,lastmodified: Time.now,source_image: @url})  
                      tmp=params[:originInput].tempfile
                      destiny_file = File.join('public','images','ests_orgin',n2)
                      FileUtils.move tmp.path, destiny_file 
                    elsif @country_orgin
                        @update1=EtsrMaterialMaster.where('cat_id = ?',@etsr_cmm).update_all({short_description: @bs,long_description: @class,lastmodified: Time.now,source_name: @country_orgin,sts: "N"})
                    end 
                    for a,b,c,d in @b.zip(@c,@a,@d)
                        @cs=a
                        @ds=b
                        @es=c
                        @source=d
                        if @val_case=='Lower Case'
                            @cs=@cs.downcase
                            @ds=@ds.downcase
                            @es=@es.downcase
                        elsif @val_case=='Sentence Case'
                            @cs=@cs.capitalize
                            @ds=@ds.capitalize
                            @es=@es.capitalize
                        else
                            @cs=@cs.upcase
                            @ds=@ds.upcase
                            @es=@es.upcase
                        end
                        @update=EtsrRxmlValue.where('Seq = ? AND property = ? AND cat_id = ? ',@es,@ds,@etsr_cmm).update_all(value: @cs,source: @source,lastmodified: Time.now)
                    end

                elsif @check_up==0
                    @mm_value_up = MaterialMaster.where("cat_id = ?", @id)
                    @mm_value_up.each do |mm_value_up|                        
                        @up_mm_value_up=EtsrMaterialMaster.create(username: current_user.name,realname: current_user.name,igid: mm_value_up.igid,cat_id:@etsr_cmm,catalog_name: mm_value_up.catalog_name,material_id: mm_value_up.material_id,datecreated: Time.now,legacy_description: mm_value_up.legacy_description,short_description: mm_value_up.short_description,long_description: mm_value_up.long_description,class: mm_value_up.class,class_id: mm_value_up.class_id,cmm_material_no: mm_value_up.cmm_material_no,organization_ID: current_user.Organization_ID,approved_by: '',language: mm_value_up.language,lastmodified: Time.now,FACTORY_ID: current_user.Organization_ID,FACTORY_NAME_ECCMA: current_user.name,FACTORY_NAME_TESS: '',source_image: mm_value_up.source_image,source_name: mm_value_up.source_name,sts: mm_value_up.sts)
                    end

                    @rxml_value_up = RxmlValue.where("cat_id = ?", @id)
                    @rxml_value_up.each do |rxml_value_beta|
                        @up_rxml_value_beta = EtsrRxmlValue.create(row: rxml_value_beta.row,Seq: rxml_value_beta.Seq,igid: rxml_value_beta.igid,cat_id: @etsr_cmm,Class: rxml_value_beta.Class,classref: rxml_value_beta.classref,propertyRef: rxml_value_beta.propertyRef,property: rxml_value_beta.property,value: rxml_value_beta.value,datecreated: Time.now,source: rxml_value_beta.source,language: rxml_value_beta.language)
                    end      
                end 

            end
            flash[:success] = "Successfully Saved"
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
                @definition_content = params[:definition_content]
                @language_name = params[:language_name]
                @legacy = params[:legacy]

                @prop_name = params[:prop_name]
                @prop_concept_ID = params[:prop_concept_ID]
                @prop_term_ID = params[:prop_term_ID]
                @prop_definition_ID = params[:prop_definition_ID]
                @prop_definition_content = params[:prop_definition_content]
                @prop_value = params[:prop_value]
                @prop_source = params[:prop_source]
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

               
                @igid=CorpIgname.find_by_sql(["SELECT max(igid) as igid FROM `corp_ignames`"])
                @igid.map {|i| @igid=i.igid }

                if(@igid=='' || @igid==nil )
                @igid='100001'
                else    
                @igid=@igid[10,6]
                @igid=@igid.to_i + 1;
                end
                @igid='0161-1#'+'IG-'+@igid.to_s+'#1'
                @cmm = @cmm

               

                    @imagecount=Image.where("image_id = ?",@cmm).count

                    @id1=params[:pictureInput]
                    if @id1 
                      @name=@id1.original_filename.gsub("-","_")
                      n1=@cmm+"_"+@name
                      n2=@cmm+"_"+params[:pictureInput].original_filename.gsub("-","_").to_s
                      
                      @sql=Image.create(image_name: n1,image_id: @cmm)
                      tmp=params[:pictureInput].tempfile
                      destiny_file = File.join('public','images','ests_images',n2)
                      FileUtils.move tmp.path, destiny_file

                        if params[:upload_etsr]
                            url1="/images/ests_images/"
                            @etsr_cmm="ECCMA.eTSR:"+@cmm
                            @url = request.protocol + request.host+ url1 + n1
                            @sql=EtsrImage.create(image_name: @url,image: "",image_id: @etsr_cmm)
                        end
                    elsif @id1==""
                        url1="/images/ests_images"
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
                    
                       if @lg.length<=@len_ld.to_i
                         @class_1=@class_1+@x.to_s+s

                        elsif @len_ld.to_i==0
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

                 if @originInput!="" && @country_orgin==""
                      @nameorigin=params[:originInput].original_filename.gsub("-","_")
                      n1=@cmm+"_"+@nameorigin
                      n2=@cmm+"_"+params[:originInput].original_filename.gsub("-","_").to_s
                      @material_master=MaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class_name: @term_content,class_id: @concept_ID,cmm_material_no: @cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,source_image: n1)

                      tmp=params[:originInput].tempfile
                      destiny_file = File.join('public','images','ests_orgin',n2)
                      FileUtils.move tmp.path, destiny_file   
                        if params[:upload_etsr]
                            url1="/images/ests_orgin"
                            @etsr_cmm="ECCMA.eTSR:"+@cmm
                            @url = params[:imageurlco]
                            if @url   
                            @etsr_material_master=EtsrMaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @etsr_cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class: @term_content,class_id: @concept_ID,cmm_material_no: @etsr_cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,FACTORY_ID: current_user.Organization_ID,FACTORY_NAME_ECCMA: current_user.name,FACTORY_NAME_TESS: '',source_image: @url)
                            else
                             @etsr_material_master=EtsrMaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @etsr_cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class: @term_content,class_id: @concept_ID,cmm_material_no: @etsr_cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,FACTORY_ID: current_user.Organization_ID,FACTORY_NAME_ECCMA: current_user.name,FACTORY_NAME_TESS: '',source_image: '')   
                            end    

                        end
                    elsif @country_orgin!="" && @originInput==""

                        @material_master=MaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class_name: @term_content,class_id: @concept_ID,cmm_material_no: @cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,source_image: '',source_name: @country_orgin,sts: "N")

                        if params[:upload_etsr]
                            if params[:pictureInput]
                                @etsr_cmm="ECCMA.eTSR:"+@cmm
                                @etsr_material_master=EtsrMaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @etsr_cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class: @term_content,class_id: @concept_ID,cmm_material_no: @etsr_cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,FACTORY_ID: current_user.Organization_ID,FACTORY_NAME_ECCMA: current_user.name,FACTORY_NAME_TESS: '',source_name: @country_orgin,sts: "N")
                            end
                        end
                    elsif @country_orgin!="" && @originInput!=""
                        @material_master=MaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class_name: @term_content,class_id: @concept_ID,cmm_material_no: @cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,source_image: '',source_name: @country_orgin,sts: "N")   
                        if params[:upload_etsr]
                            if params[:pictureInput]
                                @etsr_cmm="ECCMA.eTSR:"+@cmm
                                @etsr_material_master=EtsrMaterialMaster.create(username: current_user.name,realname: current_user.name,igid: @igid,cat_id: @etsr_cmm,catalog_name: @term_content,material_id: @material_id,datecreated: Time.now,legacy_description: @legacy,short_description: @bs,long_description: @class_1,class: @term_content,class_id: @concept_ID,cmm_material_no: @etsr_cmm,organization_ID: current_user.Organization_ID,approved_by: '',language: @language_name,lastmodified: Time.now,FACTORY_ID: current_user.Organization_ID,FACTORY_NAME_ECCMA: current_user.name,FACTORY_NAME_TESS: '',source_name: @country_orgin,sts: "N")
                            end
                        end                 
                    end

                @corp_ignames=CorpIgname.create(username: current_user.name,realname: current_user.name,igid: @igid,igversion: '',igref: @igid,Class_id: @concept_ID,Class_Name: @term_content,Class_Definition: @definition_content,Source: '',Source_registry: '',Source_builder: '',Uploaded_Filename: '',Private: '',igid_ref: '0',Done: '',Files_generated: '',ixml_file: '',organization_ID: current_user.Organization_ID,Copy_From: '',datecreated: Time.now)

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
            flash[:success] = "Successfully Saved"
            redirect_to controller: 'home',action: 'view',cat_id: @cmm  

            elsif @template == "existtemplate"
                @igid = params[:igid].squish!
                @cmm = params[:cmm].squish!
                @material_id = params[:material_id]
                @term_content = params[:class_name]
                @concept_ID = params[:concept_ID]
                @definition_content = params[:definition_content]
                @language_name = params[:language_name]
                @legacy = params[:legacy]

                @prop_name = params[:prop_name]
                @prop_concept_ID = params[:prop_concept_ID]
                @prop_term_ID = params[:prop_term_ID]
                @prop_definition_ID = params[:prop_definition_ID]
                @prop_definition_content = params[:prop_definition_content]
                @prop_value = params[:prop_value]
                @prop_source = params[:prop_source]
                @prop_mandatory = params[:prop_mandatory]    
                @prop_seq=params[:prop_name].length
                @prop_seq=1..@prop_seq
                @originInput=params[:originInput]
                @country_orgin=params[:country_orgin]

              

                    @imagecount=Image.where("image_id = ?",@cmm).count

                    @id1=params[:pictureInput]
                    if @id1 
                      @im= Image.where("image_id = ?",@cmm).delete_all
                      @name=@id1.original_filename.gsub("-","_")
                      n1=@cmm+"_"+@name
                      n2=@cmm+"_"+params[:pictureInput].original_filename.gsub("-","_").to_s
                     
                      @sql=Image.create(image_name: n1,image_id: @cmm)
                      tmp=params[:pictureInput].tempfile
                      destiny_file = File.join('public','images','ests_images',n2)
                      FileUtils.move tmp.path, destiny_file
                    elsif @id1==""
                        url1="/images/ests_images"
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
                      
                       if @lg.length<=@len_ld.to_i
                         @class_1=@class_1+@x.to_s+s

                            elsif @len_ld.to_i==0
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
                

                @xmlrg = XmlRg.where("igid = ?", @igid)

                @xmlrg.each do |xmlrg|
                    @temp_xmlrg = XmlRgDelete.create(row: xmlrg.row,igid: xmlrg.igid,RGref: xmlrg.RGref,class_name: xmlrg.class_name,propertyRef: xmlrg.propertyRef,termID: xmlrg.termID,property: xmlrg.property,Property_Definition: xmlrg.Property_Definition,igid_ref: xmlrg.igid_ref,definitionID: xmlrg.definitionID,datecreated: xmlrg.datecreated, datedeleted: Time.now)
                end    
               
               @delete_xmlrg = XmlRg.where("igid = ?", @igid).delete_all

               @rxml_value = RxmlValue.where("cat_id = ?", @cmm)

                @rxml_value.each do |rxml_value|
                    @temp_rxml_value = RxmlValueDelete.create(row: rxml_value.row,Seq: rxml_value.Seq,igid: rxml_value.igid,cat_id: rxml_value.cat_id,Class: rxml_value.Class,classref: rxml_value.classref,propertyRef: rxml_value.propertyRef,property: rxml_value.property,value: rxml_value.value,datecreated: Time.now,source: rxml_value.source,language: rxml_value.language)
                end 

                @delete_rxml_value = RxmlValue.where("cat_id = ?", @cmm).delete_all

                if params[:upload_etsr]
                    @rxml_value_beta = EtsrRxmlValue.where("igid = ?", @igid)
                    @etsr_cmm="ECCMA.eTSR:"+@cmm
                    @rxml_value_beta.each do |rxml_value_beta|
                        @temp_rxml_value_beta = EtsrRxmlValueDelete.create(row: rxml_value_beta.row,Seq: rxml_value_beta.Seq,igid: rxml_value_beta.igid,cat_id: @etsr_cmm,Class: rxml_value_beta.Class,classref: rxml_value_beta.classref,propertyRef: rxml_value_beta.propertyRef,property: rxml_value_beta.property,value: rxml_value_beta.value,datecreated: Time.now,source: rxml_value_beta.source,language: rxml_value_beta.language)
                    end  
                    @delete_rxml_value_beta = EtsrRxmlValue.where("igid = ?", @igid).delete_all
                end

                if @originInput
                      @nameorigin=params[:originInput].original_filename.gsub("-","_")
                      n1=@cmm+"_"+@nameorigin
                      n2=@cmm+"_"+params[:originInput].original_filename.gsub("-","_").to_s
                       @update1=MaterialMaster.where('cat_id = ?',@cmm).update_all({short_description: @bs,long_description: @class_1,lastmodified: Time.now,source_image: n1})
                      tmp=params[:originInput].tempfile
                      destiny_file = File.join('public','images','ests_orgin',n2)
                      FileUtils.move tmp.path, destiny_file   
                    
                        if params[:upload_etsr]
                            url1="/images/ests_orgin"
                            @etsr_cmm="ECCMA.eTSR:"+@cmm
                            @url = params[:imageurlco]
                             @update1=EtsrMaterialMaster.where('cat_id = ?',@etsr_cmm).update_all({short_description: @bs,long_description: @class_1,lastmodified: Time.now,source_image: @url})  
                        end
                    elsif @country_orgin
                          @update1=MaterialMaster.where('cat_id = ?',@cmm).update_all({short_description: @bs,long_description: @class_1,lastmodified: Time.now,source_image: n1})
                        if params[:upload_etsr]
                                @etsr_cmm="ECCMA.eTSR:"+@cmm
                        @update1=EtsrMaterialMaster.where('cat_id = ?',@etsr_cmm).update_all({short_description: @bs,long_description: @class_1,lastmodified: Time.now,source_name: @country_orgin,sts: "N"})
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
                flash[:success] = "Successfully Saved"
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

        if params[:term_content] && params[:con]
            @term_content = params[:term_content]
             @concept_Id=params[:con]
             @results=CorpIgname.where("class_id = ? AND datedeleted = ?", @concept_Id,'0000-00-00 00').all
            @results.map {|i| 
                @igid_1=i.igid 
            }
               
            @load = XmlRg.where("class_name = ? AND datedeleted = ? AND igid = ?", @term_content,'0000-00-00 00',@igid_1).select(:property,:propertyRef,:termID,:definitionID,:Property_Definition).order(row: :asc)

            @loadcount=XmlRg.where("class_name = ? AND datedeleted = ?", @term_content,'0000-00-00 00').select(:property).count

            respond_to do |format|
                format.html {render :layout => false}
            end
        end 

        if params[:backorg]
            @backorg = params[:backorg]
            @concept_Id=params[:con]
             @results=CorpIgname.where("class_id = ? AND datedeleted = ?", @concept_Id,'0000-00-00 00').all
            @results.map {|i| 
                @igid_1=i.igid 
            }
            respond_to do |format|
                format.html {render :layout => false}
            end
        end 
        
        if params[:newigid]
           
            @igid=CorpIgname.find_by_sql(["SELECT max(igid) as igid FROM `corp_ignames`"])
            @igid.map {|i| @igid=i.igid }
            
             if(@igid=='' || @igid==nil )
              @igid='100001'
            else    
              @igid=@igid[10,6]
              @igid=@igid.to_i + 1;
            end
            @igid='0161-1#'+'IG-'+@igid.to_s+'#1' 


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

    private
    def setting
            @results=Setting.where("organization_ID = ?", "123").all
            @results.map {|i| 
                @z=i.class_prop_sep_SD 
                @y=i.prop_value_sep_LD 
                @x=i.class_prop_sep_LD 
                @sh_case=i.short_desc_case 
                @lg_case=i.long_desc_case 
                @val_case=i.value_case 
                @len_ld=i.length_LD 
                @len_sd=i.length_SD 
            }
    end
end