require "i18n"
module FormulariosHelper
  def get_name_folder
    folders = Dir[ "#{Formulario::ROUTE_PATH}**" ].reject{|folder| !File.directory?(folder)}
    return [] if !folders.present?
    folder_names = folders.map{|folder| File.basename(folder).capitalize}
    array_example = []
    folder_names.each{|folder| array_example << [folder, I18n.transliterate(folder.downcase)]}
    array_example
  end
end


