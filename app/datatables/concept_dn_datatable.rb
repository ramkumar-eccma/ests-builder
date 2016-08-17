class ConceptDnDatatable < AjaxDatatablesRails::Base

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['ConceptDn.term_content','ConceptDn.concept_ID','ConceptDn.term_ID','ConceptDn.definition_ID','ConceptDn.term_organization_name','ConceptDn.definition_content']
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= ['ConceptDn.term_content','ConceptDn.concept_ID','ConceptDn.term_ID','ConceptDn.definition_ID','ConceptDn.term_organization_name','ConceptDn.definition_content']
  end

  private

  def data
    records.map do |record|
      [
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
      ]
    end
  end

  def get_raw_records
    # insert query here
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
