require 'spec_helper'

describe Git::Conform::FileChecker do

  include Aruba::Api

  it "subclasses Git::Conform::BaseChecker" do
    described_class.superclass.should be Git::Conform::BaseChecker
  end

  describe "#conforms?" do

    context "file/directory doesn't exist" do
      let(:filename) { "non-existent" }
      let(:path) { File.join(current_dir, filename) }
      subject { described_class.new(path) }

      # file/directory doesn't exist
      before { raise if File.exists? path }

      it "raises a RuntimeError" do
        expect {
          subject.conforms?
        }.to raise_error(RuntimeError, "No such file or directory - #{path}")
      end
    end

    context "directory exists" do
      let(:dirname) { "subdir" }
      let(:path) { File.join(current_dir, dirname) }
      subject { described_class.new(path) }

      # directory exists
      before { create_dir(dirname) }

      it "raises a RuntimeError" do
        expect {
          subject.conforms?
        }.to raise_error(RuntimeError, "Is a directory - #{path}")
      end
    end

    context "file exists" do
      let(:filename) { "existent.rb" }
      let(:path) { File.join(current_dir, filename) }
      subject { described_class.new(path) }

      # file exists
      before { write_file(filename, "") }

      it "doesn't raise a RuntimeError" do
        expect {
          subject.conforms?.to be_true
        }.to_not raise_error(RuntimeError)
      end
    end

  end

  describe ".available_checkers" do

    #
    # these specs are "polluting" Ruby's ObjectSpace - especially
    # the @@available_checkers collection in file_checker.rb - by
    # permanently adding test-only classes... this is not causing
    # issues (yet) but should try to avoid (RSpec magic?!?)
    #

    it "should include its subclasses" do
      # given
      superclass_name = described_class.name
      subclass_name = "Git::Conform::SubclassOfFileChecker"

      # and
      described_class.available_checkers.should_not include("SubclassOfFileChecker")

      # when
      eval "class #{subclass_name} < #{superclass_name} ; end"

      # then
      described_class.available_checkers.should include("SubclassOfFileChecker")
    end

    it "should include child and grandchild subclasses" do
      # given
      superclass_name = described_class.name
      child_subclass_name = "Git::Conform::ChildSubclassOfFileChecker"
      grandchild_subclass_name = "Git::Conform::GrandchildSubclassOfFileChecker"

      # and
      described_class.available_checkers.should_not include("ChildSubclassOfFileChecker")
      described_class.available_checkers.should_not include("GrandchildSubclassOfFileChecker")

      # when
      eval "class #{child_subclass_name} < #{superclass_name} ; end"
      eval "class #{grandchild_subclass_name} < #{child_subclass_name} ; end"

      # then
      described_class.available_checkers.should include("ChildSubclassOfFileChecker")
      described_class.available_checkers.should include("GrandchildSubclassOfFileChecker")
    end

    it "should not include other classes in the hierarchy" do
      # given
      superclass_name = described_class.superclass.name
      subclass_name = "Git::Conform::SubclassOfBaseChecker"

      # and
      described_class.available_checkers.should_not include("SubclassOfBaseChecker")

      # when
      eval "class #{subclass_name} < #{superclass_name} ; end"

      # then
      described_class.available_checkers.should_not include("SubclassOfBaseChecker")
    end

  end

end
