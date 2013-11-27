require_relative '../spec_helper'

describe 'ssh_userkey::default' do
  let(:home) { nil }
  let(:chef_run) do
    ChefSpec::Runner.new(step_into: ['ssh_userkey']) {|node|
      node.set['ssh_userkey']['user'] = 'alice'
      node.set['ssh_userkey']['home'] = home if home
    }.converge('ssh_userkey::default')
  end

  it 'creates .ssh directory' do
    expect(chef_run).to create_directory("/home/alice/.ssh")
  end

  it 'executes ssh-keygen' do
    expect(chef_run).to run_execute('generate-ssh-key-for-alice').with(user: 'alice')
  end

  it 'prints public key' do
    resource = chef_run.execute('generate-ssh-key-for-alice')
    expect(resource).to notify('ruby_block[print-public-key]').to(:run)
  end

  context 'home attribute configured' do
    let(:home) { "/Users/alice" }

    it 'creates .ssh directory' do
      expect(chef_run).to create_directory("/Users/alice/.ssh")
    end

    it 'executes ssh-keygen with creates attribute' do
      expect(chef_run).to run_execute('generate-ssh-key-for-alice').with(creates: "/Users/alice/.ssh/id_rsa.pub")
    end
  end

  context 'if no attribute about ssh_userkey' do
    let(:chef_run) do
      ChefSpec::Runner.new(step_into: ['ssh_userkey']).converge('ssh_userkey::default')
    end


    it 'does not create .ssh directory' do
      expect(chef_run).to_not create_directory("/Users/alice/.ssh")
    end

    it 'does not execute ssh-keygen' do
      expect(chef_run).to_not run_execute('generate-ssh-key-for-alice')
    end
  end


end

