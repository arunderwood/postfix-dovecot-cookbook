# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2014-2015 Onddo Labs, SL.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_relative '../spec_helper'

describe 'postfix-dovecot::dovecot' do
  let(:chef_runner) { ChefSpec::SoloRunner.new }
  let(:chef_run) { chef_runner.converge(described_recipe) }
  before do
    allow(::File).to receive(:exist?).and_call_original
    expect(::File).to receive(:exist?).with('/etc/dovecot/sieve')
      .and_return(false)
  end

  it 'generates SMTP SSL certificate' do
    expect(chef_run).to create_ssl_certificate('dovecot2')
  end

  it 'includes dovecot recipe' do
    expect(chef_run).to include_recipe('dovecot')
  end

  it 'creates sievec resource' do
    resource = chef_run.execute('sievec sieve_global_path')
    expect(resource).to do_nothing
  end

  it 'creates sieve_global_dir directory' do
    expect(chef_run).to create_directory('/etc/dovecot/sieve')
      .with_owner('root')
      .with_group('root')
      .with_mode('00755')
      .with_recursive(true)
  end

  it 'creates sieve_global_path file' do
    expect(chef_run).to create_template('/etc/dovecot/sieve/default.sieve')
      .with_owner('root')
      .with_group('root')
      .with_mode('00644')
  end

  it 'sieve_global_path file notifies sievec' do
    resource = chef_run.template('/etc/dovecot/sieve/default.sieve')
    expect(resource).to notify('execute[sievec sieve_global_path]')
      .to(:run).delayed
  end
end
