Taxon.class_eval do
  after_save :update_children_taxonomy, :if => :taxonomy_id_changed?

  def not_deleted_products_count
    self.self_and_descendants.map { |tax| tax.products.select(:id).not_deleted }.flatten.uniq.size
  end

  def update_children_taxonomy
    self.children.each { |ch| ch.update_attributes(:taxonomy_id => self.taxonomy.id) }
    true
  end

  def products_taxons
    if children.empty?
      products.map{|p| Taxon.joins(:products).where('products.id = ?', p.id)}.flatten.compact.uniq
    else
      children.map{|t| t.products_taxons}.flatten.compact.uniq
    end
  end

end
