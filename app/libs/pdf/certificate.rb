module Pdf
  # Creates Certificates in the pdf format.
  class Certificate
    PAGE_SIZE = 'A4'.freeze
    PAGE_LAYOUT = :portrait
    FONT_PATH = 'resources/LiberationSerif-Regular.ttf'.freeze

    class << self
      # Generates a certificate with the given +name+ and +number+. Optionally
      # accepts the +filename+ and +font+ with the paths from project root.
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
