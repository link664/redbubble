require 'spec_helper'

RSpec.describe ImageDataProcessor::HtmlBuilder::NavigationGenerator do

  describe "#generate_navigation" do
    context "when not including the index or any navigation items" do
      subject{ described_class.new([], :make) }

      it "returns an empty list" do
        expect(subject.generate_navigation).to eq "<ul></ul>"
      end
    end

    context "when including the index but no navigation items" do
      subject{ described_class.new([], :make, true) }

      it "returns a list with the index" do
        expect(subject.generate_navigation)
          .to eq "<ul><li><a href='index.html'>Index</a></li></ul>"
      end
    end

    context "when including navigation items but no index" do
      let(:navigation_items) do
        [
          ImageDataProcessor::Image.new(
            id: "111",
            make: "Fuji",
            model: "Finepix",
            thumbnail_url: "http://example.com/fuji.jpg"
          ),
          ImageDataProcessor::Image.new(
            id: "222",
            make: "Nikon",
            model: "D80",
            thumbnail_url: "http://example.com/nikon.jpg"
          ),
          ImageDataProcessor::Image.new(
            id: "333",
            make: "Canon",
            model: "Powershot",
            thumbnail_url: "http://example.com/powershot.jpg"
          )
        ]
      end

      let(:expected_output) do
        [
          "<ul>",
          "<li>",
          "<a href='fuji.html'>",
          "Fuji",
          "</a>",
          "</li>",
          "<li>",
          "<a href='nikon.html'>",
          "Nikon",
          "</a>",
          "</li>",
          "<li>",
          "<a href='canon.html'>",
          "Canon",
          "</a>",
          "</li>",
          "</ul>"
        ].join
      end

      subject{ described_class.new(navigation_items, :make) }

      it "returns a list with the navigation items" do
        expect(subject.generate_navigation).to eq expected_output
      end
    end

    context "when including both the index and navigation items" do
      let(:navigation_items) do
        [
          ImageDataProcessor::Image.new(
            id: "111",
            make: "Canon",
            model: "EOS 400D Digital",
            thumbnail_url: "http://example.com/400d.jpg"
          ),
          ImageDataProcessor::Image.new(
            id: "222",
            make: "Canon",
            model: "EOS 20D",
            thumbnail_url: "http://example.com/20d.jpg"
          ),
          ImageDataProcessor::Image.new(
            id: "333",
            make: "Canon",
            thumbnail_url: "http://example.com/powershot.jpg"
          )
        ]
      end

      let(:expected_output) do
        [
          "<ul>",
          "<li>",
          "<a href='index.html'>",
          "Index",
          "</a>",
          "</li>",
          "<li>",
          "<a href='canon/eos-400d-digital.html'>",
          "Canon EOS 400D Digital",
          "</a>",
          "</li>",
          "<li>",
          "<a href='canon/eos-20d.html'>",
          "Canon EOS 20D",
          "</a>",
          "</li>",
          "<li>",
          "<a href='canon/unknown.html'>",
          "Canon Unknown",
          "</a>",
          "</li>",
          "</ul>"
        ].join
      end

      subject{ described_class.new(navigation_items, :model, true) }

      it "returns a list with the navigation items" do
        expect(subject.generate_navigation).to eq expected_output
      end
    end
  end

end
