require 'test_helper'

describe PublicActivity::Common do
  describe 'creating activities' do
    describe 'from global tier of variables' do
      describe 'key' do
        it 'allows pure value'
        it 'resolves symbol value'
        it 'resolves proc value'
      end
      describe 'owner' do
        it 'allows pure value'
        it 'resolves symbol value'
        it 'resolves proc value'
      end
      describe 'recipient' do
        it 'allows pure value'
        it 'resolves symbol value'
        it 'resolves proc value'
      end
      describe 'params' do
        it 'allows pure value'
        it 'resolves symbol value'
        it 'resolves proc value'
      end
      describe 'parameters' do
        it 'allows pure value'
        it 'resolves symbol value'
        it 'resolves proc value'
      end
      describe 'custom fields' do
        it 'allows pure value'
        it 'resolves symbol value'
        it 'resolves proc value'
      end
    end

    describe 'from instance tier of variables' do
      describe 'key' do
        it 'allows pure value'
        it 'resolves symbol value'
        it 'resolves proc value'
      end
      describe 'owner' do
        it 'allows pure value'
        it 'resolves symbol value'
        it 'resolves proc value'
      end
      describe 'recipient' do
        it 'allows pure value'
        it 'resolves symbol value'
        it 'resolves proc value'
      end
      describe 'params' do
        it 'allows pure value'
        it 'resolves symbol value'
        it 'resolves proc value'
      end
      describe 'parameters' do
        it 'allows pure value'
        it 'resolves symbol value'
        it 'resolves proc value'
      end
      describe 'custom fields' do
        it 'allows pure value'
        it 'resolves symbol value'
        it 'resolves proc value'
      end
    end

    describe 'from immediate tier of variables' do
      describe 'key' do
        it 'allows pure value'
        it 'resolves symbol value'
        it 'resolves proc value'
      end
      describe 'owner' do
        it 'allows pure value'
        it 'resolves symbol value'
        it 'resolves proc value'
      end
      describe 'recipient' do
        it 'allows pure value'
        it 'resolves symbol value'
        it 'resolves proc value'
      end
      describe 'params' do
        it 'allows pure value'
        it 'resolves symbol value'
        it 'resolves proc value'
      end
      describe 'parameters' do
        it 'allows pure value'
        it 'resolves symbol value'
        it 'resolves proc value'
      end
      describe 'custom fields' do
        it 'allows pure value'
        it 'resolves symbol value'
        it 'resolves proc value'
      end
    end

    it 'should reset instance options'
  end

  describe 'deciding creation of an activity' do
    describe 'basic hooks implementation' do
      it 'retrieves hooks'
      it 'retrieves hooks by anything castable to symbol'
      it 'returns explicit nil when no hook is present'
    end

    it 'respects simple hooks'
    it 'respects multiple hooks'
    it 'respects hooks where at least one is failing'
  end

  before do
    @owner     = User.create(:name => "Peter Pan")
    @recipient = User.create(:name => "Bruce Wayne")
    @options   = {:params => {:author_name => "Peter",
                  :summary => "Default summary goes here..."},
                  :owner => @owner}
  end
  subject { article(@options).new }

  describe '#extract_key' do
    describe 'for class#activity_key method' do
      before do
        @article = article(:owner => :user).new(:user => @owner)
      end

      it 'assigns key to value of activity_key if set' do
        def @article.activity_key; "my_custom_key" end

        @article.extract_key(:create, {}).must_equal "my_custom_key"
      end

      it 'assigns key based on class name as fallback' do
        def @article.activity_key; nil end

        @article.extract_key(:create).must_equal "article.create"
      end

      it 'assigns key value from options hash' do
        @article.extract_key(:create, :key => :my_custom_key).must_equal "my_custom_key"
      end
    end

    describe 'for camel cased classes' do
      before do
        class CamelCase < article(:owner => :user)
          def self.name; 'CamelCase' end
        end
        @camel_case = CamelCase.new
      end

      it 'assigns generates key from class name' do
        @camel_case.extract_key(:create, {}).must_equal "camel_case.create"
      end
    end

    describe 'for namespaced classes' do
      before do
        module ::MyNamespace;
          class CamelCase < article(:owner => :user)
            def self.name; 'MyNamespace::CamelCase' end
          end
        end
        @namespaced_camel_case = MyNamespace::CamelCase.new
      end

      it 'assigns key value from options hash' do
        @namespaced_camel_case.extract_key(:create, {}).must_equal "my_namespace_camel_case.create"
      end
    end
  end

  # no key implicated or given
  specify { ->{subject.prepare_settings}.must_raise PublicActivity::NoKeyProvided }

  describe '#resolve_value' do
    let(:context) do
      # goal is to trigger getter on model eveyr time
      mock('context').tap {|m| m.expects(:getter).once.returns(:value)}
    end
    
    let(:controller) do
      mock('controler')
    end

    it 'works on procs providing models and controllers' do
      controller.expects(:current_user).returns(:cu)
      PublicActivity.set_controller(controller)
      p = proc {|controller, model|
        controller.current_user.must_equal :cu
        model.getter.must_equal :value
      }
      PublicActivity.resolve_value(context, p)
    end

    it 'works on symbols' do
      PublicActivity.resolve_value(context, :getter)
    end
  end

end
