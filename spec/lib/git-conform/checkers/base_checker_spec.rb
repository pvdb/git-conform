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

  describe "#excluded?" do

    subject { described_class.new("blegga.rb") }

    it "raises a RuntimeError" do
      expect {
        subject.excluded?
      }.to raise_error(RuntimeError, "SubclassResponsibility")
    end

  end

  describe "#check_conformity" do

    subject { described_class.new("blegga.rb") }

    it "doesn't yield the block if the file is excluded" do
      subject.stub(:excluded?).and_return(true)
      subject.should_not_receive(:conforms?)
      expect { |block|
        subject.check_conformity &block
      }.not_to yield_control
    end

    it "doesn't yield the block if the file isn't excluded but conforms" do
      subject.stub(:excluded?).and_return(false)
      subject.stub(:conforms?).and_return(true)
      expect { |block|
        subject.check_conformity &block
      }.not_to yield_control
    end

    it "yields with the filename if the file isn't excluded and doesn't conform" do
      subject.stub(:excluded?).and_return(false)
      subject.stub(:conforms?).and_return(false)
      expect { |block|
        subject.check_conformity &block
      }.to yield_with_args("blegga.rb")
    end

  end

end
