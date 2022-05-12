# frozen_string_literal: true

class InvitationMailerPreview < ActionMailer::Preview
  def invitation_created
    InvitationMailer.with(invitation: Invitation.first || Invitation.new).invitation_created
  end

  def update
    InvitationMailer.with(invitation_id: Invitation.first&.id).update
  end

  def destroy
    InvitationMailer.with(invitation_id: Invitation.first&.id).destroy
  end
end
