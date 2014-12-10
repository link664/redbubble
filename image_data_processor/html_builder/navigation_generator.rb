# This class is responsible for building the appropriate
# navigation to be inserted into the HTML template.

module ImageDataProcessor
  class HtmlBuilder::NavigationGenerator

    def initialize(images, type, include_index = false)
      @images_by_make = images.group_by{ |image| image.make }
      @type = type
      @include_index = include_index
    end

    attr_reader :images_by_make, :type

    def include_index?
      !!@include_index
    end

    def generate_navigation
      ["<ul>"].tap{ |navigation_parts|
        navigation_parts << generate_menu_item("Index") if include_index?
        navigation_parts << generate_menu

        navigation_parts << "</ul>"
      }.join
    end

    private

    def generate_menu
      images_by_make.inject([]){ |navigation_parts, (make, images)|
        navigation_parts.concat generate_menu_item_of_type(make, images)
      }.join
    end

    def generate_menu_item_of_type(make, images)
      if type == :make
        [generate_menu_item(make)]
      elsif type == :model
        images.inject([]) do |navigation_parts, image|
          navigation_parts << generate_menu_item(make, image.model)
        end
      end
    end

    def generate_menu_item(parent, child = nil)
      path = generate_path(parent, child)
      text = generate_text(parent, child)

      ["<li>"].tap{ |item_parts|
        item_parts << "<a href='#{path}'>"
        item_parts << text
        item_parts << "</a>"
        item_parts << "</li>"
      }.join
    end

    def generate_path(parent, child = nil)
      path_parts = []
      path_parts << parent.downcase.gsub(" ",  "-")
      path_parts << child.downcase.gsub(" ", "-") unless child.nil?
      "#{path_parts.join("/")}.html"
    end

    def generate_text(parent, child = nil)
      [parent, child].compact.join(" ")
    end
  end

end
