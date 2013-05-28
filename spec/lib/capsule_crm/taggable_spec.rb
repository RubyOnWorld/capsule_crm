require 'spec_helper'

class TaggableItem
  include CapsuleCRM::Taggable
  include Virtus

  attribute :id
end

describe CapsuleCRM::Taggable do
  before { configure }

  describe '#tags' do
    before do
      stub_request(:get, /\/api\/taggableitem\/1\/tag$/).
        to_return(body: File.read('spec/support/all_tags.json'))
    end

    let(:taggable_item) { TaggableItem.new(id: 1) }

    subject { taggable_item.tags }

    it { should be_a(Array) }

    it { subject.length.should eql(2) }

    it do
      subject.all? { |item| item.is_a?(CapsuleCRM::Tag) }.should be_true
    end

    it { subject.first.name.should eql('Customer') }

    it { subject.last.name.should eql('VIP') }
  end

  describe '#add_tag' do
    context 'when the taggable item has an id' do
      let(:taggable_item) { TaggableItem.new(id: 1) }

      before do
        loc = 'https://sample.capsulecrm.com/api/party/1000/tag/A%20Test%20Tag'
        stub_request(:post, /\/api\/taggableitem\/1\/A%20Test%20Tag$/).
          to_return(headers: { 'Location' =>  loc })
      end

      subject { taggable_item.add_tag 'A Test Tag' }

      it { subject.should be_true }
    end

    context 'when the taggable item has no id' do
      let(:taggable_item) { TaggableItem.new }

      subject { taggable_item.add_tag 'A Test Tag' }

      it { subject.should be_nil }
    end
  end

  describe '#remove_tag' do

    subject { taggable_item.remove_tag 'A Test Tag' }

    context 'when the taggable item has an id' do
      let(:taggable_item) { TaggableItem.new(id: 1) }

      before do
        loc = 'https://sample.capsulecrm.com/api/party/1000/tag/A%20Test%20Tag'
        stub_request(:delete, /\/api\/taggableitem\/1\/A%20Test%20Tag$/).
          to_return(headers: { 'Location' => loc })
      end

      it { subject.should be_true }
    end

    context 'when the taggable item has no id' do
      let(:taggable_item) { TaggableItem.new }

      subject { taggable_item.remove_tag 'A Test Tag' }

      it { subject.should be_nil }
    end
  end
end
