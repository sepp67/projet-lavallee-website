---
title: Kontakt
visible: false
template: contact
proprietaire: admin
form:
  name: contact-form
  fields:
    nom:
      type: text
      label: Name
      validate:
        required: true
    email:
      type: email
      label: E-Mail
      validate:
        required: true
    telephone:
      type: text
      label: Telefon
    message:
      type: textarea
      label: Nachricht
      validate:
        required: true
    honeypot:
      type: honeypot
  buttons:
    submit:
      type: submit
      value: Senden
  process:
    - email:
        to: "{{ proprietaire_email() }}"
        reply_to: "{{ form.value('email') }}"
        subject: "[Contact lavallee.tech] Nouveau message de {{ form.value.nom }}"
        body: "{% include 'forms/contact-email.html.twig' %}"
    - redirect: /de/contact/confirmation
---

Kontaktformular (gemeinsame Definition, über `forms('contact-form')` von der
Startseite eingebunden). Der tatsächliche Empfänger steht hier nie im
Klartext: `proprietaire: admin` oben verweist auf das Grav-Konto, dessen
E-Mail-Adresse (außerhalb des Repositories festgelegt, über `GRAV_ADMIN_EMAIL`
oder die Deployment-Secrets) als Ziel verwendet wird.
