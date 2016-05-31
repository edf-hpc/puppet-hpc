#!/usr/bin/env rspec

require 'spec_helper'

provider_class = Puppet::Type.type(:pam).provider(:augeas)

describe provider_class do
  before :each do
    FileTest.stubs(:exist?).returns false
  end

  context "with empty file" do
    let(:tmptarget) { aug_fixture("empty") }
    let(:target) { tmptarget.path }

    it "should create simple new entry" do
      apply!(Puppet::Type.type(:pam).new(
        :title       => "Add pam_test.so to auth for system-auth",
        :service     => "system-auth",
        :type        => "auth",
        :control     => "sufficient",
        :module      => "pam_test.so",
        :arguments   => "test_me_out",
        :position    => "before module pam_deny.so",
        :target      => target,
        :provider    => "augeas",
        :ensure      => "present"
      ))

      aug_open(target, "Pam.lns") do |aug|
        expect(aug.get("./1/module")).to eq("pam_test.so")
        expect(aug.get("./1/argument[1]")).to eq("test_me_out")
      end
    end

    it "should create simple new entry without arguments" do
      apply!(Puppet::Type.type(:pam).new(
        :title       => "Add pam_test.so to auth for system-auth",
        :service     => "system-auth",
        :type        => "auth",
        :control     => "sufficient",
        :module      => "pam_test.so",
        :target      => target,
        :provider    => "augeas",
        :ensure      => "present"
      ))

      aug_open(target, "Pam.lns") do |aug|
        expect(aug.get("./1/module")).to eq("pam_test.so")
        expect(aug.match("./1/argument").size).to eq(0)
      end
    end

    it "should create two new entries" do
      apply!(Puppet::Type.type(:pam).new(
        :title       => "Add pam_test.so to auth for system-auth",
        :service     => "system-auth",
        :type        => "auth",
        :control     => "sufficient",
        :module      => "pam_test.so",
        :arguments   => "test_me_out",
        :target      => target,
        :provider    => "augeas",
        :ensure      => "present"
      ))
      apply!(Puppet::Type.type(:pam).new(
        :title       => "Add pam_test.so to auth for system-auth",
        :service     => "system-auth",
        :type        => "auth",
        :control     => "required",
        :module      => "pam_unix.so",
        :arguments   => "broken_shadow",
        :target      => target,
        :provider    => "augeas",
        :ensure      => "present"
      ))

      aug_open(target, "Pam.lns") do |aug|
        expect(aug.match("*[type='auth']").size).to eq(2)
      end
    end
  end

  context "with full file" do
    let(:tmptarget) { aug_fixture("full") }
    let(:target) { tmptarget.path }

    it "should list instances" do
      provider_class.stubs(:target).returns(target)
      inst = provider_class.instances.map { |p|
        {
          :ensure    => p.get(:ensure),
          :service   => p.get(:service),
          :type      => p.get(:type),
          :control   => p.get(:control),
          :module    => p.get(:module),
          :arguments => p.get(:arguments),
        }
      }

      expect(inst.size).to eq(21)
      expect(inst[0]).to eq({:ensure     => :present,
                         :service    => :absent,
                         :type       => "auth",
                         :control    => "required",
                         :module     => "pam_env.so",
                         :arguments  => [],})
      expect(inst[1]).to eq({:ensure     => :present,
                         :service    => :absent,
                         :type       => "auth",
                         :control    => "sufficient",
                         :module     => "pam_unix.so",
                         :arguments  => ["nullok","try_first_pass"],})
      expect(inst[5]).to eq({:ensure     => :present,
                         :service    => :absent,
                         :type       => "account",
                         :control    => "required",
                         :module     => "pam_unix.so",
                         :arguments  => ["broken_shadow"],})
      expect(inst[8]).to eq({:ensure     => :present,
                         :service    => :absent,
                         :type       => "account",
                         :control    => "[default=bad success=ok user_unknown=ignore]",
                         :module     => "pam_sss.so",
                         :arguments  => [],})
      expect(inst[10]).to eq({:ensure    => :present,
                          :service    => :absent,
                          :type      => "password",
                          :control   => "requisite",
                          :module    => "pam_pwquality.so",
                          :arguments => ["try_first_pass","retry=3","type="],})
    end

    describe "when reodering settings" do
      it "should change the order of an entry" do
        apply!(Puppet::Type.type(:pam).new(
          :title       => "Change the order of pam_unix.so",
          :service     => "system-auth",
          :type        => "auth",
          :control     => "sufficient",
          :module      => "pam_unix.so",
          :arguments   => ["nullok","try_first_pass"],
          :target      => target,
          :provider    => "augeas",
          :position    => "before module pam_env.so",
          :ensure      => "positioned"
        ))

        aug_open(target, "Pam.lns") do |aug|
          expect(aug.get("./1/module")).to eq("pam_unix.so")
        end
      end
    end

    describe "when creating settings" do
      it "should create simple new entry" do
        apply!(Puppet::Type.type(:pam).new(
          :title       => "Add pam_test.so to auth for system-auth",
          :service     => "system-auth",
          :type        => "auth",
          :control     => "sufficient",
          :module      => "pam_test.so",
          :arguments   => "test_me_out",
          :position    => "before module pam_deny.so",
          :target      => target,
          :provider    => "augeas",
          :ensure      => "present"
        ))

        aug_open(target, "Pam.lns") do |aug|
          expect(aug.get("./5/module")).to eq("pam_test.so")
          expect(aug.get("./5/argument[1]")).to eq("test_me_out")
        end
      end
    end

    describe "when modifying settings" do
      it "Changing the number of retries" do
        apply!(Puppet::Type.type(:pam).new(
          :title       => "Set retry count for pwquality",
          :service     => "system-auth",
          :type        => "password",
          :control     => "requisite",
          :module      => "pam_pwquality.so",
          :arguments   => ["try_first_pass","retry=4","type="],
          :target      => target,
          :provider    => "augeas",
          :ensure      => "present"
        ))

        aug_open(target, "Pam.lns") do |aug|
          expect(aug.match('./*[type="password" and module="pam_pwquality.so" and argument="retry=4"]').size).to eq(1)
        end
      end

      it "should remove the type= argument" do
        apply!(Puppet::Type.type(:pam).new(
          :title       => "Remove type= from pwquality check",
          :service     => "system-auth",
          :type        => "password",
          :control     => "requisite",
          :module      => "pam_pwquality.so",
          :arguments   => ["try_first_pass","retry=4"],
          :target      => target,
          :provider    => "augeas",
          :ensure      => "present"
        ))

        aug_open(target, "Pam.lns") do |aug|
          expect(aug.match('./*[type="password" and module="pam_pwquality.so" and argument="type="]').size).to eq(0)
        end
      end

      it "should change the value of control" do
        apply!(Puppet::Type.type(:pam).new(
          :title       => "Remove type= from pwquality check",
          :service     => "system-auth",
          :type        => "password",
          :control     => "required",
          :arguments   => ["try_first_pass","retry=4"],
          :module      => "pam_pwquality.so",
          :target      => target,
          :provider    => "augeas",
          :ensure      => "present"
        ))

        aug_open(target, "Pam.lns") do |aug|
          expect(aug.get('./*[type="password" and module="pam_pwquality.so"]/control')).to eq("required")
        end
      end

      it "should add a new entry when control_is_param is true" do
        apply!(Puppet::Type.type(:pam).new(
          :title            => "Remove type= from pwquality check",
          :service          => "system-auth",
          :type             => "password",
          :control          => "sufficient",
          :control_is_param => true,
          :arguments        => ["try_first_pass","retry=4"],
          :module           => "pam_pwquality.so",
          :target           => target,
          :provider         => "augeas",
          :ensure           => "present"
        ))

        aug_open(target, "Pam.lns") do |aug|
          expect(aug.match('./*[type="password" and module="pam_pwquality.so"]/control').size).to eq(2)
          expect(aug.get('./*[type="password" and module="pam_pwquality.so"][1]/control')).to eq("requisite")
          expect(aug.get('./*[type="password" and module="pam_pwquality.so"][2]/control')).to eq("sufficient")
        end
      end

      it "should update entry when control_is_param is true" do
        apply!(Puppet::Type.type(:pam).new(
          :title       => "Remove type= from pwquality check",
          :service     => "system-auth",
          :type        => "password",
          :control     => "requisite",
          :control_is_param => true,
          :arguments   => ["try_first_pass","retry=4"],
          :module      => "pam_pwquality.so",
          :target      => target,
          :provider    => "augeas",
          :ensure      => "present"
        ))

        aug_open(target, "Pam.lns") do |aug|
          expect(aug.match('./*[type="password" and module="pam_pwquality.so"]/control').size).to eq(1)
          expect(aug.get('./*[type="password" and module="pam_pwquality.so"]/control')).to eq("requisite")
        end
      end
    end

    describe "when removing settings" do
      it "should remove the entry" do
        apply!(Puppet::Type.type(:pam).new(
          :title       => "Remove pwquality entry",
          :service     => "system-auth",
          :type        => "password",
          :control     => "requisite",
          :module      => "pam_pwquality.so",
          :arguments   => ["try_first_pass","retry=4"],
          :target      => target,
          :provider    => "augeas",
          :ensure      => "absent"
        ))

        aug_open(target, "Pam.lns") do |aug|
          expect(aug.match('./*[type="password" and module="pam_pwquality.so"]').size).to eq(0)
        end
      end
    end
  end

  context "with broken file" do
    let(:tmptarget) { aug_fixture("broken") }
    let(:target) { tmptarget.path }

    it "should fail to load" do
      txn = apply(Puppet::Type.type(:pam).new(
        :title       => "Ensure pwquality is configured",
        :service     => "system-auth",
        :type        => "password",
        :control     => "requisite",
        :module      => "pam_pwquality.so",
        :arguments   => ["try_first_pass","retry=3","type="],
        :target      => target,
        :provider    => "augeas",
        :ensure      => "present"
      ))

      expect(txn.any_failed?).not_to eq(nil)
      expect(@logs.first.level).to eq(:err)
      expect(@logs.first.message.include?(target)).to eq(true)
    end
  end
end
