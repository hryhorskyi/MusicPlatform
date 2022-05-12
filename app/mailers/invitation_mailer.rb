# frozen_string_literal: true

class InvitationMailer < ApplicationMailer
  def create
    @invitation = Invitation.find_by(id: params[:invitation_id])
    mail(
      template_path: 'mailers/invitations',
      template_name: 'create',
      to: @invitation.receiver.email,
      subject: I18n.t('mailer.invitation.subject')
    )
  end

  def update
    @invitation = Invitation.find_by(id: params[:invitation_id])
    mail(
      template_path: 'mailers/invitations',
      template_name: 'update',
      to: @invitation.requestor.email,
      subject: I18n.t('mailer.invitation.subject')
    )
  end

  def destroy
    @invitation = Invitation.find_by(id: params[:invitation_id])
    mail(
      template_path: 'mailers/invitations',
      template_name: 'destroy',
      to: @invitation.receiver.email,
      subject: I18n.t('mailer.invitation.subject')
    )
  end
end
