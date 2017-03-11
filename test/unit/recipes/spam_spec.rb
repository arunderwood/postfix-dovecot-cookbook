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

describe 'postfix-dovecot::spam' do
  let(:chef_runner) { ChefSpec::SoloRunner.new }
  let(:chef_run) { chef_runner.converge(described_recipe) }
  before do
    stub_command('grep -e " --daemonize\\| -d" /etc/sysconfig/spamassassin')
      .and_return(false)
  end

  it 'does not include onddo-spamassassin recipe by default' do
    expect(chef_run).to_not include_recipe('onddo-spamassassin')
  end

  context 'with spamc enabled' do
    before do
      chef_runner.node.set['postfix-dovecot']['spamc']['enabled'] = true
    end

    it 'includes onddo-spamassassin recipe by default' do
      expect(chef_run).to include_recipe('onddo-spamassassin')
    end
  end
end
