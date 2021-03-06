require 'email_subscription_updated_service'

module EmailListable
  extend ActiveSupport::Concern

  module ClassMethods
    def update_email_subscription_when_changed(user_ref, props)
      after_save Proc.new{
        obj = (user_ref == :self) ? self : send(user_ref)
        EmailSubscriptionUpdatedService.new(obj)
      }, :if => Proc.new{
        props.map{|p| return true if send(:"#{p}_changed?") }.compact.any?
      }
    end
  end
end