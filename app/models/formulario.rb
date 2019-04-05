class Formulario < ApplicationRecord

    validates :title, :cover_letter, :categoria, :presence => true

    ROUTE_PATH = "#{Rails.root}/public/Archivos/procesos/"
    REFERENCES_CATEGORY = {
      "avaluo" => "avalúo",
      "compra" => "compra",
      "captacion" => "captación",
      "credito" => "crédito"
    }

    before_create :convert_category
    before_save :convert_category

    scope :by_category, -> (value) {where(categoria: value)}
    def convert_category
      self.categoria.downcase
    end

    def self.get_name_folder
      folders = Dir[ "#{ROUTE_PATH}**" ].reject{|folder| !File.directory?(folder)}
      return [] if !folders.present?
      folders.map{|folder| File.basename(folder).capitalize}
    end

    def self.return_true_files directory
      return [] if directory.nil?
      directory.reject{|file| File.directory?(file)}
    end

    def self.search(search=nil)

      return Formulario.all if search.nil?
      Formulario.by_category(search)

      #return return_true_files(Dir["#{ROUTE_PATH}/**/**"]) if !search.present?
      #route_path = "#{ROUTE_PATH}#{search.downcase}"
      #File.directory?(route_path) ? return_true_files(Dir["#{route_path}/**"]) : return_true_files(Dir["#{ROUTE_PATH}/**/**"])
    end
end
