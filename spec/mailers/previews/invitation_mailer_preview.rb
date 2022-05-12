# frozen_string_literal: true

class InvitationMailerPreview < ActionMailer::Preview
  def create
    InvitationMailer.with(invitation_id: Invitation.first&.id).create
  end

  def update
    InvitationMailer.with(invitation_id: Invitation.first&.id).update
  end

  def destroy
    InvitationMailer.with(invitation_id: Invitation.first&.id).destroy
  end
end
