module Pdf
  # Creates Certificates in the pdf format.
  class Certificate
    class << self
      # Generates a certificate with the given +name+ and +number+.
      def generate(name, number)
        filename = "#{name}_#{number}.pdf"
        options = { page_size: 'A4',
                    page_layout: :portrait }

        Prawn::Document.generate(filename, options) do |d|
          d.font 'resources/LiberationSerif-Regular.ttf'
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
