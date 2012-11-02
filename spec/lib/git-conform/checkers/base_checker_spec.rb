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

end