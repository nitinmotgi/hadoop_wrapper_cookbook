require 'spec_helper'

describe 'hadoop_wrapper::hbase_master_init' do
  context 'on Centos 6.6 x86_64' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.6) do |node|
        node.automatic['domain'] = 'example.com'
        node.automatic['memory']['total'] = '4099400kB'
        node.default['hbase']['hbase_site']['hbase.rootdir'] = 'hdfs://fauxhai.local/hbase'
        node.default['hbase']['hbase_site']['hbase.zookeeper.quorum'] = 'fauxhai.local'
        stub_command(/hdfs dfs -/).and_return(false)
        stub_command(/update-alternatives --display (.+) /).and_return(false)
        stub_command(%r{/sys/kernel/mm/(.*)transparent_hugepage/defrag}).and_return(false)
        stub_command(/test -L /).and_return(false)
      end.converge(described_recipe)
    end

    %w(initaction-create-hbase-hdfs-rootdir initaction-create-hbase-bulkload-stagingdir).each do |name|
      it "run #{name} ruby_block" do
        expect(chef_run).to run_ruby_block(name)
      end
    end
  end
end
