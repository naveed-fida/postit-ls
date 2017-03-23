module Sluggable
  extend ActiveSupport::Concern

  included do
    class_attribute :slug_column
    before_save :generate_slug
  end

  def to_param
    slug
  end

  def generate_slug
    slug_column = self.class.slug_column
    the_slug = to_slug(self.send(slug_column))
    obj = self.class.find_by slug: the_slug
    counter = 2

    while obj && obj != self
      the_slug = to_slug(self.send(slug_column)) + '-' + counter.to_s
      obj = self.class.find_by slug: the_slug
      counter += 1
    end

    self.slug = the_slug
  end

  def to_slug(name)
    str = name.strip
    str.gsub!(/[^A-Za-z0-9]|\s+/, '-')
    str.gsub!(/-+/, '-')
    str.downcase
  end

  module ClassMethods
    def sluggable_column(col_name)
      self.slug_column = col_name
    end
  end
end