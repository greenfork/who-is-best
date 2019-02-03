module Pdf
  # Creates Certificates in the pdf format.
  class Certificate
    PAGE_SIZE = 'A4'.freeze
    PAGE_LAYOUT = :portrait
    FONT_PATH = 'resources/LiberationSerif-Regular.ttf'.freeze

    class << self
      ##
      # Generates a certificate and either creates a PDF file or returns
      # a stream with this PDF file.
      #
      # * +name+ - This string will appear in the center of the certificate.
      # * +number+ - This string will appear in the center of the certificate
      #   prepended with a '#' sign.
      # * +filename+ - The path and name of the file when +as_file+
      #   option is specified.
      # * +as_file+ - If this is set to true, then the function returns
      #   +nil+ and the file with +filename+ is generated. If this is set
      #   to false, then the function returns the stream and no file is
      #   generated. True by default.
      # * +font+ - Path to the font or one of the standard fonts defined
      #   for PDF format like 'Helvetica', 'Courier', etc. Defaults to
      #   +FONT_PATH+.

      def generate(name, number, filename: nil, as_file: true,
                   font: FONT_PATH)
        filename ||= "#{name}_#{number}.pdf"
        options = { page_size: PAGE_SIZE,
                    page_layout: PAGE_LAYOUT }

        Prawn::Document.generate(filename, options) do |d|
          d.font font
          d.move_down 100
          d.text "##{number}", align: :center, size: 128, color: 'FF0000'
          d.text name, align: :center, size: 60
          d.move_down 20
          d.text cheerup_phrase, align: :center, size: 48
        end
      end

      private

      def cheerup_phrase
        [
          'Very good job!',
          'You are the best!',
          'Вы самый лучший!',
          'Отличная работа!',
          'Du bist der beste'
        ].sample
      end
    end
  end
end
