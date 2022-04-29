# frozen_string_literal: true

class InvitationMailerPreview < ActionMailer::Preview
  def invitation_created
    InvitationMailer.with(invitation: Invitation.first || Invitation.new).invitation_created
  end
end