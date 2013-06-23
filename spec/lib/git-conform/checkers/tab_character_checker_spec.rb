require 'spec_helper'

describe Git::Conform::TabCharacterChecker do

  it "excludes '.gitconform' by default" do
    expect(described_class.file_exclusion_patterns).to include '.gitconform'
  end

end
