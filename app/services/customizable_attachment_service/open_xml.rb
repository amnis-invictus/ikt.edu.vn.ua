module CustomizableAttachmentService
  class OpenXml < Base
    XML_SAVE_WITH = Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_EMPTY_TAGS
    private_constant :XML_SAVE_WITH
    DOC_PROPS_CORE_XPATHES = [
      '/cp:coreProperties/dc:subject',
      '/cp:coreProperties/cp:keywords',
      '/cp:coreProperties/dc:description',
      '/cp:coreProperties/cp:category',
    ].freeze
    private_constant :DOC_PROPS_CORE_XPATHES

    def data
      generate_data
    end

    def valid? all_secrets
      secrets_in_file = load_secrets_from_file
      all_secrets_except_current_user = Set.new all_secrets
      all_secrets_except_current_user.delete @secret

      # Condition order is important!
      # We need to check that secrets_in_file does not include secrets of other users
      # before checking if it includes the current user's secret
      # to make sure that file is not shared with other users.
      if secrets_in_file.intersect? all_secrets_except_current_user
        :other_user
      elsif secrets_in_file.include? @secret
        :current_user
      else
        # Includes if secrets_in_file.empty? variant
        :unknown
      end
    end

    private

    def generate_data
      buffer = Zip::OutputStream.write_buffer do |out|
        # Zip::File is used here because it allows to copy_raw_entry
        # which is not works in Zip::InputStream
        # See https://github.com/rubyzip/rubyzip/issues/650
        Zip::File.open_buffer StringIO.new(@file.download) do |zip_file|
          zip_file.each do |entry|
            case entry.name
            when 'docProps/core.xml'
              doc_props_core = Nokogiri::XML entry.get_input_stream
              DOC_PROPS_CORE_XPATHES.each do |xpath|
                add_or_update_value doc_props_core, xpath
              end

              out.put_next_entry entry
              out.write doc_props_core.to_xml(save_with: XML_SAVE_WITH)

            # Ignore for now because
            # doc.at_xpath("/xmlns:Properties", "xmlns" => "http://schemas.openxmlformats.org/officeDocument/2006/extended-properties")
            # when 'docProps/app.xml'
            #  doc_props_app = Nokogiri::XML entry.get_input_stream
            #  add_or_update_value doc_props_app, '/Properties/Manager'
            #  add_or_update_value doc_props_app, '/Properties/Company'
            #  out.put_next_entry entry.name, entry.comment, entry.extra, entry.compression_method, 1
            #  out.write doc_props_app.to_xml(save_with: XML_SAVE_WITH)
            else
              # Internal helper to copy entries from one zip to another
              # See https://github.com/rubyzip/rubyzip/issues/650
              out.copy_raw_entry entry
            end
          end
        end
      end

      buffer.string
    end

    def add_or_update_value doc, xpath
      if (node = doc.at_xpath xpath)
        node.content = @secret
      elsif (parent_node = doc.at_xpath xpath.rpartition('/').first)
        new_node_name = xpath.split('/').last
        new_node = Nokogiri::XML::Node.new new_node_name, doc
        new_node.content = @secret
        parent_node.add_child new_node
      else
        Rails.logger.warn \
          "Cannot process file #{@file.filename} - node and parent for #{xpath} not found. Cannot add new node."
      end
    end

    def load_secrets_from_file
      secrets = Set.new
      Zip::File.open_buffer StringIO.new(@file.download) do |zip_file|
        zip_file.each do |entry|
          case entry.name
          when 'docProps/core.xml'
            doc_props_core = Nokogiri::XML entry.get_input_stream
            DOC_PROPS_CORE_XPATHES.each do |xpath|
              if (node = doc_props_core.at_xpath xpath)
                secrets.add node.content
              end
            end
            # Ignore for now because
            # doc.at_xpath("/xmlns:Properties", "xmlns" => "http://schemas.openxmlformats.org/officeDocument/2006/extended-properties")
            # when 'docProps/app.xml'
            #  doc_props_app = Nokogiri::XML entry.get_input_stream
            #  ['/Properties/Manager',
            #   '/Properties/Company'].each do |xpath|
            #    if (node = doc_props_app.at_xpath xpath)
            #      secrets.add node.content
            #    end
            #  end
          end
        end
      end

      secrets
    end
  end
end
