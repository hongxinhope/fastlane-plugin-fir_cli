require 'fastlane/action'
require 'fir'
# require 'byebug'
require_relative '../helper/fir_cli_helper'

module Fastlane
  module Actions
    class FirCliAction < Action
      
      def self.run(params)
        UI.message("The fir_cli plugin is working!")

        fir_args = find_app_location(params[:specify_file_path])
        options = {
          token: params[:api_token],
          specify_file_path: params[:specify_file_path],
          force_pin_history: params[:force_pin_history],
          skip_update_icon: params[:skip_update_icon],
          specify_icon_file: params[:specify_icon_file],
          changelog: params[:changelog],
          open: params[:open],
          password: params[:password],
          need_release_id: params[:need_release_id],
          short: params[:short],
          dingtalk_access_token: params[:dingtalk_access_token],
          switch_to_qiniu: params[:switch_to_qiniu],
          dingtalk_custom_message: params[:dingtalk_custom_message]
        }.reject {|_k, v| v.nil?}
        FirHelper.publish(fir_args, options)
      end 

      def self.description
        "upload ipa or apk to fir.im using fir-cli (This plugin is maintained by fir.im official)"
      end

      def self.authors
        ["atpking"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
        "fir app info"
      end

      def self.details
        # Optional:
        "invoke fir-cli from fastlane plugin directly. \nfir-cli: https://github.com/FIRHQ/fir-cli"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :api_token,
                                       env_name: "FIR_CLI_API_TOKEN",
                                       description: "A description of your option",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :specify_file_path,
                                       env_name: "FIR_SPECIFY_FILE_PATH",
                                       description: "FILE APP PATH",
                                       default_value: nil,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :short,
                                       env_name: "FIR_APP_SHORT",
                                       description: "fir short",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :force_pin_history,
                                       env_name: "FIR_APP_FORCE_PIN_HISTORY",
                                       description: "pin this release to download page",
                                       default_value: false,
                                       type: Boolean,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :skip_update_icon,
                                       env_name: "FIR_APP_SKIP_UPDATE_ICON",
                                       description: "skip upload icon",
                                       default_value: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :specify_icon_file,
                                       env_name: "FIR_SPECIFY_ICON_FILE_PATH",
                                       description: "APP ICON FILE PATH",
                                       default_value: nil,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :changelog,
                                       env_name: "FIR_APP_CHANGELOG",
                                       description: "changelog path or content",
                                       default_value: nil,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :open,
                                       env_name: "FIR_APP_OPEN",
                                       description: "true/false if open for everyone",
                                       default_value: true,
                                       type: Boolean,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :password,
                                       env_name: "FIR_APP_PASSWORD",
                                       description: "Set password for app",
                                       default_value: nil,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :switch_to_qiniu,
                                       env_name: "FIR_SWITCH_TO_QINIU",
                                       description: "switch to qiniu upload",
                                       default_value: false,
                                       type: Boolean,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :need_release_id,
                                       env_name: "FIR_NEED_RELEASE_ID",
                                       description: "would build download url with release id",
                                       default_value: false,
                                       type: Boolean,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :dingtalk_access_token,
                                       env_name: "FIR_DINGTALK_ACCESS_TOKEN",
                                       description: "dingtalk_access_token",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :dingtalk_custom_message,
                                       env_name: "FIR_DINGTALK_CUSTOM_MESSAGE",
                                       description: "dingtalk custom message",
                                       optional: true)

        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end

      def self.find_app_location(file_path)
        file_path || Actions.lane_context[SharedValues::GRADLE_APK_OUTPUT_PATH] || Actions.lane_context[SharedValues::IPA_OUTPUT_PATH]
      end
    end

    class FirHelper
      include FIR::Util

      FIR::VERSION = "#{FIR::VERSION}-Fastlane-#{Fastlane::FirCli::VERSION}"
      class << self
        def logger
          @logger ||= Logger.new(STDOUT)
        end
      end
      
    end

    class FIR::AppUploader
      def logger
        self.class.logger
      end
      class << self
        def logger 
          @logger ||= Logger.new(STDOUT)
        end
      end
    end
  end
end
