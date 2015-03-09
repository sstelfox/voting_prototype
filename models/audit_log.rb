class AuditLog
  include DataMapper::Resource

  property :id,         Serial

  property :message,    String, length: 255
  property :created_at, DateTime

  validates_presence_of :message, message: "An audit log can't be created without a message."

  belongs_to :user
end
