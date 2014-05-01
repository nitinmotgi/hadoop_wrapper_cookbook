require 'spec_helper'

describe 'hadoop_wrapper::hbase_master_init' do
  context 'on Centos 6.4 x86_64' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'centos', version: 6.4) do |node|
        node.automatic['domain'] = 'example.com'
        node.automatic['memory']['total'] = '4099400kB'
        node.default['hbase']['hbase_site']['hbase.rootdir'] = 'hdfs://fauxhai.local/hbase'
        node.default['hbase']['hbase_site']['hbase.zookeeper.quorum'] = 'fauxhai.local'
        stub_command('update-alternatives --display hadoop-conf | grep best | awk \'{print $5}\' | grep /etc/hadoop/conf.chef').and_return(false)
        stub_command('update-alternatives --display hbase-conf | grep best | awk \'{print $5}\' | grep /etc/hbase/conf.chef').and_return(false)
      end.converge(described_recipe)
    end

    it 'does nothing yet' do
      expect(chef_run).to do_nothing
    end
  end
end
