class NotifierJob < Struct.new(:notifier_method,:username,:name)
  def perform
    UserMailer.send(notifier_method,username, name).deliver_now
  end
end
