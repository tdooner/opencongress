class ContactCongressLettersFormageddonThread < ActiveRecord::Base
  belongs_to :formageddon_thread, :class_name => 'Formageddon::FormageddonThread'
  belongs_to :contact_congress_letter
end