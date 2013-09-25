require 'helper'

describe TheCity::Base do
  before do
    @base = TheCity::Base.new(:name => "Jim")
  end

  describe "#[]" do
    it "calls methods using [] with symbol" do
      expect(@base[:attrs]).to be_an Hash
    end
    it "calls methods using [] with string" do
      expect(@base["attrs"]).to be_an Hash
    end
    it "returns nil for missing method" do
      expect(@base[:foo]).to be_nil
      expect(@base["foo"]).to be_nil
    end
  end

  describe "#attrs" do
    it "returns a hash of attributes" do
      expect(@base.attrs).to eq({:name => "Jim"})
    end
  end

  describe "#delete" do
    it "deletes an attribute and returns its value" do
      base = TheCity::Base.new(:id => 1)
      expect(base.delete(:id)).to eq(1)
      expect(base.attrs[:id]).to be_nil
    end
  end

  describe "#update" do
    it "returns a hash of attributes" do
      base = TheCity::Base.new(:id => 1)
      base.update(:id => 2)
      expect(base.attrs[:id]).to eq(2)
    end
  end

end
