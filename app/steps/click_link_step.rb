class ClickLinkStep < Step
  data_attribute :name
  
  collection_url "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/steps"
  member_url "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/steps/:id"
  custom_urls :sort_url => "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/steps/sort"
  
  include Formotion::Formable
  
  form_property :name, :string
  
  def self.attributes
    superclass.attributes
  end
  
  def summary
    "Click link"
  end
  
  def detail
    "with name '#{name}'"
  end
end
