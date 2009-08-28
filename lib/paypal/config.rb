module Paypal
  module Config
    IPN_URL_SANDBOX    = "https://www.sandbox.paypal.com/cgi-bin/webscr"
    IPN_URL_PRODUCTION = "https://www.paypal.com/cgi-bin/webscr"

    @@mode = :sandbox
    def self.mode=(new_mode)
      raise ArgumentError.new("Paypal::Config.mode should be either :sandbox or :production (you tried to set it as : #{new_mode})") unless [:sandbox, :production].include?(new_mode.to_sym)
      @@mode = new_mode.to_sym
    end
    def self.mode
      @@mode
    end
    
    def self.ipn_url
      case @@mode
      when :sandbox
        IPN_URL_SANDBOX
      when :production
        IPN_URL_PRODUCTION
      else
        raise StandardError.new("Please set Paypal::Config.mode to either :sandbox or :production (currently : #{current_mode})")
      end
    end
    
    def self.ipn_validation_path
      URI.parse(ipn_url).path + "?cmd=_notify-validate"
    end

    def self.ipn_validation_url
      "#{ipn_url}?cmd=_notify-validate"
    end

    @@paypal_sandbox_cert = File.read(File.join(File.dirname(__FILE__), 'certs', 'paypal_sandbox.pem'))
    def self.paypal_sandbox_cert=(new_cert)
      @@paypal_sandbox_cert = new_cert
    end
    def self.paypal_sandbox_cert
      @@paypal_sandbox_cert
    end

    @@paypal_production_cert = nil
    def self.paypal_production_cert=(new_cert)
      @@paypal_production_cert = new_cert
    end
    def self.paypal_production_cert
      @@paypal_production_cert
    end

    def self.paypal_cert
      case @@mode
      when :sandbox
        @@paypal_sandbox_cert
      when :production
        raise StandardError.new("You should set Paypal::Config.paypal_production_cert with your paypal production certificate") if @@paypal_production_cert.nil?
        @@paypal_production_cert
      else
        raise StandardError.new("Please set Paypal::Config.mode to either :sandbox or :production (currently : #{current_mode})")
      end
    end
  end
end