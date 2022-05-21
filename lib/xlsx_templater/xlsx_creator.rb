require 'zip'

module XlsxTemplater
  class XlsxCreator
    attr_accessor :template_path, :template_processor, :sheet

    def initialize(template_path, data, sheet = 1, delimiter: '$')
      @template_path = template_path
      @sheet = sheet
      @template_processor = TemplateProcessor.new(data, delimiter)
    end

    def generate_xlsx_file(file_name = "output_#{Time.now.strftime('%Y-%m-%d_%H%M')}.xlsx")
      File.open(file_name, 'w') do |f|
        f.write(generate_xlsx_bytes.string)
      end
    end

    def generate_xlsx_bytes
      Zip::OutputStream.write_buffer do |out|
        Zip::File.open(template_path).each do |entry|
          entry_name = entry.name
          out.put_next_entry(entry_name)
          out.write(copy_or_template(entry_name, entry.get_input_stream.read))
        end
      end
    end

    private

    def copy_or_template(entry_name, entry_bytes)
      # Inside the word document archive is one file with contents of the actual document. Modify it.
      if entry_name == "xl/worksheets/sheet#{@sheet}.xml" or entry_name == "xl/sharedStrings.xml"
        template_processor.render(entry_bytes)
      else
        entry_bytes
      end
    end
  end
end
