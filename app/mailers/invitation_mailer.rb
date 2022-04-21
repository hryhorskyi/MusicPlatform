# frozen_string_literal: true

class InvitationMailer < ApplicationMailer
  def invitation_created
    @invitation = params[:invitation]
    mail(
      to: @invitation.receiver_id,
      subject: I18n.t('mailer.invitation.action.create')
    )
  end
end
