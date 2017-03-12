# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2014 Onddo Labs, SL.
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

require 'spec_helper'
require 'net/imap'

describe 'Dovecot' do
  describe command('doveconf') do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }
  end

  describe process('dovecot') do
    it { should be_running }
  end

  # imap
  describe port(143) do
    it { should be_listening.with('tcp') }
  end

  # imaps
  describe port(993) do
    it { should be_listening.with('tcp') }
  end

  it 'connects to imap SSL' do
    expect(
      command('echo | openssl s_client -connect 127.0.0.1:imaps')
        .exit_status
    ).to eq 0
  end

  it 'connects to imap with startls' do
    expect(
      command('echo | openssl s_client -starttls imap -connect 127.0.0.1:imap')
        .exit_status
    ).to eq 0
  end

  it 'is able to login using imap (plain)' do
    imap = Net::IMAP.new('localhost')
    imap.authenticate('PLAIN', 'postmaster@foobar.com', 'p0stm@st3r1')
    imap.examine('INBOX')
    imap.close
  end

  describe file('/etc/dovecot/sieve') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/dovecot/sieve/default.sieve') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/dovecot/sieve/default.svbin') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end
