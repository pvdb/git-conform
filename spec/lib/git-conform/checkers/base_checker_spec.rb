require 'spec_helper'

describe Git::Conform::BaseChecker do

  describe "#initialize" do

    context "with a filename" do
      subject { described_class.new("blegga.rb") }
      its(:filename) { should eq "blegga.rb" }
    end

    context "with a path" do
      subject { described_class.new("foo/bar/blegga.rb") }
      its(:filename) { should eq "foo/bar/blegga.rb" }
    end

  end

  describe "#conforms?" do

    subject { described_class.new("blegga.rb") }

    it "raises a RuntimeError" do
      expect {
        subject.conforms?
      }.to raise_error(RuntimeError, "SubclassResponsibility")
    end

  end

  describe "#check_conformity" do

    subject { described_class.new("blegga.rb") }

    it "yields with the filename if the file doesn't conform" do
      subject.stub(:conforms?).and_return(false)
      expect { |block|
        subject.check_conformity &block
      }.to yield_with_args("blegga.rb")
    end

    it "doesn't yield the block if the file conforms" do
      subject.stub(:conforms?).and_return(true)
      expect { |block|
        subject.check_conformity &block
      }.not_to yield_control
    end

  end

end