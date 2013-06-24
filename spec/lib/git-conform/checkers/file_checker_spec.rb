require 'spec_helper'

describe Git::Conform::FileChecker do

  include Aruba::Api

  it "subclasses Git::Conform::BaseChecker" do
    described_class.superclass.should be Git::Conform::BaseChecker
  end

  describe ".file_exclusion_patterns" do

    specify { expect(described_class).to respond_to :file_exclusion_patterns }

    it "doesn't exclude any files by default" do
      expect(described_class.file_exclusion_patterns).to eq []
    end

  end

  describe "@file_exclusion_patterns" do

    after(:each) {
      described_class.instance_variable_set(:@file_exclusion_patterns, [])
    }

    it "is used to store the file exclusion patterns" do
      # given
      patterns = [:foo, :bar]
      # when
      described_class.instance_variable_set(:@file_exclusion_patterns, patterns)
      # then
      expect(described_class.file_exclusion_patterns).to be patterns
    end

    it "is used as the default value for subclass file exclusion patterns" do
      # given
      patterns = [:foo, :bar]
      described_class.instance_variable_set(:@file_exclusion_patterns, patterns)
      # when
      subclass = Class.new(described_class) ; Git::Conform.const_set('FirstRandomFileChecker', subclass)
      # then
      expect(subclass.file_exclusion_patterns).to_not be patterns
      expect(subclass.file_exclusion_patterns).to match_array patterns
    end

    it "isn't changed when subclasses add additional file exclusion patterns" do
      # given
      patterns = [:foo, :bar]
      described_class.instance_variable_set(:@file_exclusion_patterns, patterns)
      # when
      subclass = Class.new(described_class) ; Git::Conform.const_set('SecondRandomFileChecker', subclass)
      subclass.class_eval "@file_exclusion_patterns << :blegga"
      # then
      expect(described_class.file_exclusion_patterns).to match_array [:foo, :bar]
      expect(subclass.file_exclusion_patterns).to match_array [:foo, :bar, :blegga]
    end

  end

  describe ".excluded?" do

    specify { expect(described_class).to respond_to :excluded? }

    it "returns false without any file exclusion patterns" do
      # given
      described_class.should_receive(:file_exclusion_patterns) { [] }
      # when/then
      expect(described_class.excluded? "foo_bar.txt").to be_false
    end

    it "returns false when filename doesn't match any file exclusion patterns" do
      # given
      described_class.should_receive(:file_exclusion_patterns) { ['*.png', '*.jpg', '*.gif'] }
      # when/then
      expect(described_class.excluded? "foo_bar.txt").to be_false
    end

    it "returns true when filename matches any file exclusion patterns glob-wise" do
      # given
      described_class.should_receive(:file_exclusion_patterns) { ['*.txt', '*.rb'] }
      # when/then
      expect(described_class.excluded? "foo_bar.txt").to be_true
    end

    it "returns true when filename matches any file exclusion patterns exactly" do
      # given
      described_class.should_receive(:file_exclusion_patterns) { ['foo_bar.txt', '*.rb'] }
      # when/then
      expect(described_class.excluded? "foo_bar.txt").to be_true
    end

  end

  describe "#excluded?" do

    let(:filename) { "foo_bar.txt" }
    before { write_file(filename, "") }
    let(:path) { File.join(current_dir, filename) }

    subject { described_class.new(path) }

    specify { expect(subject).to respond_to :excluded? }

    it "returns true if the class excludes the filename" do
      # given
      described_class.should_receive(:excluded?).with(path) { true }
      # when/then
      expect(subject.excluded?).to be_true
    end

    it "returns false if the class doesn't exclude the filename" do
      # given
      described_class.should_receive(:excluded?).with(path) { false }
      # when/then
      expect(subject.excluded?).to be_false
    end

  end

  describe "#conforms?" do

    let(:filename) { "foo_bar.txt" }
    before { write_file(filename, "") }
    let(:path) { File.join(current_dir, filename) }

    subject { described_class.new(path) }

    specify { expect(subject).to respond_to :conforms? }

    it "returns true unconditionally" do
      expect(subject.conforms?).to be_true
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
