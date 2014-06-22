#
# Author:: Adam Jacob (<adam@opscode.com>)
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Copyright:: Copyright (c) 2010-2011 Opscode, Inc.
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

require 'chef/knife/ec2_base'
require 'chef/knife/winrm_base'

class Chef
  class Knife
    class Ec2VolumeCreate < Knife

      include Knife::Ec2Base
      deps do
        require 'fog'
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife ec2 volume create (options)"

      attr_reader :volume

      option :availability_zone,
        :short => "-Z ZONE",
        :long => "--availability-zone ZONE",
        :description => "The Availability Zone",
        :proc => Proc.new { |key| Chef::Config[:knife][:availability_zone] = key }

      option :ebs_size,
        :long => "--ebs-size SIZE",
        :description => "The size of the EBS volume in GB, for EBS-backed instances"

      def run
        $stdout.sync = true

        validate!

        @server = connection.servers.create_volume('us-east-1a', 5)

        msg_pair("Availability Zone", @server.availability_zone)

        print "\n#{ui.color("Waiting for instance", :magenta)}"

        # wait for instance to come up before acting against it
        @server.wait_for { print "."; ready? }

        puts("\n")
# 
#         # occasionally 'ready?' isn't, so retry a couple times if needed.
#         tries = 6
#         begin
#           create_tags(hashed_tags) unless hashed_tags.empty?
#           associate_eip(elastic_ip) if config[:associate_eip]
#         rescue Fog::Compute::AWS::NotFound, Fog::Errors::Error
#           raise if (tries -= 1) <= 0
#           ui.warn("server not ready, retrying tag application (retries left: #{tries})")
#           sleep 5
#           retry
#         end
# 
#         if vpc_mode?
#           msg_pair("Subnet ID", @server.subnet_id)
#           msg_pair("Tenancy", @server.tenancy)
#           if config[:associate_public_ip]
#             msg_pair("Public DNS Name", @server.dns_name)
#           end
#           if elastic_ip
#             msg_pair("Public IP Address", @server.public_ip_address)
#           end
#         else
#           msg_pair("Public DNS Name", @server.dns_name)
#           msg_pair("Public IP Address", @server.public_ip_address)
#           msg_pair("Private DNS Name", @server.private_dns_name)
#         end
#         msg_pair("Private IP Address", @server.private_ip_address)
# 
        #

        msg_pair("Availability Zone", @server.availability_zone)
        msg_pair("Private IP Address", @server.private_ip_address)
      end


      def validate!
        super([:aws_ssh_key_id, :aws_access_key_id, :aws_secret_access_key])
      end
    end
  end
end
