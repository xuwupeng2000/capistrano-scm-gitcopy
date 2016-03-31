require 'spec_helper'

require 'capistrano/gitcopy'

module Capistrano
  describe GitCopy do
    let(:context) { Class.new.new }
    subject { Capistrano::GitCopy.new(context, Capistrano::GitCopy::DefaultStrategy) }

    describe "#git" do
      it "should call execute git in the context, with arguments" do
        context.expects(:execute).with(:git, :init)
        subject.git(:init)
      end
    end
  end

  describe GitCopy::DefaultStrategy do
    let(:context) { Class.new.new }
    subject { Capistrano::GitCopy.new(context, Capistrano::GitCopy::DefaultStrategy) }

    describe "#check" do
      it "should test the repo url" do
        context.expects(:repo_url).returns(:url)
        context.expects(:execute).with(:git, :'ls-remote --heads', :url).returns(true)

        subject.check
      end
    end

    describe "#clone" do
      it "should run git clone" do
        context.expects(:fetch).with(:git_shallow_clone).returns(nil)
        context.expects(:fetch).with(:local_path).returns(:local_path)
        context.expects(:repo_url).returns(:url)
        context.expects(:execute).with(:git, :clone, '--verbose', '--mirror', :url, :local_path)

        subject.clone
      end

      it "should run git clone in shallow mode" do
        context.expects(:fetch).with(:git_shallow_clone).returns('1')
        context.expects(:fetch).with(:local_path).returns(:local_path)
        context.expects(:repo_url).returns(:url)

        context.expects(:execute).with(:git, :clone, '--verbose', '--mirror', "--depth", '1', '--no-single-branch', :url, :local_path)

        subject.clone
      end
    end

    describe "#update" do
      it "should run git update" do
        context.expects(:fetch).with(:git_shallow_clone).returns(nil)
        context.expects(:execute).with(:git, :remote, :update)

        subject.update
      end

      it "should run git update in shallow mode" do
        context.expects(:fetch).with(:git_shallow_clone).returns('1')
        context.expects(:fetch).with(:branch).returns(:branch)
        context.expects(:execute).with(:git, :fetch, "--depth", '1', "origin",  :branch)

        subject.update
      end
    end

    describe "#release" do
      it "should run git archive without a subtree" do
        context.expects(:fetch).with(:repo_tree).returns(nil)
        context.expects(:fetch).with(:branch).returns(:branch)
        context.expects(:fetch).with(:tmp_dir).returns('/tmp')
        context.expects(:fetch).with(:application).returns('rspec-test')
        context.expects(:fetch).with(:current_revision).returns('ABCDEF')

        context.expects(:execute).with(:git, :archive, :branch, '--format', 'tar', "|gzip > /tmp/rspec-test-ABCDEF.tar.gz")

        subject.release
      end

      it "should run git archive with a subtree" do
        context.expects(:fetch).with(:repo_tree).returns('tree')
        context.expects(:fetch).with(:branch).returns(:branch)
        context.expects(:fetch).with(:tmp_dir).returns('/tmp')
        context.expects(:fetch).with(:application).returns('rspec-test')
        context.expects(:fetch).with(:current_revision).returns('ABCDEF')

        context.expects(:execute).with(:git, :archive, :branch, 'tree', '--format', 'tar', "|gzip > /tmp/rspec-test-ABCDEF.tar.gz")

        subject.release
      end
    end

    describe "#fetch_revision" do
      it "should capture git rev-list" do
        context.expects(:fetch).with(:branch).returns(:branch)
        context.expects(:capture).with(:git, "rev-list --max-count=1 --abbrev-commit --abbrev=12 branch").returns("01abcde")
        revision = subject.fetch_revision
        expect(revision).to eq("01abcde")
      end
    end
  end
end
