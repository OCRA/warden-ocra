require 'spec_helper'

describe Warden::Ocra do
  context "#configure" do
    context "should override default value" do
      context "all strategies" do
        it "user_class" do
          Warden::Ocra.config.user_class = 'Profile'

          user = User.new
          user.stub(:shared_secret).and_return('0000')
          user.stub(:challenge).and_return('1111')
          User.stub(:has_challenge?)

          Profile.should_receive(:find_by_email!).and_return(user)
          User.should_not_receive(:find_by_email!)

          strategy = strategy_instance('OcraVerify')
          strategy.authenticate!
          strategy.valid?

          Warden::Ocra.config.user_class = 'User'
        end
      end

      context "OcraChallenge" do
        it "generate_challenge_method" do
          Warden::Ocra.config.generate_challenge_method = 'create_challenge'

          User.should_receive(:has_challenge?)
          User.should_receive(:create_challenge)
          User.should_not_receive(:generate_challenge!)

          strategy = strategy_instance('OcraChallenge')
          strategy.authenticate!
          strategy.valid?

          Warden::Ocra.config.generate_challenge_method = 'generate_challenge!'
        end

        it "has_challenge_method" do
          Warden::Ocra.config.has_challenge_method = 'challenge_exists?'

          User.should_receive(:challenge_exists?)
          User.should_receive(:generate_challenge!)

          strategy = strategy_instance('OcraChallenge')
          strategy.authenticate!
          strategy.valid?

          Warden::Ocra.config.has_challenge_method = 'has_challenge?'
        end
      end

      context "OcraVerify" do
        it "user_finder_method" do
          Warden::Ocra.config.user_finder_method = 'find_by_username'

          user = User.new
          user.stub(:shared_secret).and_return('0000')
          user.stub(:challenge).and_return('1111')
          User.stub(:has_challenge?)

          User.should_receive(:find_by_username).and_return(user)
          User.should_not_receive(:find_by_email!)

          strategy = strategy_instance('OcraVerify')
          strategy.authenticate!
          strategy.valid?

          Warden::Ocra.config.user_finder_method = 'find_by_email!'
        end

        it "user_shared_secret_method" do
          Warden::Ocra.config.user_shared_secret_method = 'secret'

          user = User.new
          user.stub(:challenge).and_return('1111')
          User.stub(:has_challenge?)
          User.stub(:find_by_email!).and_return(user)

          user.should_receive(:secret).and_return('0000')
          user.should_not_receive(:shared_secret)

          strategy = strategy_instance('OcraVerify')
          strategy.authenticate!
          strategy.valid?

          Warden::Ocra.config.user_shared_secret_method = 'shared_secret'
        end

        it "user_challenge_method" do
          Warden::Ocra.config.user_challenge_method = 'question'

          user = User.new
          user.stub(:shared_secret).and_return('0000')
          User.stub(:find_by_email!).and_return(user)
          User.stub(:has_challenge?)

          user.should_receive(:question).and_return('1111')
          user.should_not_receive(:challenge)

          strategy = strategy_instance('OcraVerify')
          strategy.authenticate!
          strategy.valid?

          Warden::Ocra.config.user_challenge_method = 'challenge'
        end
      end
    end
  end

  context "valid user" do
    before(:each) do
      post '/generate_challenge', :email => 'bla@blub.com'
    end

    context "first step" do
      it "should generate the challenge" do
        warden.user.challenge.should_not be_nil
      end

      it "should not authenticate user" do
        warden.should_not be_authenticated
      end
    end

    context "second step" do
      context "valid response" do
        before(:each) do
          post '/login', :email => 'bla@blub.com', :response => '239172'
        end

        it "should authenticate the user" do
          warden.should be_authenticated
        end

        context "invalid response" do
          before(:each) do
            post '/login', :email => 'bla@blub.com', :response => 'blablub'
          end

          it "should not authenticate the user" do
            warden.should_not be_authenticated
          end
        end
      end
    end
  end

  context "invalid user" do
    before(:each) do
      post '/generate_challenge', :email => 'invalid@blub.com'
    end

    context "first step" do
      it "should not generate the challenge" do
        warden.user.should be_nil
      end

      it "should not authenticate user" do
        warden.should_not be_authenticated
      end
    end
  end
end
