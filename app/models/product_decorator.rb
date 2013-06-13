Product.class_eval do
  attr_accessible :delete_taxon, :add_taxon
  after_save :add_taxon_save

  def active?
    self.deleted_at.nil? and available?
  end

  def available?
    available_on.nil? ? false : available_on < Time.zone.now
  end

  def add_taxon_save
    return true unless add_taxon.present?
    taxon = Taxon.find(add_taxon)
    self.taxons << taxon if !self.taxons.include? taxon
    true
  end

  def delete_taxon=(id)
    taxons.delete(Taxon.find(id))
  end
end
