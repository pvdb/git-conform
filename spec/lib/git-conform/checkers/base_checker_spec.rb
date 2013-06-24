require 'spec_helper'

describe Git::Conform::BaseChecker do

  include Aruba::Api

  describe "#initialize" do

    context "with a filename" do
      before { write_file("blegga.rb", "") }
      let(:path) { File.join(current_dir, "blegga.rb") }
      subject { described_class.new(path) }
      its(:filename) { should eq path }
    end

    context "with a path" do
      before { write_file("foo/bar/blegga.rb", "") }
      let(:path) { File.join(current_dir, "foo/bar/blegga.rb") }
      subject { described_class.new(path) }
      its(:filename) { should eq path }
    end

    context "file/directory doesn't exist" do
      let(:filename) { "non-existent" }
      let(:path) { File.join(current_dir, filename) }

      # file/directory doesn't exist
      before { raise if File.exists? path }

      it "raises a RuntimeError" do
        expect {
          described_class.new(path)
        }.to raise_error(RuntimeError, "No such file or directory - #{path}")
      end
    end

    context "directory exists" do
      let(:dirname) { "subdir" }
      let(:path) { File.join(current_dir, dirname) }

      # directory exists
      before { create_dir(dirname) }

      it "raises a RuntimeError" do
        expect {
          described_class.new(path)
        }.to raise_error(RuntimeError, "Is a directory - #{path}")
      end
    end

    context "file exists" do
      let(:filename) { "existent.rb" }
      let(:path) { File.join(current_dir, filename) }

      # file exists
      before { write_file(filename, "") }

      it "doesn't raise a RuntimeError" do
        expect {
          described_class.new(path)
        }.to_not raise_error(RuntimeError)
      end
    end

  end

  describe "#conforms?" do

    before { write_file("blegga.rb", "") }
    let(:path) { File.join(current_dir, "blegga.rb") }

    subject { described_class.new(path) }

    it "raises a RuntimeError" do
      expect {
        subject.conforms?
      }.to raise_error(RuntimeError, "SubclassResponsibility")
    end

  end

  describe "#excluded?" do

    before { write_file("blegga.rb", "") }
    let(:path) { File.join(current_dir, "blegga.rb") }

    subject { described_class.new(path) }

    it "raises a RuntimeError" do
      expect {
        subject.excluded?
      }.to raise_error(RuntimeError, "SubclassResponsibility")
    end

  end

  describe "#check_exclusion" do

    before { write_file("blegga.rb", "") }
    let(:path) { File.join(current_dir, "blegga.rb") }

    subject { described_class.new(path) }

    it "doesn't yield the block if the file isn't excluded" do
      subject.stub(:excluded?).and_return(false)
      expect { |block|
        subject.check_exclusion &block
      }.not_to yield_control
    end

    it "yields with the filename if the file is excluded" do
      subject.stub(:excluded?).and_return(true)
      expect { |block|
        subject.check_exclusion &block
      }.to yield_with_args(path)
    end

  end

  describe "#check_conformity" do

    before { write_file("blegga.rb", "") }
    let(:path) { File.join(current_dir, "blegga.rb") }

    subject { described_class.new(path) }

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
      }.to yield_with_args(path)
    end

  end

end
