require 'rails_helper'

RSpec.describe Pdf::Certificate do
  let(:name) { 'Joe' }
  let(:number) { '1' }
  let(:filename) { 'tmp/testfile.pdf' }
  let(:cheerup_phrase) { 'Very good' }

  before(:context) { Dir.mkdir('tmp') unless Dir.exist?('tmp') }

  before(:example) do
    allow(described_class).to receive(:cheerup_phrase) { cheerup_phrase }
  end

  after(:example) { File.delete(filename) if File.exist?(filename) }

  context 'with valid arguments' do
    it 'generates a PDF file' do
      rs = described_class.generate(name, number, filename: filename)
      expect(File.exist?(filename)).to be true
      expect(rs).to be_nil
    end

    it 'allows to change the font' do
      described_class.generate(name, number, filename: filename,
                               font: 'Helvetica')
      expect(File.exist?(filename)).to be true
    end

    it 'generates a string representation of a PDF file' do
      str = described_class.generate(name, number, as_file: false)
      expect(str).to be_instance_of(String)
    end
  end

  context 'with Russian arguments' do
    let(:name) { 'Джо' }
    let(:cheerup_phrase) { 'Очень хорошо' }

    it 'generates a pdf file' do
      described_class.generate(name, number, filename: filename)
      expect(File.exist?(filename)).to be true
    end
  end
end
