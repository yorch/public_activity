require 'test_helper'

describe PublicActivity::Deactivatable do
  def disable; PublicActivity.enabled = false; end
  def enable; PublicActivity.enabled  = true; end
  before(:each) { enable }
  after(:all) { enable }

  describe 'functionality of the gem' do
    describe 'class-wide' do 
      it 'is enabled by default'
      it 'can be disabled'
      it 'can be turned back on'
    end

    # This technically isn't Deactivatable's job, but these tests
    # are more meaningful here
    describe 'project-wide' do
      specify('is enabled by default') { PublicActivity.enabled?.must_equal true }

      it 'can be disabled' do
        disable
        article.new.save
        PublicActivity::Activity.count.must_equal 0 # db must be purged
      end

      it 'can be turned back on' do
        disable
        article.new.save
        PublicActivity::Activity.count.must_equal 0
        enable
        article.new.save
        PublicActivity::Activity.count.must_equal 1
      end
    end
  end
end
