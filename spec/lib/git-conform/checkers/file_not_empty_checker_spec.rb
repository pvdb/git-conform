require 'spec_helper'

describe Git::Conform::FileNotEmptyChecker do

  it "excludes '.gitkeep' by default" do
    expect(described_class.file_exclusion_patterns).to include '*/.gitkeep'
  end

end
