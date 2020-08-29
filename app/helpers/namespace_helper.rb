module NamespaceHelper

  def current_namespace
    controller_path.split("/").first
  end

end
