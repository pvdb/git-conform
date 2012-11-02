require 'spec_helper'

describe Git::Conform::Repo do

  it "subclasses Rugged::Repository" do
    described_class.superclass.should be Rugged::Repository
  end

end